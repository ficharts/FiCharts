package com.fiCharts.charts.chart2D.core.axis
{
	import flash.display.Sprite;
	
	public class AxisContianer extends Sprite
	{
		public function AxisContianer()
		{
			super();
			
			//this.mouseEnabled = this.mouseChildren = false;
		}
		
		/**
		 */		
		private var _size:Number = 0;

		/**
		 */
		public function get size():Number
		{
			return _size;
		}

		/**
		 * @private
		 */
		public function set size(value:Number):void
		{
			_size = value;
		}
			
	}
}