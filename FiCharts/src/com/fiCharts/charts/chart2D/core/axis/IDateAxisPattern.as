package com.fiCharts.charts.chart2D.core.axis
{
	public interface IDateAxisPattern
	{
		/**
		 * 将Time类型的时间转换为合理的时间显示格式；
		 */		
		function dateTimeToString(value:Object):String;
		
		/**
		 */		
		function set output(value:String):void
		
		/**
		 */			
		function get output():String;
	}
}