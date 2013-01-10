package com.fiCharts.charts.chart2D.column2D
{
	import com.fiCharts.charts.common.SeriesDataPoint;
	
	public class ColumnDataPoint extends SeriesDataPoint
	{
		public function ColumnDataPoint()
		{
			super();
		}
		
		/**
		 */		
		private var _width:Number;
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		/**
		 */		
		private var _height:Number;
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
	}
}