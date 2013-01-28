package com.fiCharts.utils.XMLConfigKit.shape
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class RectShape implements IShape
	{
		public function RectShape()
		{
		}
		
		/**
		 */		
		public function render(canvas:Sprite, metadata:Object):void
		{
			style.tx = - style.width / 2;
			style.ty = - style.height / 2;
			
			StyleManager.drawRect(canvas, style, metadata);
		}
		
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
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = XMLVOMapper.updateObject(value, _states, "states", this) as States;
		}
		
		/**
		 */		
		private var _states:States;
	}
}