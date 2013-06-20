package com.fiCharts.ui
{
	import com.fiCharts.ui.toolTips.ITipsSender;
	import com.fiCharts.ui.toolTips.TipsHolder;
	import com.fiCharts.utils.StageUtil;
	
	import flash.display.Sprite;
	
	/**
	 * ui 基类， 享有所有UI共性
	 */	
	public class FiUI extends Sprite implements ITipsSender
	{
		public function FiUI()
		{
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		private var _enable:Boolean = true;

		/**
		 */
		public function get enable():Boolean
		{
			return _enable;
		}

		/**
		 * @private
		 */
		public function set enable(value:Boolean):void
		{
			if (value)
			{
				mouseChildren = mouseEnabled = true;
				this.alpha = 1;				
			}
			else
			{
				mouseChildren = mouseEnabled = false;
				this.alpha = 0.5;				
			}
			
			_enable = value;
		}

		/**
		 */		
		private var _w:Number = 0;

		/**
		 */
		public function get w():Number
		{
			return _w;
		}

		/**
		 * @private
		 */
		public function set w(value:Number):void
		{
			_w = value;
		}

		/**
		 */		
		private var _h:Number = 0;

		/**
		 */
		public function get h():Number
		{
			return _h;
		}

		/**
		 * @private
		 */
		public function set h(value:Number):void
		{
			_h = value;
		}
		
		/**
		 */		
		protected function init():void
		{
			tipsHolder = new TipsHolder(this);
		}
		
		/**
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