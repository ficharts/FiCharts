package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.style.States;

	public class DataBarWindowStyle
	{
		public function DataBarWindowStyle()
		{
		}
		
		/**
		 */		
		private var _states:States
		
		/**
		 */
		public function get states():States
		{
			return _states;
		}
		
		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = value;
		}
	}
}