package com.fiCharts.ui.dragDrop
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 */	
	public class DragDropEvent extends Event
	{
		/**
		 * 此时鼠标刚刚按下，即将开始拖动
		 */		
		public static const WILL_START_DRAG:String = "will_start_drag";
		
		/**
		 */		
		public function DragDropEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		public var dragedUI:DisplayObject;
		
		/**
		 */		
		public var dragParm:Object;
	}
}