package com.fiCharts.charts.chart2D.core.zoomBar
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	/**
	 */	
	public class ZoomBarStyle
	{
		public function ZoomBarStyle()
		{
			super();
		}
		
		/**
		 */		
		private var _visible:Object = true;

		public function get visible():Object
		{
			return _visible;
		}

		public function set visible(value:Object):void
		{
			_visible = XMLVOMapper.boolean(value);
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
		private var _window:ZoomWindowStyle;

		/**
		 */
		public function get window():ZoomWindowStyle
		{
			return _window;
		}

		/**
		 * @private
		 */
		public function set window(value:ZoomWindowStyle):void
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
		
		/**
		 */		
		public var chartCover:Style

	}
}