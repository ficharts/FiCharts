package com.fiCharts.utils.graphic
{
	public class Point3D
	{
		public function Point3D()
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

		/**
		 */		
		private var _z:Number = 0;

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

	}
}