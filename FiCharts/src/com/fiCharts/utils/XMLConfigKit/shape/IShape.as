package com.fiCharts.utils.XMLConfigKit.shape
{
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;

	public interface IShape
	{
		function render(canvas:Sprite, metadata:Object):void;
		
		/**
		 */		
		function get style():Style;
		
		/**
		 */		
		function set style(value:Style):void;
		
		/**
		 */		
		function get states():States;
		
		/**
		 */		
		function set states(value:States):void;
		
		/**
		 */		
		function setSize(value:uint):void;
		
	}
}