package com.fiCharts.charts.chart2D.core.model
{
	public class SeriesDataFeature
	{
		public function SeriesDataFeature()
		{
		}
		
		private var _minValue:Object;

		public function get minValue():Object
		{
			return _minValue;
		}

		public function set minValue(value:Object):void
		{
			_minValue = value;
		}

		
		private var _maxValue:Object;

		public function get maxValue():Object
		{
			return _maxValue;
		}

		public function set maxValue(value:Object):void
		{
			_maxValue = value;
		}
		
	}
}