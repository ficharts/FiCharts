package com.fiCharts.utils.XMLConfigKit.style
{
	import flash.events.IEventDispatcher;

	public interface IStyleUI extends IEventDispatcher
	{
		function render():void;
		
		function get style():Style;
		function set style(value:Style):void;
		
		function set metaData(value:Object):void;
		function get metaData():Object;
	}
}