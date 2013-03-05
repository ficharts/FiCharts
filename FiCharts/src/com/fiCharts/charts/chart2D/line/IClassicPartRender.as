package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Shape;

	/**
	 * 
	 * 经典的线和区域图都是节点为单位渲染
	 */	
	public interface IClassicPartRender
	{
		function renderPartUI(canvas:Shape, style:Style, metaData:Object, renderIndex:uint):void
	}
}