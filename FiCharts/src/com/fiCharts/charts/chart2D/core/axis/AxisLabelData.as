package com.fiCharts.charts.chart2D.core.axis
{
	/**
	 * 轴标签的值与Label， 不同的值可以对应相同的Label值；
	 */	
	public class AxisLabelData
	{
		public function AxisLabelData()
		{
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

		/**
		 *  
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
		private var _color:Object;

		/**
		 */
		public function get color():Object
		{
			return _color;
		}

		/**
		 * @private
		 */
		public function set color(value:Object):void
		{
			_color = value;
		}

	}
}