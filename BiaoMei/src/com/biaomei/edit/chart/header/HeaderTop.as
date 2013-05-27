package com.biaomei.edit.chart.header
{
	import flash.display.Sprite;
	import ui.TipsHolder;
	import ui.ITipsSender;
	
	/**
	 */	
	public class HeaderTop extends Sprite implements ITipsSender
	{
		public function HeaderTop()
		{
			super();
			
			this.tips = "点击编辑图例标题";
			this.tipsHolder = new TipsHolder(this);
		}
		
		/**
		 */		
		private var _isInteractive:Boolean = true;

		/**
		 */
		public function get isInteractive():Boolean
		{
			return _isInteractive;
		}

		/**
		 * @private
		 */
		public function set isInteractive(value:Boolean):void
		{
			if (value)
				tipsHolder.enable();
			else
				tipsHolder.disEnable();
		}

		
		/**
		 */		
		private var tipsHolder:TipsHolder;
		
		/**
		 */		
		public function get tips():String
		{
			return _tips;
		}
		
		public function set tips(value:String):void
		{
			_tips = value;
		}
		
		/**
		 */		
		private var _tips:String = "";
			
		
		
	}
}