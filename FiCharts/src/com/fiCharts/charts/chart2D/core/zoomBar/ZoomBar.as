package com.fiCharts.charts.chart2D.core.zoomBar
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.DataRange;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.interactive.DragControl;
	import com.fiCharts.utils.interactive.IDragCanvas;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * 图表初始化时，同时完成对数据滚动条的初始化;
	 * 
	 * 预渲染时，调整数据间隔；
	 * 
	 * 正式渲染时，渲染数据滚动条；
	 * 
	 * 数据缩放时，刷新窗口状态
	 */	
	public class ZoomBar extends Sprite implements IDragCanvas
	{
		public function ZoomBar(axis:AxisBase)
		{
			super();
			this.axis = axis;
			dragControl = new DragControl(window, this);
			dragControl.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
		}
		
		/**
		 * 只是位置偏移，相当于是滚动，不是缩放；
		 */		
		private function gotoDataRange(evt:MouseEvent):void
		{
			_scrolled(- (bg.mouseX - (window.x + window.winWidth / 2)) / (max - min))
		}
		
		/**
		 */		
		public var dataRange:DataRange;
		
		/**
		 */		
		private var dragControl:DragControl;
		
		/**
		 */		
		private function downHandler(evt:MouseEvent):void
		{
			sourceX = window.x;
			udpateChartMask()
		}
		
		/**
		 */		
		private var sourceX:Number = 0;
		
		/**
		 */		
		public function startScroll():void
		{
			
		}
		
		/**
		 */		
		public function scrolling(offset:Number, sourceOffset:Number):void
		{
			var temX:Number = sourceX + sourceOffset;
			
			if (temX < 0)
				temX = 0
			else if (temX + window.winWidth > axis.size)
				temX = axis.size - window.winWidth;
			
			window.x = temX;
			udpateChartMask();
		}
		
		/**
		 */		
		public function stopScroll(offset:Number, sourceOffset:Number):void
		{
			_scrolled(- sourceOffset / (max - min));
		}
		
		/**
		 */		
		private function _scrolled(dis:Number):void
		{
			axis.scrollingByChartCanvas(dis);
			axis.dataScrolled(dataRange);
		}
			
		/**
		 */		
		public function init(style:ZoomBarStyle):void
		{
			this.style = style;
			
			bg.addEventListener(MouseEvent.MOUSE_DOWN, gotoDataRange, false, 0, true);
			this.addChild(bg);
			
			chart.chartStyle = style.chart;
			chart.grayChartStyle = style.grayChart;
			
			addChild(chart);
			
			addChild(chartCover);
			
			window.winStyle = style.window;
			this.addChild(window);
		}
		
		/**
		 */		
		private var chart:ZoomChart = new ZoomChart;
		
		/**
		 */		
		public function updateChartDataStep(value:uint):void
		{
			chart.dataStep = value;
		}
		
		/**
		 */		
		public function setAxis(horAxis:AxisBase, vAxis:AxisBase):void
		{
			chart.hAxis = horAxis;
			chart.hAxis.position = "bottom";
			chart.addChild(horAxis);
			
			chart.vAxis = vAxis;
		}
		
		/**
		 */		
		public function setData(data:Vector.<SeriesDataPoint>, vValues:Vector.<Object>):void
		{
			chart.dataItems = data;
			chart.verticalValues = vValues;
		}
		
		/**
		 */		
		private var window:ZoomWindow = new ZoomWindow;
		
		/**
		 * 坐标轴进行任何数据缩放操作时，同步更新；
		 */		
		public function updateWindowSize(startPerc:Number, endPerc:Number):void
		{
			if (this.style.visible)
			{
				min = startPerc;
				max = endPerc; 
				
				window.winWidth = (endPerc - startPerc) * axis.size;
				window.winHeight = this.barHeight;
				
				window.render();
				updateWindowPos(startPerc);
				window.y = ty;
			}
		}
		
		/**
		 */		
		public function updateWindowPos(perc:Number):void
		{
			window.x = perc * axis.size;
			udpateChartMask();
		}
		
		/**
		 */		
		private function udpateChartMask():void
		{
			chart.scrollChart(window.x, window.winWidth);
		}
		
		/**
		 */		
		private var min:Number = 0;
		private var max:Number = 0;
		
		/**
		 */		
		private var axis:AxisBase;
		
		/**
		 */		
		public function render():void
		{
			if (style.visible)
			{
				chart.chartWidth = axis.size;
				chart.chartHeight = barHeight;
				chart.y = ty;
				chart.render();
				
				style.barBG.width = axis.size;
				style.barBG.height = this.barHeight;
				style.barBG.ty = ty;
				
				bg.graphics.clear();
				StyleManager.drawRect(bg, style.barBG);
			}
		}
		
		/**
		 */		
		private var bg:Sprite = new Sprite;
		
		/**
		 */		
		public function distory():void
		{
			
		}
		
		/**
		 */		
		public function get barHeight():Number
		{
			if (this.style.visible)
				return style.height;
			else
				return 0;
		}
		
		/**
		 */		
		private function get ty():Number
		{
			return axis.labelUIsCanvas.height;
		}
		
		/**
		 */		
		private var style:ZoomBarStyle;
		
		/**
		 */		
		private var chartCover:Shape = new Shape;
	}
}