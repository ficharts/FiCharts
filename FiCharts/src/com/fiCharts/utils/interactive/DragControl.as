package com.fiCharts.utils.interactive
{
	import com.fiCharts.utils.system.OS;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	 * 拖动控制类
	 */	
	public class DragControl extends EventDispatcher
	{
		/**
		 */		
		public function DragControl(area:DisplayObject, draged:IDragCanvas)
		{
			this.area = area;
			this.draged = draged;
			
			area.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0 , true);
			area.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		private var draged:IDragCanvas;
		
		/**
		 */		
		private function rollOver(evt:MouseEvent):void
		{
			area.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		}
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			area.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		
		
		
		
		//--------------------------------------------------------
		//
		// 
		// 鼠标移动不意味着就是真正的拖动，只有移动距离大于3像素时才正
		//
	    // 开始拖动
		//
		//
		//---------------------------------------------------------
		
		
		/**
		 */		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			Mouse.cursor = flash.ui.MouseCursor.HAND;
			
			area.stage.addEventListener(MouseEvent.MOUSE_UP, upAndStopMoveHandler, false, 0 , true);
			area.stage.addEventListener(MouseEvent.MOUSE_MOVE, movingHandler, false, 0, true);
			sourcePos = currenPos = evt.stageX;
			
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		private function movingHandler(evt:MouseEvent):void
		{
			var offset:Number = evt.stageX - currenPos;
			currenPos = evt.stageX;
			var disFS:Number = currenPos - sourcePos;
			
			if (ifSrolling)
			{
				draged.scrolling(offset, disFS);
			}
			else
			{
				// 只要相对于原始位置移动距离大于特定值就证明开始了滚动
				if ((OS.isDesktopSystem || OS.isWebSystem) && Math.abs(disFS) >= 3)
				{
					ifSrolling = true;
					draged.startScroll();
				}
			}
		}
		
		/**
		 */		
		private var ifSrolling:Boolean = false;
		
		/**
		 */		
		private var currenPos:Number = 0;
		
		/**
		 */		
		private var sourcePos:Number = 0;
		
		/**
		 */		
		private function upAndStopMoveHandler(evt:MouseEvent):void
		{
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
			
			ifSrolling = false;
			area.stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingHandler);
			area.stage.removeEventListener(MouseEvent.MOUSE_UP, upAndStopMoveHandler);
			
			draged.stopScroll(evt.stageX - currenPos, evt.stageX - sourcePos);
		}
		
		
		/**
		 * 拖动控制区域， 只有当鼠标在此区域内，拖动才会被触发 
		 */		
		private var area:DisplayObject;
	}
}