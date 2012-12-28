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
		 * 
		 */		
		private var _offset:Number = 0

		/**
		 */
		public function get offsetX():Number
		{
			return _offset;
		}

		/**
		 * @private
		 */
		public function set offsetX(value:Number):void
		{
			_offset = value;
		}
		
		/**
		 */		
		private var _offsetY:Number = 0;

		/**
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}

		/**
		 * @private
		 */
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}

		/**
		 */		
		private var _offsetRadius:Number = 0;

		/**
		 */
		public function get offsetRadius():Number
		{
			return _offsetRadius;
		}

		/**
		 * @private
		 */
		public function set offsetRadius(value:Number):void
		{
			_offsetRadius = value;
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
			//百分比与真实数据不同，小于1的按百分比算
			if (Math.abs(offsetRadius) < 1)
				style.radius = style.radius + style.radius * offsetRadius;
			else
				style.radius = style.radius + offsetRadius;
			
			var x:Number = 0 ,y:Number = 0;
			if (Math.abs(offsetY) < 1)
				y = - style.radius * offsetY;
			else
				y = - offsetY;
			
			if (Math.abs(offsetX) < 1)
				x = style.radius * offsetX;
			else
				x = offsetX;
			
			style.tx = x - style.radius;
			style.ty = y - style.radius;
			
			style.width = style.height = style.radius * 2;
			
			StyleManager.drawCircle(canvas, style, metadata, x, y);
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