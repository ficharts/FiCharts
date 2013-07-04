package com.fiCharts.ui.scroll
{
	import com.fiCharts.ui.FiUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * 含有纵向滚动条的view
	 */	
	public interface IVScrollView
	{
		/**
		 * 当前滚动目标，滚动操作时控制此对象移动位置
		 */		
		function get rollContent():DisplayObject
		
		/**
		 */			
		function set rollContent(value:DisplayObject):void

		/**
		 * 滚动应用主体，滚动内容，滚动条，滚动内容的遮罩都会被添加到此容器上；
		 */		
		function get scrollApp():FiUI
			
		/**
		 * 
		 * 放置滚动内容的根容器，此容器会被添加遮罩；
		 */		
		function get viewCanvas():DisplayObjectContainer
			
		/**
		 * 绘制滚动区域的遮罩 ， 只有位于此区域内的
		 * 
		 * 内容才会被显示出来
		 */		
		function get maskRect():Rectangle;
		
		/**
		 * 内容显示区域的尺寸, 可视范围
		 */		
		function get viewHeight():Number;
		
		/**
		 */		
		function get viewWidth():Number
		
		/**
		 * 总尺寸， 总尺寸通常不变，内容区域会有尺寸伸缩
		 */		
		function get fullSize():Number;
		
		/**
		 * 内容的滚动便宜量，像素单位
		 */		
		function get off():Number;
		function set off(value:Number):void;
		
		/**
		 * 装载显示内容的容器或画布, 用遮罩层盖住他， 只显示可见部分
		 */		
		function get viewForScrolled():DisplayObject;
		
		
	}
}