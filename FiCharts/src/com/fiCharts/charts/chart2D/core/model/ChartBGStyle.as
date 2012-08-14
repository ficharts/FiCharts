package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.style.ContainerStyle;
	
	public class ChartBGStyle extends ContainerStyle
	{
		public function ChartBGStyle()
		{
			super();
		}
		
		/**
		 */		
		private var _gutter:Number = 20;

		/**
		 */
		public function get gutter():Number
		{
			return _gutter;
		}

		/**
		 * @private
		 */
		public function set gutter(value:Number):void
		{
			_gutter = value;
		}
		
		/**
		 */		
		private var _gutterLeft:Number = 0

		/**
		 */
		public function get gutterLeft():Number
		{
			return _gutterLeft;
		}

		/**
		 * @private
		 */
		public function set gutterLeft(value:Number):void
		{
			_gutterLeft = value;
		}
		
		/**
		 */		
		private var _gutterRight:Number = 0

		public function get gutterRight():Number
		{
			return _gutterRight;
		}

		public function set gutterRight(value:Number):void
		{
			_gutterRight = value;
		}
		
		/**
		 */		
		private var _gutterTop:Number = 0;

		/**
		 */
		public function get gutterTop():Number
		{
			return _gutterTop;
		}

		/**
		 * @private
		 */
		public function set gutterTop(value:Number):void
		{
			_gutterTop = value;
		}
		
		/**
		 */		
		private var _gutterBottom:Number = 0;

		/**
		 */
		public function get gutterBottom():Number
		{
			return _gutterBottom;
		}

		/**
		 * @private
		 */
		public function set gutterBottom(value:Number):void
		{
			_gutterBottom = value;
		}
	}
}