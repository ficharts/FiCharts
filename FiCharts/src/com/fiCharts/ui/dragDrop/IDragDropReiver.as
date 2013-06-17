package com.fiCharts.ui.dragDrop
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	/**
	 */	
	public interface IDragDropReiver extends IEventDispatcher 
	{
		/**
		 * 开始拖放，此时接收区域需要有一定的感应效果
		 */		
		function startDragDrop(dropParm:Object):void
			
		/**
		 * 停止拖放后，接手区域需停止感应，并处理拖放结果
		 */			
		function stopDragDrop():void;
		
		/**
		 * 进入接收区域
		 */		
		function into():void;
		
		/**
		 * 移出接收区域
		 */		
		function out():void;
		
		/**
		 */		
		function dragDropping(draw:Function):void;
	}
	
	
}