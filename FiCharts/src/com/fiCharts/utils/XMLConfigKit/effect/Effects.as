package com.fiCharts.utils.XMLConfigKit.effect
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFiElement;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFreshElement;

	/**
	 */	
	public class Effects implements IFiElement,  IFreshElement
	{
		public function Effects()
		{
		}
		
		/**
		 */		
		public function fresh():void
		{
			noise = shadow = blur = glow = null;
			_effects.length = 0;
		}
		
		/**
		 */		
		private var _noise:Object;

		/**
		 */
		public function get noise():Object
		{
			return _noise;
		}

		/**
		 * @private
		 */
		public function set noise(value:Object):void
		{
			_noise = value;
			
			_effects.push(value);
		}

		/**
		 */		
		public function set shadow(value:Object):void
		{
			_shadow = value;
			
			_effects.push(value);
		}
		
		/**
		 * 阴影效果
		 */		
		public function get shadow():Object
		{
			return _shadow;
		}
		
		/**
		 */		
		private var _shadow:Object;
		
		/**
		 */		
		public function get effects():Vector.<IEffectElement>
		{
			return _effects;
		}
		
		/**
		 * 模糊效果
		 */		
		public function set blur(value:Object):void
		{
			_blur = value;
			
			_effects.push(value);
		}
		
		public function get blur():Object
		{
			return _blur;
		}
		
		/**
		 */		
		private var _blur:Object;
		
		/**
		 * 高光效果
		 */		
		public function set glow(value:Object):void
		{
			_glow = value;
			
			_effects.push(value);
		}
		
		public function get glow():Object
		{
			return _glow;
		}
		
		/**
		 */		
		private var _glow:Object;
		
		/**
		 */		
		private var _effects:Vector.<IEffectElement> = new Vector.<IEffectElement>;
	}
}