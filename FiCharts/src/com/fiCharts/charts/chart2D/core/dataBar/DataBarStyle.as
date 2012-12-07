package com.fiCharts.charts.chart2D.core.dataBar
{
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	/**
	 */	
	public class DataBarStyle
	{
		public function DataBarStyle()
		{
			super();
		}
		
		/**
		 */		
		private var _height:Number = 0;

		/**
		 */
		public function get height():Number
		{
			return _height;
		}

		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			_height = value;
		}

		/**
		 */		
		private var _barBG:Style;

		public function get barBG():Style
		{
			return _barBG;
		}

		public function set barBG(value:Style):void
		{
			_barBG = value;
		}
		
		/**
		 */		
		private var _window:DataBarWindowStyle;

		/**
		 */
		public function get window():DataBarWindowStyle
		{
			return _window;
		}

		/**
		 * @private
		 */
		public function set window(value:DataBarWindowStyle):void
		{
			_window = value;
		}
		
		/**
		 */		
		private var _chart:Style;

		/**
		 */
		public function get chart():Style
		{
			return _chart;
		}

		/**
		 * @private
		 */
		public function set chart(value:Style):void
		{
			_chart = value;
		}

	}
}