package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.effect.Effects;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectElement;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectable;

	public class Text implements IEffectable
	{
		public function Text()
		{
			super();
		}
		
		/**
		 *  top middle bottom
		 */		
		private var _vAlign:String = 'middle';
		
		public function get vAlign():String
		{
			return _vAlign;
		}
		
		public function set vAlign(value:String):void
		{
			_vAlign = value;
		}
		
		/**
		 * left center right;
		 */		
		private var _hAlign:String = 'center';
		
		public function get hAlign():String
		{
			return _hAlign;
		}
		
		public function set hAlign(value:String):void
		{
			_hAlign = value;
		}
		
		/**
		 */		
		private var _value:String = '';

		/**
		 */
		public function get value():String
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:String):void
		{
			if (value != _value)
				_value = value;
		}
		
		/**
		 */		
		private var _substr:uint = 30;

		/**
		 */
		public function get substr():uint
		{
			return _substr;
		}

		/**
		 * @private
		 */
		public function set substr(value:uint):void
		{
			_substr = value;
		}
		
		/**
		 */		
		private var _effects:Effects;

		/**
		 */
		public function get effects():Object
		{
			return _effects;
		}

		/**
		 * @private
		 */
		public function set effects(value:Object):void
		{
			_effects = XMLVOMapper.updateObject(value, _effects) as Effects;
		}
		

	}
}