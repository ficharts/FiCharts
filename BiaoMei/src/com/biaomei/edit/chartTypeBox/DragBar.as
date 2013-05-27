package com.biaomei.edit.chartTypeBox
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	import ui.FiUI;
	
	/**
	 * 面板头，控制拖动
	 */	
	public class DragBar extends FiUI implements IStyleStatesUI
	{
		public function DragBar()
		{
			super();
			
			this.states = new States;
			XMLVOMapper.fuck(styleXML, states);
			stateControl = new StatesControl(this, states);
		}
		
		/**
		 */		
		private var stateControl:StatesControl;
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			
			currState.width = this.w;
			currState.height = this.h;
			currState.radius = 0;
			StyleManager.drawRect(this, currState);
		}
		
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
		private var _states:States;
		
		/**
		 */		
		public function get currState():Style
		{
			return style;
		}
		
		/**
		 */		
		private var style:Style;
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			style = value;
		}
		
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
											<border color="4EA6EA"/>
											<fill color='#4EA6EA' alpha='0.8'/>
										</normal>
										<hover>
											<border color="4EA6EA"/>
											<fill color='#87C5F1' alpha='0.8'/>
										</hover>
										<down>
											<border color="4EA6EA"/>
											<fill color='#4EA6EA' alpha='0.8'/>
										</down>
									</states>
			
		
		/**
		 */		
		public var w:Number = 200;
		
		/**
		 */		
		public var h:Number = 30;
	}
}