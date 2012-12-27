package com.fiCharts.utils.XMLConfigKit.shape
{
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;

	public interface IShape
	{
		function render(canvas:Sprite, metadata:Object):void;
		
		/**
		 */		
		function toNormal():void
		
		/**
		 */		
		function toHover():void
		
		/**
		 */		
		function toDown():void;
		
		/**
		 */		
		function get style():Style;
		
		/**
		 */		
		function set style(value:Style):void;
		
	}
}