package com.fiCharts.charts.chart3D.baseClasses
{
	import com.fiCharts.charts.common.SeriesDataItemVO;

	public interface IItemRenderVO
	{
		function get itemVO():SeriesDataItemVO;
		function set itemVO(value:com.fiCharts.charts.common.SeriesDataItemVO):void;
	}
}