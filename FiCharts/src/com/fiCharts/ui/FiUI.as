package com.fiCharts.ui
{
	import com.fiCharts.utils.StageUtil;
	
	import flash.display.Sprite;
	import com.fiCharts.ui.tips.ITipsSender;
	import com.fiCharts.ui.tips.TipsHolder;
	
	/**
	 */	
	public class FiUI extends Sprite implements ITipsSender
	{
		public function FiUI()
		{
			StageUtil.initApplication(this, addToDisplayList);
		}
		
		/**
		 */		
		private function addToDisplayList():void
		{
			tipsHolder = new TipsHolder(this);
		}
		
		/**
		 * 
		 */		
		public function get tips():String
		{
			return _tips;
		}
		
		/**
		 */		
		public function set tips(value:String):void
		{
			_tips = value;
		}
		
		/**
		 */		
		private var _tips:String = '';
		
		/**
		 */		
		public var tipsHolder:TipsHolder;
	}
}