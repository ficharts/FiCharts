package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.column2D.ColumnDataItem;
	
	public class StackedSeriesDataItem extends ColumnDataItem
	{
		public function StackedSeriesDataItem()
		{
			super();
		}
		
		/**
		 */		
		private var _startValue:Number;

		public function get startValue():Number
		{
			return _startValue;
		}

		public function set startValue(value:Number):void
		{
			_startValue = value;
		}

		/**
		 */		
		private var _endValue:Number;

		public function get endValue():Number
		{
			return _endValue;
		}

		public function set endValue(value:Number):void
		{
			_endValue = value;
		}
		
		/**
		 * 用于百分比堆积图显示百分比数；
		 */		
		private var _percent:String = ''

		/**
		 */
		public function get percentLabel():String
		{
			return _percent;
		}

		/**
		 * @private
		 */
		public function set percentLabel(value:String):void
		{
			_percent = value;
		}

	}
}