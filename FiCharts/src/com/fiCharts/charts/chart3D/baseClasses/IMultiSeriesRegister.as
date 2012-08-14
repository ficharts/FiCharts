package com.fiCharts.charts.chart3D.baseClasses
{
	public interface IMultiSeriesRegister
	{
		function addColumnSeries(series:ISeries):void;
		function removeColumnSeries(series:ISeries):void;
	}
}