package com.fiCharts.utils.XMLConfigKit.shape
{
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;

	/**
	 * 用来绘制圆圈的样式
	 */	
	public class CircleShape implements IShape
	{
		public function CircleShape()
		{
			super();
		}
		
		/**
		 */		
		public function toNormal():void
		{
			this.style = states.getNormal;
		}
		
		/**
		 */		
		public function toHover():void
		{
			this.style = states.getHover;
		}
		
		/**
		 */		
		public function toDown():void
		{
			this.style = states.getDown;
		}
			
		/**
		 */		
		private var _states:States;

		/**
		 */
		public function get states():States
		{
			return _states;
		}

		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = value;
		}

		/**
		 */		
		public function render(canvas:Sprite, metadata:Object):void
		{
			style.tx = style.ty = - style.radius;
			style.width = style.height = style.radius * 2;
			
			StyleManager.drawCircle(canvas, style, metadata);
		}
		
		/**
		 */		
		private var _style:Style;

		/**
		 */
		public function get style():Style
		{
			return _style;
		}

		/**
		 * @private
		 */
		public function set style(value:Style):void
		{
			_style = value;
		}

	}
}