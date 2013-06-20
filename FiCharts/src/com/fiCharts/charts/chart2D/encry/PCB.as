package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.core.TitleBox;
	import com.fiCharts.charts.chart2D.core.backgound.ChartBGUI;
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.pie.PieChartModel;
	import com.fiCharts.charts.chart2D.pie.PieChartProxy;
	import com.fiCharts.charts.chart2D.pie.series.PieSeries;
	import com.fiCharts.charts.chart2D.pie.series.Series;
	import com.fiCharts.charts.common.IChart;
	import com.fiCharts.charts.legend.LegendPanel;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.ui.toolTips.ToolTipsManager;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 饼图的基�
	 * 
	 * PieChartBase
	 */	
	public class PCB extends Sprite implements IChart
	{
		public function PCB()
		{
			super();
			
			init();
		}
		
		/**
		 */		
		private var _dataVOes:Vector.<Object>;
		
		/**
		 */
		public function get dataVOes():Vector.<Object>
		{
			return _dataVOes;
		}
		
		/**
		 * @private
		 */
		public function set dataVOes(value:Vector.<Object>):void
		{
			_dataVOes = value;
			
			this.ifDataChanged = true;
		}
		
		/**
		 */		
		public function ifDataScalable():Boolean
		{
			return false;
		}
		
		/**
		 */		
		public function scaleData(from:Object, to:Object):void
		{
			
		}
		
		/**
		 */		
		public function setDataScalable(value:Boolean):void
		{
			
		}
			
		/**
		 * 创建序列
		 */		
		private function createSeriesHandler(value:Vector.<PieSeries>):void
		{
			while (seriesContainer.numChildren)
				seriesContainer.removeChildAt(0);
			
			for each (var seriesItem:PieSeries in this.series)
			{
				seriesItem.dataFormatter = chartModel.dataFormatter;
				seriesContainer.addChild(seriesItem);
			}
		}
		
		
		//------------------------------------------------------
		//
		// 渲染
		//
		//------------------------------------------------------
		
		/**
		 */		
		public function render():void
		{
			if (isRendering)
				return;
			
			if (configXML && (this.dataXML || dataVOes) && chartModel.series.ifHasPie())
			{
				if(this.ifSizeChanged || this.ifDataChanged || ifStyleChanged) 
				{
					isRendering = true
						
					updateSeriesAndLegendData();
					
					renderTitle();// 渲染标题
					renderLegend(); // 渲染图例并调整好位置
					renderBG();
					layout();// 调整布局�计算出饼图位置及半径�
					
					openFlash();	
					
					isRendering = ifSizeChanged = ifDataChanged = ifStyleChanged = false;
				}
			}
			
		}
		
		/**
		 */		
		private var isRendering:Boolean = false;
		
		/**
		 */		
		private var ifSizeChanged:Boolean = false;
		
		
		
		
		//----------------------------------------------------
		//
		// 动画控制
		//
		//----------------------------------------------------
		
		
		private function openFlash():void
		{
			var seriesItem:PieSeries;
			
			// 为播放动画做准备�
			if (chartModel.animation && ifFirstRender)
			{
				flashSeriesPercent = 0;
			}
			else
			{
				flashSeriesPercent = 1;
			}
			
			renderPieSeries(flashSeriesPercent);
			
			//播放动画
			if (chartModel.animation && ifFirstRender)
			{
				flashTimmer.addEventListener(TimerEvent.TIMER, flashSeriesHandler, false, 0, true);
				flashTimmer.start();
			}
			else
			{
				this.dispatchEvent(new FiChartsEvent(FiChartsEvent.RENDERED));
			}
		}
		
		/**
		 */		
		private function flashSeriesHandler(evt:Event):void
		{
			flashSeriesPercent += flashUint;
			flashUint -= 0.0054;
			if (flashUint <= 0)
				flashUint = 0.01;
			
			if (flashSeriesPercent > 1)
			{
				ifFirstRender = false;// 新数据渲染动画仅播放一次；
				flashSeriesPercent = 1;
				flashTimmer.stop();
				flashTimmer.removeEventListener(TimerEvent.TIMER, flashSeriesHandler);
			}
			
			renderPieSeries(flashSeriesPercent);
		}
		
		/**
		 */		
		private var flashUint:Number = 0.1;
		
		/**
		 */		
		private var flashSeriesPercent:Number;
		
		/**
		 */		
		private var ifFirstRender:Boolean = true;
		
		/**
		 */		
		private var flashTimmer:Timer = new Timer(30, 0);
		
		/**
		 */
		private function renderBG():void
		{
			chartModel.chartBG.width = chartWidth;
			chartModel.chartBG.height = chartHeight;
			chartBG.render(chartModel.chartBG);
		}
		
		/**
		 */		
		private function renderPieSeries(percent:Number):void
		{
			for each (var seriesItem:PieSeries in this.series)
			{
				seriesItem.x = centerX;
				seriesItem.y = conterY;
				seriesItem.radius = pieRadius * percent;
				seriesItem.alpha = percent;
				seriesItem.rotation = 360 * percent;
				seriesItem.render();
			}
		}
		
		/**
		 */		
		private function layout():void
		{
			topContainer.x = (this.chartWidth - title.boxWidth) * 0.5;
			topContainer.y = (this.gutterTop - topContainer.height) * 0.5;
			
			//rightContainer.x = (chartWidth - this.gutterRight) + (this.gutterRight - rightContainer.width) / 2 ;
			rightContainer.y = (this.chartHeight + this.gutterTop - rightContainer.height) * 0.5;
			
			bottomContainer.x = (this.chartWidth - bottomContainer.width) * 0.5;
			bottomContainer.y = this.chartHeight - bottomContainer.height - chartModel.chartBG.paddingBottom;
			
			//leftContainer.x = chartModel.chartBG.paddingLeft;
			leftContainer.y = (this.chartHeight - leftContainer.height + this.gutterTop) * 0.5;
			
			centerX = this.xSize / 2 + this.gutterLeft;//this.chartWidth / 2;
			conterY = this.ySize / 2 + this.gutterTop;
			
			if (this.xSize <= this.ySize)
				pieRadius = xSize / 2;
			else
				pieRadius = ySize / 2;
			
			rightContainer.x = centerX + pieRadius + ((this.chartWidth - centerX - pieRadius) - rightContainer.width) / 2;
			leftContainer.x = (centerX - pieRadius - leftContainer.width) / 2;
			
		}
		
		/**
		 */		
		private var pieRadius:Number = 0;
		
		/**
		 */		
		private var centerX:Number = 0;
		
		/**
		 */		
		private var conterY:Number = 0;
		
		/**
		 */		
		private function renderTitle():void
		{
			if (this.xSize >= 0)
			{
				title.boxWidth = this.xSize;
				this.title.render();
			}
		}
		
		/**
		 * 
		 */		
		private function renderLegend():void
		{
			if (chartModel.legend.enable == false)
			{
				legendPanel.clear();
				return;
			}
			
			if (chartModel.legend.position == 'top')
			{
				legendPanel.panelWidth = this.xSize;
				legendPanel.direction = LegendPanel.HIRIZONTAL;
				
				if (title.ifHasTitles)
					legendPanel.y = chartModel.chartBG.paddingTop + title.boxHeight;
				
				this.topContainer.addChild(legendPanel);
				
				legendPanel.render();
				legendPanel.x = (xSize - legendPanel.width) / 2;
				
			}
			else if (chartModel.legend.position == 'right')
			{
				legendPanel.panelHeight = this.ySize;
				legendPanel.direction = LegendPanel.VERTICAL;
				this.rightContainer.addChild(legendPanel);
				
				legendPanel.render();
				
			}
			else if (chartModel.legend.position == 'bottom')
			{
				legendPanel.panelWidth = this.xSize;
				legendPanel.direction = LegendPanel.HIRIZONTAL;
				this.bottomContainer.addChild(legendPanel);
				legendPanel.render();
			}
			else
			{
				legendPanel.panelHeight = this.ySize;
				legendPanel.direction = LegendPanel.VERTICAL;
				this.leftContainer.addChild(legendPanel);
				legendPanel.render();
			}
			
		}
			
		/**
		 */		
		private function updateSeriesAndLegendData():void
		{
			var legends:Vector.<LegendVO> = new Vector.<LegendVO>();
			var seriesItem:PieSeries;
			
			if (ifDataChanged || this.ifStyleChanged)
			{
				if (dataVOes == null)
				{
					dataVOes = new Vector.<Object>;
					var dataVO:Object;
					for each (var item:XML in dataXML.children())
					{
						dataVO = new Object;
						XMLVOMapper.pushXMLDataToVO(item, dataVO);
						dataVOes.push(dataVO);
					}
				}
				
				for each (seriesItem in series)  
				{
					seriesItem.configed();				
					seriesItem.initData(this.dataVOes);
					
					if (chartModel.legend.enable)
						legends = legends.concat(seriesItem.legendData);
				}
				
				if (chartModel.legend.enable)
					legendPanel.legendData = legends;
			}
		}
		
		/**
		 */
		private function get series():Vector.<PieSeries>
		{
			return this.chartModel.pieSeries.items;
		}
		

		
		
		
		//-----------------------------------------------
		//
		// 配置与数�
		//
		//-----------------------------------------------
		
		/**
		 */		
		public function set configXML(value:XML):void
		{
			chartProxy.configXML = value;
			
			this.title.fresh();
			
			chartProxy.setChartModel(XMLVOMapper.extendFrom(
				chartProxy.currentStyleXML.copy(), configXML.copy()));
			
			if (configXML.hasOwnProperty('data') && configXML.data.children().length())
				this.dataXML = XML(configXML.data.toXMLString());
		}
		
		/**
		 */		
		public function get configXML():XML
		{
			return chartProxy.configXML;
		}
		
		/**
		 */		
		public function set dataXML(value:XML):void
		{
			_dataXML = value;
			
			if (dataVOes)
			{
				dataVOes.length = 0;
				dataVOes = null;
			}
			
			ifDataChanged = true;
		}
		
		/**
		 */		
		private var ifDataChanged:Boolean = false;
		
		/**
		 */		
		public function get dataXML():XML
		{
			return _dataXML;
		}
		
		/**
		 */		
		private var _dataXML:XML;
		
		
		
		
		
		//-------------------------------------------------
		//
		// 尺寸控制
		//
		//-------------------------------------------------
			
		/**
		 */		
		private function get xSize():Number
		{
			return this.chartWidth - this.gutterLeft - this.gutterRight;
		}
		
		/**
		 */		
		private function get ySize():Number
		{
			return this.chartHeight - this.gutterTop - this.gutterBottom;
		}
		
		/**
		 */		
		private function get gutterTop():Number
		{
			var temGutter:Number = this.topContainer.height + chartModel.chartBG.paddingTop * 2;
			if (temGutter > chartModel.chartBG.gutterTop)
				return temGutter;
			else
				return chartModel.chartBG.gutterTop;
		}
		
		/**
		 */		
		private function get gutterBottom():Number
		{
			var temGutter:Number = this.bottomContainer.height + chartModel.chartBG.paddingBottom * 2;
			if (temGutter > chartModel.chartBG.gutterBottom)
				return temGutter;
			else
				return chartModel.chartBG.gutterBottom;
		}
		
		/**
		 */		
		private function get gutterLeft():Number
		{
			var temGutter:Number = this.leftContainer.width + chartModel.chartBG.paddingLeft * 2;
			if (temGutter > chartModel.chartBG.gutterLeft)
				return temGutter;
			else
				return chartModel.chartBG.gutterLeft;
		}
		
		/**
		 */		
		private function get gutterRight():Number
		{
			var temGutter:Number = this.rightContainer.width + chartModel.chartBG.paddingRight * 2;
			if (temGutter > chartModel.chartBG.gutterRight)
				return temGutter;
			else
				return chartModel.chartBG.gutterRight;
		}
		
		/**
		 */		
		public function set chartWidth(value:Number):void
		{
			_chartWidth = value;
			
			this.ifSizeChanged = true;
		}
		
		/**
		 */		
		public function get chartWidth():Number
		{
			return _chartWidth;
		}
		
		/**
		 */		
		private var _chartWidth:Number = 0;
		
		/**
		 */		
		public function get chartHeight():Number
		{
			return _chartHeight;
		}
		
		/**
		 */		
		public function set chartHeight(value:Number):void
		{
			_chartHeight = value;
			
			this.ifSizeChanged = true;
		}
		
		/**
		 */		
		private var _chartHeight:Number = 0;
		
		
		
		//------------------------------------------------------
		//
		// 样式
		//
		//------------------------------------------------------
		
		/**
		 */		
		public function setStyle(newStyle:String):void
		{
			if (chartProxy.currentStyleName == newStyle) return;
			chartProxy.setCurStyleTemplate(newStyle);
			
			if (configXML)
			{
				chartProxy.setChartModel(XMLVOMapper.extendFrom(
					chartProxy.currentStyleXML.copy(), configXML.copy()));
			}
			
			ifStyleChanged = true;
		}
		
		/**
		 */		
		private var ifStyleChanged:Boolean = false;
		
		/**
		 */		
		public function setCustomStyle(value:XML):void
		{
		}
		
		/**
		 */		
		private function updateLegendStyleHandler(value:Object):void
		{
			this.legendPanel.setStyle(value as LegendStyle);
		}
		
		/**
		 */		
		private function updateTitleStyleHandler(value:Object):void
		{
			title.updateStyle(chartModel.title, chartModel.subTitle);
			this.renderTitle();
		}
		
		/**
		 * 背景区域点击后全屏模式控�
		 */		
		private function fullScreenHandler(evt:Event):void
		{
			if (chartModel.fullScreen)
			{
				if (stage.displayState == StageDisplayState.NORMAL)
					stage.displayState = StageDisplayState.FULL_SCREEN;
				else
					stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * 初始�
		 */		
		private function init():void
		{
			chartBG.doubleClickEnabled = true;
			chartBG.addEventListener(MouseEvent.DOUBLE_CLICK, fullScreenHandler, false, 0, true);
			
			addChild(chartBG);
			addChild(seriesContainer);
			
			topContainer.addChild(this.title);
			addChild(this.topContainer);
			addChild(this.rightContainer);
			addChild(this.bottomContainer);
			addChild(this.leftContainer);
			tooltipManager = new ToolTipsManager(this);
			
			XMLVOLib.addCreationHandler(Series.PIE_SERIES_CREATED, createSeriesHandler);
			XMLVOLib.addCreationHandler(Chart2DModel.UPDATE_TITLE_STYLE, updateTitleStyleHandler);
			XMLVOLib.addCreationHandler(Chart2DModel.UPDATE_LEGEND_STYLE, updateLegendStyleHandler);
			
			chartProxy = new PieChartProxy;
			chartProxy.setCurStyleTemplate();
			chartProxy.setChartModel(chartProxy.currentStyleXML);
		}
		
		/**
		 */		
		private var tooltipManager:ToolTipsManager;
		
		/**
		 */		
		private function get chartModel():PieChartModel
		{
			return chartProxy.chartModel;
		}
		
		/**
		 * 图表模型定义
		 */		
		private var chartProxy:PieChartProxy;
		
		
		
		//--------------------------------------------
		//
		// UI 相关
		//
		//--------------------------------------------
		
		
		/**
		 */		
		private var legendPanel:LegendPanel = new LegendPanel;
		
		/**
		 */		
		private var toolTipManager:ToolTipsManager;
		
		/**
		 * 图表背景 
		 */		
		protected var chartBG:ChartBGUI = new ChartBGUI;
		
		/**
		 * 标题
		 */
		private var title:TitleBox = new TitleBox;
		
		/**
		 * 
		 */		
		private var seriesContainer:Sprite = new Sprite;
		
		/**
		 */		
		private var leftContainer:Sprite = new Sprite;
		
		/**
		 */		
		private var rightContainer:Sprite = new Sprite;
		
		/**
		 */		
		private var topContainer:Sprite = new Sprite;
		
		/**
		 */		
		private var bottomContainer:Sprite = new Sprite;
	}
}