package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.DataBarWindowStyle;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
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
		
		private var _states:States;
		
		/**
		 */		
		public function render():void
		{
		}
		
		public function get style():Style
		{
			return null;
		}
		
		public function set style(value:Style):void
		{
		}
		
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