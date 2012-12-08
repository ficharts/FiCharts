package com.fiCharts.charts.chart2D.core.dataBar
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import fl.events.DataChangeEvent;
	
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
	public class DataScrollBar extends Sprite
	{
		public function DataScrollBar(axis:AxisBase)
		{
			super();
			this.axis = axis;
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
			
			axis.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0 , true);
			axis.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
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
		public function configDataBarChart(data:Vector.<SeriesDataItemVO>, hAxis:AxisBase, vAxis:AxisBase):void
		{
			chart.dataItems = data;
			chart.hAxis = hAxis;
			chart.vAxis = vAxis;
		}
		
		/**
		 */		
		public function setChartSizeFeature(baseLine:Number, chartHeight:Number):void
		{
			chart.factor = barHeight / chartHeight;
			chart.baseLine = - baseLine * chart.factor + barHeight;
		}
		
		/**
		 */		
		private var window:DataBarWindow = new DataBarWindow;
		
		/**
		 */		
		private function rollOver(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler, false, 0, true);
		}
		
		/**
		 */		
		private function startDragHandler(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler, false, 0 , true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragHandler, false, 0, true);
			currenPos = evt.stageX;
		}
		
		/**
		 */		
		private var currenPos:Number = 0;
		
		/**
		 */		
		private function dragHandler(evt:MouseEvent):void
		{
			var offset:Number = currenPos - evt.stageX;
			axis.scrollingData(offset / (max - min));
			currenPos = evt.stageX;
			axis.stopTip();
		}
		
		/**
		 */		
		private function stopDragHandler(evt:MouseEvent):void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.DATA_SCROLLED));
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		}
		
		private function rollOut(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
		}
		
		/**
		 * 坐标轴进行任何数据缩放操作时，同步更新；
		 */		
		public function update(startPerc:Number, endPerc:Number):void
		{
			min = startPerc;
			max = endPerc; 
			
			window.winWidth = (endPerc - startPerc) * axis.size;
			window.winHeight = this.barHeight;
			
			window.render();
			window.x = startPerc * axis.size;
			window.y = ty;
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
			style.barBG.width = axis.size;
			style.barBG.height = this.barHeight;
			style.barBG.ty = ty;
			
			this.graphics.clear();
			StyleManager.drawRect(this, style.barBG);
			
			chart.chartWidth = axis.size;
			chart.chartHeight = barHeight;
			chart.y = ty;
			chart.render();
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