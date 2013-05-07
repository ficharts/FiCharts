package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.chart2D.encry.ClassicPattern;
	
	public class SimpleStackedColumnRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function SimpleStackedColumnRender(series:StackedColumnSeries)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:StackedColumnSeries;
		
		/**
		 */		
		public function toClassicPattern():void
		{
			if (series.classicPattern)
				series.curRenderPattern = series.classicPattern;
			else
				series.curRenderPattern = series.classicPattern = new ClassicStackedColumnRender(series);
			
			series.clearCanvas();
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