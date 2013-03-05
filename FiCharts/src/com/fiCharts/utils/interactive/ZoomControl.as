package com.fiCharts.utils.interactive
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;

	public class ZoomControl
	{
		public function ZoomControl(canvas:DisplayObject, zoomed:IZoomCanvas)
		{
			this.zoomed = zoomed;
			this.canvas = canvas;
			
			canvas.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0 , true);
			canvas.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		private function rollOver(evt:MouseEvent):void
		{
			canvas.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomHandler, false, 0, true);
		}
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			canvas.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomHandler);
		}
		
		/**
		 */		
		private function zoomHandler(evt:TransformGestureEvent):void
		{
			zoomed.zoom(evt.scaleX);
		}
		
		/**
		 */		
		private var canvas:DisplayObject;
		
		/**
		 */		
		private var zoomed:IZoomCanvas;
		
	}
}