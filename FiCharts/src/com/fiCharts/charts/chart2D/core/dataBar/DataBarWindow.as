package com.fiCharts.charts.chart2D.core.dataBar
{
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 
	 */	
	public class DataBarWindow extends Sprite implements IStyleStatesUI
	{
		public function DataBarWindow()
		{
			stateControl = new StatesControl(this);
		}
		
		/**
		 */		
		private var _winStyle:DataBarWindowStyle;

		public function get winStyle():DataBarWindowStyle
		{
			return _winStyle;
		}

		public function set winStyle(value:DataBarWindowStyle):void
		{
			_winStyle = value;
			this.states = _winStyle.states;
			stateControl.setDefault();
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
		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			style.width = winWidth;
			style.height = winHeight;
			StyleManager.drawRect(this, style);
		}
		
		/**
		 */		
		public var winWidth:Number = 0;

		/**
		 */		
		public var winHeight:Number = 0;
		
		/**
		 */		
		public function get style():Style
		{
			return _style;
		}
		
		/**
		 */		
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
		/**
		 */		
		public function hoverHandler():void
		{
		}
		
		public function normalHandler():void
		{
		}
		
		public function downHandler():void
		{
		}
		
		/**
		 */		
		override public function get visible():Boolean
		{
			return false;
		}
		
		override public function set visible(value:Boolean):void
		{
		}
		
		
	}
}