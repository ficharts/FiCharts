package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.bar.BarSeries;
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.DataRange;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.zoomBar.ZoomBar;
	import com.fiCharts.charts.chart2D.core.zoomBar.ZoomBarStyle;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.ui.toolTips.ToolTipHolder;
	import com.fiCharts.ui.toolTips.ToolTipsEvent;
	import com.fiCharts.utils.ExternalUtil;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.interactive.DragControl;
	import com.fiCharts.utils.interactive.IDragCanvas;
	import com.fiCharts.utils.interactive.ITipCanvas;
	import com.fiCharts.utils.interactive.IZoomCanvas;
	import com.fiCharts.utils.interactive.TipCanvasControl;
	import com.fiCharts.utils.interactive.ZoomControl;
	
	import flash.events.MouseEvent;
	
	
	
	//----------------------------------------------------------------------------------------
	//
	// 数据 缩放与滚动处理访方式类似，缩放过程中和滚动过程中的
	//
	// 性能开销很大，需优化区别对待
	//
	//
	//  完成缩放时：
	//  1.坐标轴计算计算尺寸缩放关系，生成新label数据， label位置偏移式定位； 
	//  2.序列整体渲染， 采用最简模式
	//  3.仅绘制当前数据范围内的坐标刻度，已经创建了的刻度UI不重复创建，除非有新的数据缩放；
	//  4.绘制当前刻度范围时同时生成刻度位置数据，交给背景网格渲染当前区域
	//
	//  滚动时：
	//  1.序列截图呈现,根据偏移量平移位置
	//  2.坐标轴，背景网格重绘当前数据区域，当前数据区域映射为序列可视区域；
	//  3.滚动条重绘
	//
	//  移动结束时：
	//  1.坐标轴根据移动位置计算新的取值范围，从而得出新的位置偏移量
	//  2.根据新的数据范围渲染序列，更新主程序的当前数据范围
	//  3.移除序列截图
	//  4.坐标轴的当前数据范围不便，除非数据缩放时才会改变其
	//  
	//
	//
	//
	//  滚动过程的截图机制
	//
	//  1.数据缩放时不截图，仅给屏幕范围内数据让序列渲染
	//  2.数据初次滚动时截取3倍屏幕范围序列图
	//  3.将截图交给截图呈现器
	//  4.只有滚动和缩放时截图才呈现，此时真正图表隐藏
	//  5.当截图范围不能满足需要时，给序列新数据并重新截图，此时一次截取一屏
	//  6.截图不会重复绘制，尺寸缩放后先清空截图呈现器
	//
	//--------------------------------------------------------------------------------------
	
	
	/**
	 * 
	 * 数据缩放的总控制类， 关键构成元素都在这里，包括多点触摸的缩放控制
	 * 
	 */	
	public class ZoomPattern implements IChartPattern, IDragCanvas, IZoomCanvas, ITipCanvas
	{
		/**
		 */		
		public function ZoomPattern(base:CB)
		{
			this.chartMain = base;
			init();
		}
		
		/**
		 */		
		public function toClassicPattern():void
		{
			if (chartMain.classicPattern)
				chartMain.currentPattern = chartMain.classicPattern;
			else
				chartMain.currentPattern = chartMain.classicPattern = new ClassicPattern(chartMain);
			
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			ExternalUtil.addCallback("onWebmousewheel", null);
			
			zoomAxis.removeEventListener(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE, updateYAxisDataRange);
			
			zoomAxis.toNomalPattern();
			zoomAxis.ifCeilEdgeValue = true;
			zoomAxis.ifHideEdgeLabel = false;
			
			tipsHolder.distory();
			tipsHolder = null;
		}
		
		/**
		 */		
		public function toZoomPattern():void
		{
		}
		
		
		
		
		
		//-----------------------------------------------------------------
		//
		//
		//
		// 初始化过程
		//
		//
		//-----------------------------------------------------------------
		
		/**
		 * 添加控制数据缩放的监听器
		 */		
		public function init():void
		{
			dragController = new DragControl(chartMain.chartCanvas, this);
			zoomControl = new ZoomControl(chartMain.chartCanvas, this);
			tipsContorl = new TipCanvasControl(chartMain.chartCanvas, this);
			
			chartMain.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
			ExternalUtil.addCallback("onWebmousewheel", onWebMouseWheel);
			
			if (tipsHolder == null)
			{
				//非锁定状态
				tipsHolder = new ToolTipHolder;
				tipsHolder.isHorizontal = true;
				tipsHolder.locked = false;
			}
		}
		
		/**
		 */		
		private var dragController:DragControl;
		private var zoomControl:ZoomControl;
		private var tipsContorl:TipCanvasControl;
		
		
		/**
		 */		
		public function configSeriesAxis(scrolAxis:AxisBase):void
		{
			//目前仅横轴方向支持数据滚动和缩放，并且仅单轴支持
			zoomAxis = scrolAxis;
			zoomAxis.addEventListener(DataResizeEvent.IF_SHOW_DATA_RENDER, ifShowDataRender, false, 0, true);
		}
		
		/**
		 * 仅当鼠标位于图表绘制区域时，数据节点才会被显示出来
		 */		
		private function ifShowDataRender(evt:DataResizeEvent):void
		{
			if (this.tipsContorl.ifMouseIn)
			{
				for each(var series:SB in chartMain.series)
					series.showDataRender();
			}
		}
		
		/**
		 */		
		public function initPattern():void
		{
			for each(var series:SB in chartMain.series)
				series.toSimplePattern();
		}
		
		/**
		 * 图表定义完，渲染之前调用, 此时序列，坐标轴刚被创建
		 */		
		public function preConfig():void
		{
			preConfigScrollAxis();
		}
		
		/**
		 * 在这里完成所有对于数据滚动轴的定义, 包括样式和数据
		 */		
		private function preConfigScrollAxis():void
		{
			if (zoomAxis is LinearAxis)
				(zoomAxis as LinearAxis).baseAtZero = false;
			
			this.zoomAxis.toZoomPattern();
			
			// 边缘数据不取整，不显示边缘标签
			zoomAxis.ifCeilEdgeValue = false;
			zoomAxis.ifHideEdgeLabel = true;
			
			var zoomBarStyle:ZoomBarStyle = new ZoomBarStyle;
			var zoomBarConfig:* = XMLVOLib.getXML(Chart2DModel.ZOOM_BAR, Model.SYSTEM)
			XMLVOMapper.fuck(zoomBarConfig, zoomBarStyle);
			
			//将滚动条的标准样式与配置样式合并
			zoomBarConfig = XMLVOMapper.extendFrom(zoomBarStyle.styleXML, zoomBarConfig);
			
			zoomBar.init(zoomBarStyle, chartMain.chartModel.zoom);
			
			//将第一个序列的数据和坐标轴克隆给滚动图表
			var series:SB = chartMain.series[0];
			
			// 创建并设置坐标轴样式
			var hAxis:AxisBase = series.horizontalAxis.clone();
			var vAxis:AxisBase = series.verticalAxis.clone();
			
			var xStyle:* = zoomBarConfig.child("chart").child("xAxis");
			var yStyle:* = zoomBarConfig.child("chart").child("yAxis");
			
			XMLVOMapper.fuck(xStyle, hAxis);
			XMLVOMapper.fuck(yStyle, vAxis);
			
			hAxis.dataUpdated();
			vAxis.dataUpdated();
			hAxis.ifCeilEdgeValue = false;
			
			zoomBar.dataRange = this.currentDataRange;
			zoomBar.setAxis(hAxis, vAxis);
			series.setZoomBarData(zoomBar);
			
			zoomAxis.addEventListener(DataResizeEvent.GET_SERIES_DATA_INDEX_BY_INDEXS, dataResizedByIndex, false, 0, true);
			zoomAxis.addEventListener(DataResizeEvent.GET_SERIES_DATA_INDEX_RANGE_BY_DATA, dataResizedByRange, false, 0, true);
			
			zoomAxis.addEventListener(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE, updateYAxisDataRange, false, 0, true);
			zoomAxis.addEventListener(DataResizeEvent.RENDER_DATA_RESIZED_SERIES, renderDataResized, false, 0, true);
		}
		
		/**
		 */		
		private function get zoomBar():ZoomBar
		{
			return zoomAxis.zoomBar;
		}
		
		/**
		 * 仅更新序列的数据特性，正向，负向，交叉数据
		 */		
		public function renderSeries():void
		{
			for each(var series:SB in chartMain.series)
			{
				if (series is BarSeries) return;//条形图的大数据彻底不支持，此处略过
					
				series.render();
			}
			
			zoomBar.render();
		}
		
		/**
		 */		
		public function renderEnd():void
		{
			if (chartMain.chartModel.zoom.changed)
			{
				currentDataRange.min = zoomAxis.getSourceDataPercent(chartMain.chartModel.zoom.start);
				currentDataRange.max = zoomAxis.getSourceDataPercent(chartMain.chartModel.zoom.end);		
				chartMain.chartModel.zoom.changed = false;
			}
			
			dataResized(currentDataRange.min, currentDataRange.max);
			
			// 计算放大比率，每次缩放的倍数，进而提升缩放的速度和体验，减少渲染次数提升性能
			zoomAxis.adjustZoomFactor(chartMain.chartModel.zoom);
		}
		
		
		
		
		
		//-----------------------------------------------------
		//
		//
		//  动态绘制
		//
		//
		//-----------------------------------------------------
		
		protected function dataResizedByIndex(evt:DataResizeEvent):void
		{
			evt.stopPropagation();
			
			for each(var series:SB in this.chartMain.series)
				series.dataResizedByIndex(evt.start, evt.end);
		}
		
		/**
		 * 
		 * 前后各多延伸一个节点
		 * 
		 */		
		protected function dataResizedByRange(evt:DataResizeEvent):void
		{
			evt.stopPropagation();
			
			PerformaceTest.start("dataResizedByRange");
			
			for each(var series:SB in this.chartMain.series)
				series.dataResizedByRange(evt.start, evt.end);
			
			PerformaceTest.end("dataResizedByRange");
		}
		
		/**
		 */		
		private function updateYAxisDataRange(evt:DataResizeEvent):void
		{
			PerformaceTest.start("updateYAxisDataRange");
			
			var axis:AxisBase;
			var ifYAxiChanged:Boolean = false;
			for each (axis in chartMain.vAxises)
			{
				axis.redayToUpdataYData()
				
				for each (var seriesItem:SB in chartMain.series)
				{
					// 别忘了图例可以控制序列的隐藏
					if(seriesItem.visible)					
						seriesItem.updateYAxisValueForScroll();
				}
				
				axis.yDataUpdated();
				axis.renderVerticalAxis();
			}
			
			this.chartMain.renderVGrid();
			
			PerformaceTest.end("updateYAxisDataRange");
		}
		
		/**
		 */		
		private function renderDataResized(evt:DataResizeEvent):void
		{
			for each(var series:SB in this.chartMain.series)
				series.renderDataResized();
		}
		
		
		
		
		
		
		
		
		//-----------------------------------------------------------
		//
		//
		// 缩放控制
		//
		//
		//------------------------------------------------------------
		
		/**
		 */		
		public function zoom(scale:Number):void
		{
			if (scale > 1)
			{
				resizeOnCanvasGesture(0.5, true, 
					scale - 1);
			}
			else
			{
				resizeOnCanvasGesture(0.5, false, 
					1 - scale);
			}
		}
		
		/**
		 */		
		private var zoomScale:Number; 
		
		/**
		 * 网页中的Flash无法接受滚轮，需要先屏蔽web中的滚轮事件，将滚动值传给Flash
		 */		
		private function onWebMouseWheel(value:Number):void
		{
			if(chartMain.chartModel.zoom.enable)
			{
				var percent:Number = chartMain.mouseX / chartMain.chartWidth;
				var ifZoomIn:Boolean = value > 0 ? true : false; 
				
				var scale:Number;
				if (ifZoomIn)
					scale = chartMain.chartModel.zoom.zoomInScale;
				else
					scale = chartMain.chartModel.zoom.zoomOutScale;
				
				resizeOnCanvasGesture(percent, ifZoomIn, scale);
			}
		}
		
		/**
		 * percent 代表触控位置
		 * 
		 * scale 是缩放的倍数
		 */		
		private function resizeOnCanvasGesture(percent:Number, ifZoomIn:Boolean, scale:Number):void
		{
			var dis:Number = this.currentDataRange.max - this.currentDataRange.min;
			var targetPer:Number = this.currentDataRange.min + dis * percent;
			var newStart:Number, newEnd:Number;
			var zoomPer:Number = dis * scale;
			var minZoom:Number = zoomPer * targetPer;
			var maxZoom:Number = zoomPer - minZoom;
			
			if (ifZoomIn) // 放大
			{
				if (dis <= 1 / chartMain.chartModel.zoom.maxScale) return;
				
				newStart = this.currentDataRange.min + minZoom
				newEnd = this.currentDataRange.max - maxZoom
			}
			else// 缩小
			{
				newStart = this.currentDataRange.min - minZoom;
				newEnd = this.currentDataRange.max + maxZoom
				
				if (newStart < 0 && newEnd <= 1)
				{
					newEnd += zoomPer;
					newStart = 0;
				}
				else if (newEnd > 1 && newStart >= 0)
				{
					newStart -= zoomPer;
					newEnd = 1;
				}
			}
			
			if (newStart < 0)
				newStart = 0;
			
			if (newEnd > 1)
				newEnd = 1;
			
			this.dataResized(newStart, newEnd);
		}
		
		/**
		 */		
		private function mouseWheelHandler(evt:MouseEvent):void
		{
			onWebMouseWheel(evt.delta);
		}
		
		/**
		 * 开始数据滚动
		 */		
		public function startScroll():void
		{
			chartMain.chartCanvas.mouseChildren = chartMain.chartCanvas.mouseEnabled = false;
		}
		
		/**
		 * 数据滚动， 数据滚动的过程中，坐标轴的当前数据区域并没改变，
		 * 
		 * 只是改变了 滚动位置
		 * 
		 */		
		public function scrolling(offset:Number, sourceOffset:Number):void
		{
			if (currentDataRange.min == 0 && currentDataRange.max == 1) return;
			
			zoomAxis.scrollingByChartCanvas(offset);
			chartMain.gridField.drawHGidLine(zoomAxis.ticks, chartMain.chartModel.gridField);
		}
		
		/**
		 */		
		public function stopScroll(offset:Number, sourceOffset:Number):void
		{
			zoomAxis.dataScrolled(this.currentDataRange);
			chartMain.chartCanvas.mouseChildren = chartMain.chartCanvas.mouseEnabled = true;
		}
		
		/**
		 *
		 * 制定数据范围，此范围是在整体数据中的比例范围， 因尺寸缩放比例好根据
		 * 
		 * 设备输入值计算，用户操控用比例方式计算，接口用原始数据转换；
		 *  
		 */		
		private function dataResized(startPercent:Number, endPercent:Number):void
		{
			if(endPercent > startPercent && startPercent >= 0 && startPercent <= 1 && endPercent >= 0 && endPercent <= 1)
			{
				currentDataRange.min = startPercent;
				currentDataRange.max = endPercent;
				
				// 坐标轴会驱动序列按照节点位置或数据范围方式完成, 序列再驱动渲染节点等的更新
				zoomAxis.dataResized(currentDataRange);
				chartMain.gridField.drawHGidLine(zoomAxis.ticks, chartMain.chartModel.gridField);
			}
		}
		
		/**
		 */		
		public function scaleData(startValue:Object, endValue:Object):void
		{
			currentDataRange.min = zoomAxis.getDataPercent(startValue);
			currentDataRange.max = zoomAxis.getDataPercent(endValue);		
			
			dataResized(currentDataRange.min, currentDataRange.max);
		}
		
		/**
		 * 图表主程序
		 */		
		private var chartMain:CB;
		
		/**
		 */		
		private var currentDataRange:DataRange = new DataRange;
		
		/**
		 */		
		private var zoomAxis:AxisBase;
		
		/**
		 */		
		public function getItemRenderFromSereis():void
		{
		}
		
		/**
		 */		
		public function renderItemRenderAndDrawValueLabels():void
		{
			
		}
		
		/**
		 */		
		public function updateValueLabelHandler(evt:ItemRenderEvent):void
		{
			
		}
		
		
		
		
		
		
		
		
		
		
		//----------------------------------------------------
		//
		//
		//  信息提示，手势控制，一切以鼠标是否位于图表画布区域为限
		//
		//
		//-----------------------------------------------------
		
		
		/**
		 * 刷新并显示信息提示， 由坐标轴定位到序列的节点
		 */		
		public function showTips():void
		{
			if (zoomAxis)
			{
				tipsHolder.clear();
				zoomAxis.updateTipsData();//先更新每个序列的tips节点
				
				// 组装tips
				for each (var series:SB in chartMain.series)
				{
					// 别忘了图例可以控制序列的隐藏
					if(series.visible)
						tipsHolder.pushTip(series.tipItem);
				}
				
				// 显示tips
				// 别忘了序列都被图例隐藏的情况
				if(tipsHolder.tipLength)
					chartMain.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tipsHolder));
			}
		}
		
		/**
		 */		
		public function hideTips():void
		{
			zoomAxis.hideDataRender();
			chartMain.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		/**
		 */		
		private var tipsHolder:ToolTipHolder;
	}
}