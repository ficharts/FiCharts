package com.fiCharts.utils.graphic
{
	public class Point2D
	{
		public function Point2D()
		{
		}
		
		/**
		 */		
		private var _x:Number = 0;

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}
		
		/**
		 */		
		private var _y:Number = 0;

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

	}
}