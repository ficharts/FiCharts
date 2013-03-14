package com.fiCharts.charts.chart2D.bar
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	
	public class SimpleBarRender implements ISeriesRenderPattern
	{
		public function SimpleBarRender(series:BarSeries)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:BarSeries;
		
		/**
		 */		
		public function toClassicPattern():void
		{
		}
		
		public function toSimplePattern():void
		{
		}
		
		public function renderScaledData():void
		{
		}
		
		public function render():void
		{
		}
	}
}