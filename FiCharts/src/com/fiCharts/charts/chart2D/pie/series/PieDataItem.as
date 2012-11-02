package com.fiCharts.charts.chart2D.pie.series
{
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	public class PieDataItem extends SeriesDataItemVO
	{
		public function PieDataItem()
		{
			super();
		}
		
		/**
		 */		
		private var _label:Object

		public function get label():Object
		{
			return _label;
		}

		public function set label(value:Object):void
		{
			_label = value;
		}
		
		/**
		 */		
		private var _value:Object;

		public function get value():Object
		{
			return _value;
		}

		public function set value(value:Object):void
		{
			_value = value;
		}
		
		/**
		 */		
		private var _startAngle:Number = 0;

		/**
		 */
		public function get startRad():Number
		{
			return _startAngle;
		}

		/**
		 * @private
		 */
		public function set startRad(value:Number):void
		{
			_startAngle = value;
		}
		
		/**
		 */		
		private var _endAngle:Number;

		/**
		 */
		public function get endRad():Number
		{
			return _endAngle;
		}

		/**
		 * @private
		 */
		public function set endRad(value:Number):void
		{
			_endAngle = value;
		}

	}
}