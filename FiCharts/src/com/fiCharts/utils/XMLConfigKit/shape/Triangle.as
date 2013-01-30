package com.fiCharts.utils.XMLConfigKit.shape
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 * 三角形
	 */	
	public class Triangle implements IShape
	{
		public function Triangle()
		{
		}
		
		/**
		 */		
		public function render(canvas:Sprite, metadata:Object):void
		{
			style.tx = - style.radius;
			style.ty = - style.radius;
			
			style.width = style.height = style.radius * 2;
			
			StyleManager.drawTriangle(canvas, style, style.radius, this.angle, metadata);
		}
		
		/**
		 */		
		private var _angle:int = 0;

		/**
		 */
		public function get angle():int
		{
			return _angle;
		}

		/**
		 * @private
		 */
		public function set angle(value:int):void
		{
			_angle = value;
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
		private var _states:States;
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = XMLVOMapper.updateObject(value, _states, "states", this) as States;
		}
		
		/**
		 */		
		public function set size(value:uint):void
		{
			states.radius = value / 2;
		}
		
		/**
		 */		
		public function get size():uint
		{
			return 0;
		}
	}
}