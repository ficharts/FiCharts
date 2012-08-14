package com.fiCharts.charts.chart2D.bubble
{
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	public class BubbleDataItem extends SeriesDataItemVO
	{
		public function BubbleDataItem()
		{
			super();
		}
		
		private var _percent:Number;

		/**
		 */
		public function get percent():Number
		{
			return _percent;
		}

		/**
		 * @private
		 */
		public function set percent(value:Number):void
		{
			_percent = value;
		}

	}
}