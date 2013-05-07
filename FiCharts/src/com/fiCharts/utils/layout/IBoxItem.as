package com.fiCharts.utils.layout
{
	public interface IBoxItem
	{
		/**
		 */		
		function set itemW(w:Number):void;
		function get itemW():Number;
		
		/**
		 */		
		function set itemH(h:Number):void;
		function get itemH():Number;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
	}
}