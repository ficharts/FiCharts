package com.fiCharts.utils
{
	import flash.display.Sprite;

	/**
	 */	
	public class StageUtil
	{
		/**
		 */		
		public function StageUtil()
		{
		}
		
		/**
		 */		
		public static function initApplication(container:Sprite, handler:Function):void
		{
			new App(container, handler);
		}
	}
	
}





//------------------------------------
//
//
// 当一个应用中有多个app需要初始化时，必须
// 
// 多核方式处理，不能用静态方法。
//
//
//-------------------------------------


import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.system.IME;

/**
 */
class App
{
	/**
	 */	
	public function App(target:Sprite, initFun:Function)
	{
		handler = initFun;
		container = target;
		container.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, 0, true);
		apps.push(this);
	}
	
	/**
	 */		
	internal static var apps:Array = [];
	
	/**
	 * @param evt
	 */		
	private function addToStageHandler(evt:Event):void
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
	private function initResizeHandler(evt:Event):void
	{
		if (container && container.stage.stageWidth >= 0)
		{
			container.stage.removeEventListener(Event.RESIZE, initResizeHandler);
			ready();
		}
	}
	
	/**
	 */		
	private function ready():void
	{
		container.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		initStage(container.stage);
		handler();
		handler = null;
		container = null;
		
		apps.splice(apps.indexOf(this), 1);
	}
	
	/**
	 * @param stage
	 */		
	public function initStage(stage:Stage):void
	{
		stage.stageFocusRect = false;
		stage.tabChildren = false;
		
		stage.quality = StageQuality.BEST;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
	}
	
	/**
	 */		
	private var handler:Function;
	
	/**
	 */	
	private var container:Sprite;
	
}