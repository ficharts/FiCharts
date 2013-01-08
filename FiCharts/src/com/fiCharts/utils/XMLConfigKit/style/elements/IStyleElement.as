package com.fiCharts.utils.XMLConfigKit.style.elements
{
	/**
	 * 此类对象可以定义样式，用新样式模版更新样式
	 */	
	public interface IStyleElement
	{
		/**
		 */		
		function get style():String;
		
		/**
		 */		
		function set style(value:String):void;
	}
}