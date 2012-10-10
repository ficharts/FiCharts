package com.fiCharts.charts.chart2D.core.series
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;

	public interface IDirectionSeries
	{
		/**
		 * 对应于中间值， 0； 
		 */		
		function centerBaseLine():void
			
		/**
		 * 对应于正值 
		 */			
		function upBaseLine():void
			
		/**
		 *  对应于负值
		 */			
		function downBaseLine():void
			
		/**
		 * 
		 */			
		function get controlAxis():AxisBase
	}
}