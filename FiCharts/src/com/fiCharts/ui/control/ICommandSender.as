package com.fiCharts.ui.control
{
	public interface ICommandSender
	{
		/**
		 * 指令名称
		 */		
		function get command():String;
		function set command(value:String):void;
	}
}