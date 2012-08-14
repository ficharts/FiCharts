package com.fiCharts.charts.common
{
	/**
	 * 图表通用接口；
	 */	
	public interface IChart
	{
		/**
		 * 绘制图表， 当设定了图表的配置信息与数值后调用此方法重新绘制图表；
		 * 
		 * 图表样式改变后也需要调用此方法重新绘制图表；
		 */		
		function render():void;
		
		/**
		 * 设置图表的样式， 每个图表都有几套样式可供选择， 只需要指定样式的名称即可；
		 */		
		function setStyle(value:String):void;
		
		/**
		 * 完全自定义图表样式
		 */		
		function setCustomStyle(value:XML):void;
		
		/**
		 * 设置图表的配置文件， 通常图表的配置文件包含了数据；也可以只传递配置信息，然后调用 dataXML 接口传递数据；
		 */		
		function set configXML(value:XML):void;
		function get configXML():XML;
		
		/**
		 * 单独设图表的数据， 当需要动态改变图表数据的时候可以只刷新图表的数据即可；
		 */		
		function set dataXML(value:XML):void;
		function get dataXML():XML;
		
		/**
		 * 图表的宽度
		 */		
		function set chartWidth(value:Number):void;
		function get chartWidth():Number;
		
		/**
		 * 图表的高度 
		 */		
		function get chartHeight():Number;
		function set chartHeight(value:Number):void;
		
	}
}