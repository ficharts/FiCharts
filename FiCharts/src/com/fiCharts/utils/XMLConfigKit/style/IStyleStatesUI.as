package com.fiCharts.utils.XMLConfigKit.style
{
	import flash.events.IEventDispatcher;

	public interface IStyleStatesUI extends IEventDispatcher
	{
		function get states():States;
		function set states(value:States):void;
		
		function render():void;
		
		function get currState():Style;
		function set currState(value:Style):void;
		
		function hoverHandler():void;
		function normalHandler():void;
		function downHandler():void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		
	}
}