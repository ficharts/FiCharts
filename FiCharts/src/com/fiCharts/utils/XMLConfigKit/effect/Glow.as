package com.fiCharts.utils.XMLConfigKit.effect
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFiElement;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.filters.GlowFilter;

	/**
	 */	
	public class Glow implements IEffectElement, IFiElement
	{
		public function Glow()
		{
		}
		
		/**
		 */		
		public function getEffect(metaData:Object):Object
		{
			if (glow == null)
			{
				glow = new GlowFilter(0xFFFFFF, this.alpha, this.blur, this.blur, 2, 3, this.inner);
			}
			
			glow.color = uint(StyleManager.getColor(metaData, this.color));
			
			return glow;
		}
		
		/**
		 */		
		private var _color:Object = 0;

		public function get color():Object
		{
			return _color;
		}

		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
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
		private var _inner:Object = false;

		public function get inner():Object
		{
			return _inner;
		}

		public function set inner(value:Object):void
		{
			_inner = XMLVOMapper.boolean(value);;
		}

		/**
		 */		
		private var _blur:uint = 3;

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
		private var glow:GlowFilter;
	}
}