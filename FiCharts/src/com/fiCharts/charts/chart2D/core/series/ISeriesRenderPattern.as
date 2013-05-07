package com.fiCharts.charts.chart2D.core.series
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;

	/**
	 * 两种序列渲染模式，经典模式和数据缩放模式；
	 * 
	 * 真正的渲染都是在模式中，不同类型的序列采取自己的两种模式
	 */	
	public interface ISeriesRenderPattern
	{
		/**
		 * 经典渲染模式和 数据缩放渲染模式的切换 
		 * 
		 */		
		function toClassicPattern():void;
		function toSimplePattern():void;
		
		/**
		 * 渲染范围内的离散数据
		 * 
		 * 缩放模式是仅刷新一定范围内并且是离散式的刷新
		 */		
		function renderScaledData():void;
		
		/**
		 * 缩放模式下：样式，尺寸，数值分布特性的设定，但不渲染图表，
		 * 
		 * 图表渲染是由坐标轴驱动的
		 * 
		 * 
		 * 经典模式下：创建节点UI, 渲染节点UI；；
		 */		
		function render():void;
		
	}
}