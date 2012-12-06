package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.DataScale;

	public interface IAxisPattern
	{
		function stopTips():void;
		
		function updateToolTips():void;
		
		/**
		 * 调节数据缩放的最值，比率等参数
		 */		
		function adjustZoomFactor(model:DataScale):void;
		
		/**
		 */		
		function toNormalPattern():void;
		
		/**
		 */		
		function toDataResizePattern():void;
		
		/**
		 */		
		function valueToSize(value:Object, index:int):Number
		
		/**
		 * 
		 * 用来更新缩放控制器的原始数据
		 */			
		function dataUpdated():void;
		
		/**
		 * 根据数据间隔设定当前数据集，此方法主要用于Field轴
		 */		
		function udpateIndexOfCurSourceData(step:uint):void
			
		/**
		 */		
		function beforeRender():void;
		
		/**
		 * 根据位置偏移计算出数据偏移量，确定新的当前数据区域，
		 * 
		 * 绘制此区域内的刻度；
		 * 
		 * 数据滚动可以看做是位置的整体偏移，坐标刻度数据本身没有变
		 */		
		function scrollingData(offset:Number):void;
		
		
		/**
		 * 
		 * 根据当前滚动位置，计算屏幕区域数据范围，让序列渲染此数据
		 * 
		 * 跟新缩放主控制器中当前数据范围为当前可视范围内的数据
		 */		
		function dataScrolled(dataRange:DataRange):void;
		
		/**
		 * 
		 * 当前滚动为用于辅助序列截图，控制截图呈现器的平移位置
		 * 
		 */		
		//function get currentScrollPos():Number;
		
		/**
		 * 计算当前数据范围，刻度数据间隔；
		 * 
		 * 生成刻度数据，将数据的局部与整体的关系映射成为尺寸关系
		 * 
		 * 绘制坐标轴，序列当前数据范围，滚动条
		 */		
		function dataResized(dataRange:DataRange):void;
		
		/**
		 * 获取数据在当前数据中的百分比位置， 此时总数据为当前
		 * 
		 * 数据，field轴当前数据不同于原始数据，当前数据
		 * 
		 * 只包含部分节点
		 */		
		function getPercentByData(data:Object):Number;
			
		/**
		 * 获取原始数据的辈分比位置，这与getDataPercent不同
		 */			
		function getPercentBySourceData(data:Object):Number;
			
		/**
		 * 将百分比转化为位置
		 */			
		function percentToPos(perc:Number):Number;
		
		/**
		 * 将位置转化为百分比
		 */		
		function posToPercent(pos:Number):Number;
		
		/**
		 * 构建当前数据范围内的label
		 */		
		function renderHorLabelUIs():void;
		
	}
}