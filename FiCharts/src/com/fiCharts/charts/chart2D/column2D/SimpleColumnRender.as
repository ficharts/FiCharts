package com.fiCharts.charts.chart2D.column2D
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	
	/**
	 */	
	public class SimpleColumnRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function SimpleColumnRender(series:ColumnSeries2D)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:ColumnSeries2D;
		
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