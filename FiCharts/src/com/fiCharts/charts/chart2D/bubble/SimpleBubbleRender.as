package com.fiCharts.charts.chart2D.bubble
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	
	public class SimpleBubbleRender implements ISeriesRenderPattern
	{
		public function SimpleBubbleRender(bubble:BubbleSeries)
		{
			this.bubble = bubble;
		}
		
		/**
		 */		
		private var bubble:BubbleSeries
		
		/**
		 */		
		public function toClassicPattern():void
		{
			if (bubble.classicPattern)
				bubble.curRenderPattern = bubble.classicPattern;
			else
				bubble.curRenderPattern = bubble.classicPattern = new ClassicBubbleRender(bubble);
			
			bubble.clearCanvas();
		}
		
		/**
		 */		
		public function toSimplePattern():void
		{
		}
		
		/**
		 */		
		public function renderScaledData():void
		{
		}
		
		/**
		 */		
		public function render():void
		{
		}
	}
}