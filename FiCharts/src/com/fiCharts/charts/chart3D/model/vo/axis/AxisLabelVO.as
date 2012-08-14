package com.fiCharts.charts.chart3D.model.vo.axis
{
	public class AxisLabelVO
	{
		public function AxisLabelVO()
		{
		}
		
		/**
		 */		
		private var _x:Number;

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
		private var _y:Number;

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
		private var _label:String;

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
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
	}
}