package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.DataRange;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.ui.toolTips.ToolTipHolder;
	import com.fiCharts.ui.toolTips.ToolTipsEvent;
	import com.fiCharts.utils.ExternalUtil;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.system.OS;
	
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	
	
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
	public class DataScalablePattern implements IChartPattern
	{
		/**
		 */		
		public function DataScalablePattern(base:ChartMain)
		{
			this.chartMain = base;
			init();
		}
		
		/**
		 */		
		public function toClassicPattern():void
		{
			_leaveChartCanvas();
			
			if (chartMain.classicPattern)
				chartMain.currentPattern = chartMain.classicPattern;
			else
				chartMain.currentPattern = new ClassicPattern(chartMain);
			
			chartMain.chartCanvas.removeEventListener(MouseEvent.ROLL_OVER, mouseInSeriesArea);
			chartMain.chartCanvas.removeEventListener(MouseEvent.ROLL_OUT, mouseOutSeriesArea);
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
			scrollBaseAxis.removeEventListener(DataResizeEvent.DATA_SCROLLED, dataScolledByDataBar);
			scrollBaseAxis.removeEventListener(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE, updateYAxisDataRange);
			
			ExternalUtil.addCallback("onWebmousewheel", null);
			
			scrollBaseAxis.toNomalPattern();
			tipsHolder.distory();
			tipsHolder = null;
		}
		
		/**
		 * 添加控制数据缩放的监听器
		 */		
		public function init():void
		{
			chartMain.chartCanvas.addEventListener(MouseEvent.ROLL_OVER, mouseInSeriesArea, false, 0 ,true);
			chartMain.chartCanvas.addEventListener(MouseEvent.ROLL_OUT, mouseOutSeriesArea, false, 0, true);
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
		private function updateYAxisDataRange(evt:DataResizeEvent):void
		{
			PerformaceTest.start("updateYAxisDataRange");
			
			var axis:AxisBase;
			var ifYAxiChanged:Boolean = false;
			for each (axis in chartMain.vAxises)
			{
				axis.redayToUpdataYData()
				
				for each (var seriesItem:SeriesBase in chartMain.series)
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
		 * 图表定义完，渲染之前调用, 此时序列，坐标轴刚被创建
		 */		
		public function preConfig():void
		{
			for each(var series:SeriesBase in chartMain.series)
				series.toSimplePattern();
			
			preConfigScrollAxis();
		}
		
		/**
		 * 在这里完成所有对于数据滚动轴的定义
		 */		
		private function preConfigScrollAxis():void
		{
			if (scrollBaseAxis is LinearAxis)
				(scrollBaseAxis as LinearAxis).baseAtZero = false;
			
			this.scrollBaseAxis.toDataScalePatter();
			scrollBaseAxis.initDataBar(chartMain.chartModel.dataBar);
			
			//将第一个序列的数据和坐标轴给予数据渲染图表
			var series:SeriesBase = chartMain.series[0];
			scrollBaseAxis.configDataBarChart(series.dataItemVOs.concat(), 
				series.horizontalAxis, series.verticalAxis);
			
			scrollBaseAxis.addEventListener(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE, updateYAxisDataRange, false, 0, true);
			scrollBaseAxis.addEventListener(DataResizeEvent.DATA_SCROLLED, dataScolledByDataBar, false, 0, true);
		}
		
		/**
		 * 仅更新序列的数据特性，正向，负向，交叉数据
		 */		
		public function renderSeries():void
		{
			for each(var series:SeriesBase in chartMain.series)
				series.render();
			
			series = chartMain.series[0];
			scrollBaseAxis.setChartSizeFeature(series.baseLine, chartMain.sizeY);
			scrollBaseAxis.renderDataBar();
		}
		
		/**
		 */		
		public function renderEnd():void
		{
			if (currentDataRange == null)
				currentDataRange = new DataRange;
			
			if (chartMain.chartModel.dataScale.changed)
			{
				currentDataRange.min = scrollBaseAxis.getSourceDataPercent(chartMain.chartModel.dataScale.start);
				currentDataRange.max = scrollBaseAxis.getSourceDataPercent(chartMain.chartModel.dataScale.end);		
				chartMain.chartModel.dataScale.changed = false;
			}
			
			dataResized(currentDataRange.min, currentDataRange.max);
			
			// 计算放大比率，每次缩放的倍数，进而提升缩放的速度和体验，减少渲染次数提升性能
			scrollBaseAxis.adjustZoomFactor(chartMain.chartModel.dataScale);
		}
		
		/**
		 */		
		public function toScalablePattern():void
		{
		}
		
		/**
		 */		
		private function mobileZoomHandler(evt:TransformGestureEvent):void
		{
			if (evt.scaleX > 1)
			{
				resizeOnCanvasGesture(0.5, true, 
					evt.scaleX - 1);
			}
			else
			{
				resizeOnCanvasGesture(0.5, false, 
					1 - evt.scaleX);
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
			if(chartMain.chartModel.dataScale.enable)
			{
				var percent:Number = chartMain.mouseX / chartMain.chartWidth;
				var ifZoomIn:Boolean = value > 0 ? true : false; 
				
				var scale:Number;
				if (ifZoomIn)
					scale = chartMain.chartModel.dataScale.zoomInScale;
				else
					scale = chartMain.chartModel.dataScale.zoomOutScale;
				
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
				if (dis <= 1 / chartMain.chartModel.dataScale.maxScale) return;
				
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
		 */		
		private function stageDownHadler(evt:MouseEvent):void
		{
			ifMouseDown = true;
			
			this.hideTips();
			currentPosition = evt.stageX;
			chartMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkScrollHandler);
		}
		
		/**
		 */		
		private function stopMoveHandler(evt:MouseEvent):void
		{
			ifMouseDown = false;
			
			updateTips();
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkScrollHandler);
		}
		
		/**
		 * 鼠标按下后，隐藏tips， 松开显示tips；
		 * 
		 * 为了防止拖拽时显示tips，故设定此值用来判断
		 */		
		private var ifMouseDown:Boolean = false;
		
		/**
		 */		
		private function checkScrollHandler(evt:MouseEvent):void
		{
			if (currentDataRange.min == 0 && currentDataRange.max == 1) return;
			
			var offset:Number = evt.stageX - currentPosition; 
			
			if (ifSrollingData)
			{
				scroll(offset);
				currentPosition = evt.stageX;
			}
			else
			{
				// 只要有一次移动距离大于特定值就证明开始了滚动
				if (OS.isDesktopSystem && Math.abs(offset) >= 3)
					startScroll();
				else
					startScroll();
			}
		}
		
		/**
		 * 数据缩放条滚动结束时触发
		 */		
		private function dataScolledByDataBar(evt:DataResizeEvent):void
		{
			evt.stopPropagation();
			_stopScroll();
		}
		
		/**
		 * 开始数据滚动
		 */		
		private function startScroll():void
		{
			ifSrollingData = true;
			
			chartMain.stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			chartMain.chartCanvas.mouseChildren = chartMain.chartCanvas.mouseEnabled = false;
		}
		
		/**
		 * 数据滚动， 数据滚动的过程中，坐标轴的当前数据区域并没改变，
		 * 
		 * 只是改变了 滚动位置
		 * 
		 */		
		private function scroll(offset:Number):void
		{
			scrollBaseAxis.scrollingData(offset);
			chartMain.gridField.drawHGidLine(scrollBaseAxis.ticks, chartMain.chartModel.gridField);
		}
		
		/**
		 * 结束数据滚动
		 */		
		private function stopScroll(evt:MouseEvent):void
		{
			_stopScroll();
		}
		
		/**
		 */		
		private function _stopScroll():void
		{
			ifSrollingData = false;
			
			scrollBaseAxis.dataScrolled(this.currentDataRange);
			chartMain.chartCanvas.mouseChildren = chartMain.chartCanvas.mouseEnabled = true;
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			
			// 鼠标移出画布区域，停止拖动后不更新提示信息
			if(ifMouseInCanvas())
				updateTips();
			else
				_leaveChartCanvas();
		}
		
		/**
		 * 不是鼠标按下后一移动就还是数据滚动，而是移动一小段距离后才
		 * 
		 * 正式开始滚动数据
		 */		
		private var ifSrollingData:Boolean = false;
		
		/**
		 */		
		private var currentPosition:Number = 0;
		
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
				scrollBaseAxis.dataResized(currentDataRange);
				chartMain.gridField.drawHGidLine(scrollBaseAxis.ticks, chartMain.chartModel.gridField);
				
				
				if(ifMouseInCanvas() == false)
					this.hideTips();
			}
		}
		
		
		/**
		 */		
		private var dataDis:Number = 0;
		
		/**
		 * 图表主程序
		 */		
		private var chartMain:ChartMain;
		
		/**
		 */		
		public function configSeriesAxis(scrolAxis:AxisBase):void
		{
			//目前仅横轴方向支持数据滚动和缩放，并且仅单轴支持
			scrollBaseAxis = scrolAxis;
		}
		
		/**
		 */		
		private var currentDataRange:DataRange;
		
		/**
		 */		
		private var scrollBaseAxis:AxisBase;
		
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
		
		/**
		 */		
		public function scaleData(startValue:Object, endValue:Object):void
		{
			currentDataRange.min = scrollBaseAxis.getDataPercent(startValue);
			currentDataRange.max = scrollBaseAxis.getDataPercent(endValue);		
			
			dataResized(currentDataRange.min, currentDataRange.max);
		}
		
		
		
		
		
		
		
		
		//----------------------------------------------------
		//
		//
		//  信息提示，手势控制，一切以鼠标是否位于图表画布区域为限
		//
		//
		//-----------------------------------------------------
		
		/**
		 */		
		private function mouseInSeriesArea(evt:MouseEvent):void
		{
			this.gotoChartCanvas();
		}
		
		/**
		 */		
		private function mouseOutSeriesArea(evt:MouseEvent):void
		{
			this.leaveChartCanvas();
		}
										   
		/**
		 * 
		 */		
		private function toolTipsHandler(evt:MouseEvent):void
		{
			// 防止鼠标移出图表画布区域继续信息提示
			if(ifMouseInCanvas() == false)
			{
				this._leaveChartCanvas(); 
			}
			else
			{
				updateTips();
			}
		}
		
		/**
		 * 
		 * 鼠标移出图表画布区域，结束信息提示，还原鼠标状态
		 */		
		private function leaveChartCanvas():void
		{
			// 防止鼠标依旧位于图表画布中， 但由于其他罩盖引起的的  rollOut
			if(ifMouseInCanvas())
				return; 
			
			_leaveChartCanvas();
		}
		
		/**
		 */		
		private function ifMouseInCanvas():Boolean
		{
			if(chartMain.chartCanvas.hitTestPoint(chartMain.stage.mouseX, chartMain.stage.mouseY))
				return true;
			
			return false;
		}
		
		/**
		 * 鼠标进入图表画布区域，开始信息提示，改变鼠标状态
		 */		
		private function gotoChartCanvas():void
		{
			chartMain.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDownHadler, false, 0, true);
			chartMain.stage.addEventListener(MouseEvent.MOUSE_UP, stopMoveHandler, false, 0, true);
			chartMain.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, mobileZoomHandler, false, 0, true);
			
			chartMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, toolTipsHandler, false, 0, true);
			
			Mouse.cursor = flash.ui.MouseCursor.HAND;
		}
		
		/**
		 */		
		private function _leaveChartCanvas():void
		{
			if (this.ifSrollingData) return;
			
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageDownHadler);
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_UP, stopMoveHandler);
			chartMain.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, mobileZoomHandler);
			
			chartMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, toolTipsHandler);
			
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
			hideTips();
		}
		
		/**
		 * 刷新并显示信息提示， 由坐标轴定位到序列的节点
		 */		
		private function updateTips():void
		{
			if (scrollBaseAxis && ifMouseDown == false)
			{
				tipsHolder.clear();
				scrollBaseAxis.updateToolTips();
				
				for each (var series:SeriesBase in chartMain.series)
				{
					// 别忘了图例可以控制序列的隐藏
					if(series.visible)
						tipsHolder.pushTip(series.tipItem);
				}
				
				// 别忘了序列都被图例隐藏的情况
				if(tipsHolder.tipLength)
					chartMain.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tipsHolder));
			}
		}
		
		/**
		 */		
		private function hideTips():void
		{
			scrollBaseAxis.stopTip();
			chartMain.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		
		/**
		 */		
		private var tipsHolder:ToolTipHolder;
	}
}