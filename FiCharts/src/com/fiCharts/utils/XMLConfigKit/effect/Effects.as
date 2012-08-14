package com.fiCharts.utils.XMLConfigKit.effect
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;

	/**
	 */	
	public class Effects implements IStyleElement
	{
		public function Effects()
		{
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
			_effects.push(value);
		}

		/**
		 */		
		public function set shadow(value:Object):void
		{
			_effects.push(value);
		}
		
		/**
		 * 阴影效果
		 */		
		public function get shadow():Object
		{
			return null;
		}
		
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
			_effects.push(value);
		}
		
		public function get blur():Object
		{
			return null;
		}
		
		/**
		 * 高光效果
		 */		
		public function set glow(value:Object):void
		{
			_effects.push(value);
		}
		
		public function get glow():Object
		{
			return null;
		}
		
		/**
		 */		
		private var _effects:Vector.<IEffectElement> = new Vector.<IEffectElement>;
	}
}