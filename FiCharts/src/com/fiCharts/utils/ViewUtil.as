package com.fiCharts.utils
{
	import flash.display.Sprite;

	public class ViewUtil
	{
		public function ViewUtil()
		{
		}
		
		/**
		 */		
		public static function show(value:Sprite):void
		{
			value.visible = value.mouseChildren = value.mouseEnabled = true;
		}
		
		/**
		 */		
		public static function hide(value:Sprite):void
		{
			value.visible = value.mouseChildren = value.mouseEnabled = false;
		}
	}
}