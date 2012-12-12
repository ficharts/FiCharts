package com.fiCharts.charts.chart2D.core.dataBar
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.DataRange;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.interactive.DragControl;
	import com.fiCharts.utils.interactive.IDragCanvas;
	
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
	public class DataScrollBar extends Sprite implements IDragCanvas
	{
		public function DataScrollBar(axis:AxisBase)
		{
			super();
			this.axis = axis;
			dragControl = new DragControl(window, this);
			dragControl.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
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
		}
		
		/**
		 */		
		public function stopScroll(offset:Number, sourceOffset:Number):void
		{
			axis.scrollingByChartCanvas(- sourceOffset / (max - min));
			axis.dataScrolled(dataRange);
		}
			
		/**
		 */		
		public function init(style:DataBarStyle):void
		{
			this.style = style;
			
			chart.style = style.chart;
			addChild(chart);
			
			window.winStyle = style.window;
			this.addChild(window);
		}
		
		/**
		 */		
		private var chart:DataChart = new DataChart;
		
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
			chart.addChildAt(horAxis, 0);
			
			chart.vAxis = vAxis;
		}
		
		/**
		 */		
		public function setData(data:Vector.<SeriesDataItemVO>, vValues:Vector.<Object>):void
		{
			chart.dataItems = data;
			chart.verticalValues = vValues;
		}
		
		/**
		 */		
		private var window:DataBarWindow = new DataBarWindow;
		
		/**
		 * 坐标轴进行任何数据缩放操作时，同步更新；
		 */		
		public function updateWindowSize(startPerc:Number, endPerc:Number):void
		{
			min = startPerc;
			max = endPerc; 
			
			window.winWidth = (endPerc - startPerc) * axis.size;
			window.winHeight = this.barHeight;
			
			window.render();
			updateWindowPos(startPerc);
			window.y = ty;
		}
		
		/**
		 */		
		public function updateWindowPos(perc:Number):void
		{
			window.x = perc * axis.size;
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
			chart.chartWidth = axis.size;
			chart.chartHeight = barHeight;
			chart.y = ty;
			chart.render();
			
			style.barBG.width = axis.size;
			style.barBG.height = this.barHeight;
			style.barBG.ty = ty;
			this.graphics.clear();
			StyleManager.drawRect(this, style.barBG);
		}
		
		/**
		 */		
		public function distory():void
		{
			
		}
		
		/**
		 */		
		public function get barHeight():Number
		{
			return style.height;
		}
		
		/**
		 */		
		private function get ty():Number
		{
			return axis.labelUIsCanvas.height;
		}
		
		/**
		 */		
		private var style:DataBarStyle;
	}
}