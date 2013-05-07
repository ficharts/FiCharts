package com.fiCharts.utils.interactive
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 */	
	public class TipCanvasControl
	{
		public function TipCanvasControl(canvas:DisplayObject, tipCanvas:ITipCanvas)
		{
			this.canvas = canvas;
			this.tipsCanvas = tipCanvas;
			
			canvas.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0 , true);
			canvas.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		private function rollOver(evt:MouseEvent):void
		{
			ifMouseIn = true;
			
			this.showTips();
			canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0 , true);
			canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		}
		
		/**
		 */		
		public var ifMouseIn:Boolean = false;
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			ifMouseIn = false;
			
			tipsCanvas.hideTips();
			canvas.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 */		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			ifMouseDown = true;
			tipsCanvas.hideTips();
			
			canvas.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			canvas.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0 , true);
		}
		
		/**
		 */		
		private function mouseMoveHandler(evt:MouseEvent):void
		{
			showTips();
		}
		
		/**
		 */		
		private function mouseUpHandler(evt:MouseEvent):void
		{
			ifMouseDown = false;
			
			if (ifMouseIn)
			{
				canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0 , true);
				showTips();
			}
			
			canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 */		
		private function showTips():void
		{
			if (ifMouseDown) return;
			
			tipsCanvas.showTips();
		}
		
		/**
		 */		
		private var ifMouseDown:Boolean = false;
		
		/**
		 */		
		private var canvas:DisplayObject;
		
		/**
		 */		
		private var tipsCanvas:ITipCanvas;
	}
}