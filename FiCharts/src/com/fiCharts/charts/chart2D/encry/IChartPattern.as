package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.series.ChartCanvas;
	
	import flash.display.Stage;

	/**
	 * 图表构建渲染机制的状态接口， 分经典和缩放两种状态
	 * 
	 * 经典模式适用于数据量不多的情况， 缩放模式支持大数据量
	 * 
	 * 经典模式漂亮高交互，缩放模式UI精简，渲染轻量，交互简单
	 * 
	 * 状态的创建于切换由 DataScale 控制， 数据建模阶段就搞定状态初始化， 同时
	 * 
	 * 支持动态的状态切换 
	 * 
	 * 
	 * 
	 * 数据缩放是非常关键的功能分水岭，开启后，图表的构建与渲染模式会大调：
	 * 
	 * 1.ItemRender 与  ValueLabel 不在构建，信息提示模式改为全局模式，统一处理；
	 * 
	 * 2.图表序列节点不再渲染，而是范围内数据一起渲染在序列Canvas上
	 * 
	 * 3.图表整体渲染模式也会改变， 不再进行动画，并且直接根据数据范围渲染局部数据
	 * 
	 * 4.如果没有设定数据范围时，默认渲染所有数据；
	 * 
	 * 5.主程序会存在两种状态，缩放态和经典态，而且可以相互变态；
	 * 
	 * 6.主程序的状态切换会映射到坐标轴和序列上；
	 * 
	 */	
	public interface IChartPattern
	{
		function init():void
		
		function toZoomPattern():void
			
		function toClassicPattern():void
			
		/**
		 * 
		 */			
		function initPattern():void
			
		/**
		 * 定义序列，坐标轴的模式： 经典还是数据缩放模式
		 * 
		 * 此方法在图表渲染之前才会被调用，此时序列和坐标轴的渲染模式才会被设定
		 * 
		 * 因为序列和坐标轴必须创建定义好了才能设定器渲染模式，无法及时设置；
		 */			
		function preConfig():void;
		
		/**
		 * 经典模式下直接渲染整个序列，缩放模式下仅创建并渲染部分数据节点 
		 */		
		function renderSeries():void;
		
		/**
		 * 经典模式熏染结束需要播放动画
		 */		
		function renderEnd():void
			
		/**
		 * 设置数据滚动轴，目前仅支持横向数据滚动
		 */		
		function configSeriesAxis(scrolAxis:AxisBase):void
			
		/**
		 * 经典模式需要构建渲染点和数值标签
		 */		
		function getItemRenderFromSereis():void;
		
		function renderItemRenderAndDrawValueLabels():void;
			
		function updateValueLabelHandler(evt:ItemRenderEvent):void
			
		/**
		 */			
		function scaleData(startValue:Object, endValue:Object):void;
			
	}
}