package com.fiCharts.utils.XMLConfigKit.effect
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.filters.DropShadowFilter;
	
	/**
	 */	
	public class Shadow implements IEffectElement, IStyleElement
	{
		public function Shadow()
		{
			super();
		}
		
		/**
		 */		
		public function getEffect(metaData:Object):Object
		{
			if (_effect == null)
			{
				_effect = new DropShadowFilter(this.distance, this.angle, 0, this.alpha, this.blur, this.blur, 2, 3);
			}
			
			_effect.color = uint(StyleManager.getColor(metaData, this.color));
			
			return _effect;
		}
		
		/**
		 */		
		private var _effect:DropShadowFilter;
		
		/**
		 */		
		private var _distance:uint = 2;

		/**
		 */
		public function get distance():uint
		{
			return _distance;
		}

		/**
		 * @private
		 */
		public function set distance(value:uint):void
		{
			_distance = value;
		}

		
		/**
		 */		
		private var _alpha:Number = 1;

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		/**
		 */		
		private var _blur:uint = 2;

		public function get blur():uint
		{
			return _blur;
		}

		public function set blur(value:uint):void
		{
			_blur = value;
		}
		
		/**
		 */		
		private var _color:Object = 0;

		public function get color():Object
		{
			return _color;
		}

		/**
		 */		
		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}
		
		/**
		 */		
		private var _angle:int = 45;

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


	}
}