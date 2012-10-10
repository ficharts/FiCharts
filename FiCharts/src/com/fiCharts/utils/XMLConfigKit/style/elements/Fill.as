package com.fiCharts.utils.XMLConfigKit.style.elements
{
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectElement;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class Fill implements IStyleElement
	{
		public function Fill()
		{
		}
		
		/**
		 * radial 或者 linear 
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
		}
		
		private var _type:String = 'linear';

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
		private var _color:Object;
		
		/**
		 */		
		private var _alpha:Object = 1;

		public function get alpha():Object
		{
			return _alpha;
		}

		public function set alpha(value:Object):void
		{
			_alpha = XMLVOMapper.setArrayValue(value, true);
		}

		/**
		 */		
		private var _radioes:Object = [0, 255];

		public function get radioes():Object
		{
			return _radioes;
		}

		public function set radioes(value:Object):void
		{
			_radioes = XMLVOMapper.setArrayValue(value, true);
		}
		
		/**
		 */		
		private var _angle:Number = 0;

		/**
		 */
		public function get angle():Number
		{
			return _angle;
		}

		/**
		 * @private
		 */
		public function set angle(value:Number):void
		{
			_angle = value / 180 * Math.PI;
		}

		
	}
}