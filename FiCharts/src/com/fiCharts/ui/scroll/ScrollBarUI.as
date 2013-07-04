package com.fiCharts.ui.scroll
{
	import com.fiCharts.utils.StageUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 * 滚动条的UI
	 */	
	public class ScrollBarUI extends Sprite implements IStyleStatesUI
	{
		public function ScrollBarUI()
		{
			super();
			
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		public var h:Number = 0;
		
		/**
		 */		
		public var w:Number = 0;
		
		/**
		 */		
		private function init():void
		{
			XMLVOMapper.fuck(styleXML, states);
			stateControl = new StatesControl(this, states);
		}
		
		/**
		 */		
		private var stateControl:StatesControl;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		private var _states:States = new States;
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			currState.width = w;
			currState.height = h;
			StyleManager.drawRect(this, currState);
			graphics.endFill();
		}
		
		/**
		 */		
		public function get currState():Style
		{
			return _curStyle;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_curStyle = value;
		}
		
		/**
		 */		
		private var _curStyle:Style;
		
		/**
		 */		
		public function hoverHandler():void
		{
		}
		
		/**
		 */		
		public function normalHandler():void
		{
		}
		
		/**
		 */		
		public function downHandler():void
		{
		}
		
		/**
		 */		
		private var styleXML:XML = <states>
										<normal>
											<fill color='#222222' alpha='0.2'/>
										</normal>
										<hover>
											<fill color='#222222' alpha='0.3'/>
										</hover>
										<down>
											<fill color='#222222' alpha='0.4'/>
										</down>
								  </states>;
	}
}