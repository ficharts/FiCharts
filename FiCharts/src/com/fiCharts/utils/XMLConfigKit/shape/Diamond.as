package com.fiCharts.utils.XMLConfigKit.shape
{
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 * 绘制菱形
	 */	
	public class Diamond implements IShape
	{
		public function Diamond()
		{
			
		}
		
		/**
		 */		
		public function setSize(value:uint):void
		{
			states.radius = value / 2;
		}
		
		/**
		 */		
		public function render(canvas:Sprite, metadata:Object):void
		{
			style.tx = - style.radius;
			style.ty = - style.radius;
			
			StyleManager.drawDiamond(canvas, style, metadata);
		}
		
		/**
		 */		
		public function get style():Style
		{
			return _style;
		}
		
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
			_states = value;
		}
		
		/**
		 */		
		private var _states:States;
	}
}