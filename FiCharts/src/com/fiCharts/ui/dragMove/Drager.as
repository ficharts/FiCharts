package com.fiCharts.ui.dragMove
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 */	
	public class Drager
	{
		/**
		 */		
		public function Drager(dragArea:Sprite, dragTarget:Sprite)
		{
			this.dragArea = dragArea;
			this.dragTarget = dragTarget;
			
			dragArea.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler, false, 0, true);
		}
		
		/**
		 * 设置拖动对象的活动区域
		 */		
		public function setDragRect(rect:Rectangle):void
		{
			this.dragRect = rect;
			//rect.bottom -= bottomPadding;
		}
		
		/**
		 */		
		private function stopMoveHandler(evt:MouseEvent):void
		{
			dragArea.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			dragArea.stage.removeEventListener(MouseEvent.MOUSE_UP, stopMoveHandler);
			dragTarget.cacheAsBitmap = false;
			
			(dragTarget as IDragTarget).stopDragHandler();
		}
		
		/**
		 * 面板被拖放至活动区域最低端时
		 */		
		private var bottomPadding:uint = 30;
		
		/**
		 */		
		private var dragRect:Rectangle;
		
		/**
		 */		
		private function startDragHandler(evt:MouseEvent):void
		{
			dragArea.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, 0, true);
			dragArea.stage.addEventListener(MouseEvent.MOUSE_UP, stopMoveHandler, false, 0, true);
			
			startMX = evt.stageX;
			startMY = evt.stageY;
			
			startX = dragTarget.x;
			startY = dragTarget.y;
			
			dragTarget.cacheAsBitmap = true;
			(dragTarget as IDragTarget).startDragHandler();
		}
		
		/**
		 * 开始拖动时，stage 的 mouseX 值；
		 */		
		private var startMX:Number = 0;
		
		/**
		 */		
		private var startMY:Number = 0;
		
		/**
		 * 被拖动对象的初始X值，刚开始拖动时
		 */		
		private var startX:Number = 0;
		
		/**
		 */		
		private var startY:Number = 0;
		
		/**
		 */		
		private function moveHandler(evt:MouseEvent):void
		{
			var newX:Number = startX + evt.stageX - startMX;
			var newY:Number = startY + evt.stageY - startMY;
			
			if (newX < dragRect.left)
				newX = dragRect.left;
			
			if (newX > dragRect.right - dragTarget.width)
				newX = dragRect.right - dragTarget.width;
			
			if (newY < dragRect.top)
				newY = dragRect.top;
			
			
			if (newY > dragRect.bottom - dragTarget.height)
				newY = dragRect.bottom - dragTarget.height;
			
			dragTarget.x = newX;
			dragTarget.y = newY; 
			
			evt.updateAfterEvent();
		}
		
		/**
		 */		
		private var dragTarget:Sprite;
		
		/**
		 * 拖动触控区域
		 */		
		private var dragArea:Sprite;
	}
}