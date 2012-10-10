package com.fiCharts.utils
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class StageUtil
	{
		/**
		 * @param stage
		 */		
		public static function initStage( stage : Stage ) : void
		{
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		/**
		 */		
		private static var handler:Function;
		private static var container:Sprite;
		
		/**
		 * @param container
		 * @param handler
		 */		
		public static function initApplication(_container:Sprite, _handler:Function):void
		{
			handler = _handler;
			container = _container;
			container.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, 0, true);
		}
		
		/**
		 * @param evt
		 */		
		private static function addToStageHandler(evt:Event):void
		{
			if (container.stage.stageWidth == 0)
			{
				container.stage.addEventListener(Event.RESIZE, initResizeHandler, false, 0, true);
				container.stage.dispatchEvent(new Event(Event.RESIZE));
			}
			else
			{
				ready();
			}
		}
		
		/**
		 * 解决IE下Flash初始化舞台尺寸无法获取的问题。
		 */		
		private static function initResizeHandler(evt:Event):void
		{
			if (container.stage.stageWidth > 0)
			{
				container.stage.removeEventListener(Event.RESIZE, initResizeHandler);
				ready();
			}
		}
		
		/**
		 */		
		private static function ready():void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			initStage(container.stage);
			handler();
			handler = null;
			container = null;
		}
		
		/**
		 */		
		public function StageUtil()
		{
		}
	}
}