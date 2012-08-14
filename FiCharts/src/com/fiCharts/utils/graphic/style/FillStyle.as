package com.fiCharts.utils.graphic.style
{
	import com.fiCharts.utils.graphic.StyleManager;

	public class FillStyle
	{
		public function FillStyle()
		{
		}
		
		/**
		 */		
		private var _color:Object;
		
		public function get color():Object
		{
			return _color;
		}
		
		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}
		
		/**
		 */		
		private var _alpha:Number;

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}

	}
}