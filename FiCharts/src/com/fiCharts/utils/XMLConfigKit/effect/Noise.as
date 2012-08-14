package com.fiCharts.utils.XMLConfigKit.effect
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.DisplayObject;

	public class Noise implements IEffectElement, IStyleElement
	{
		public function Noise()
		{
		}
		
		/**
		 */		
		private var _randomSpeed:int;

		public function get randomSpeed():int
		{
			return _randomSpeed;
		}

		public function set randomSpeed(value:int):void
		{
			_randomSpeed = value;
		}

		/**
		 */		
		private var _low:uint = 0;

		public function get low():uint
		{
			return _low;
		}

		public function set low(value:uint):void
		{
			_low = value;
		}

		/**
		 */		
		private var _high:int = 255;

		public function get high():int
		{
			return _high;
		}

		public function set high(value:int):void
		{
			_high = value;
		}

		/**
		 */		
		private var _channelOptions:uint = 7;

		public function get channelOptions():uint
		{
			return _channelOptions;
		}

		public function set channelOptions(value:uint):void
		{
			_channelOptions = value;
		}

		/**
		 */		
		private var _grayScale:Object;

		/**
		 */
		public function get grayScale():Object
		{
			return _grayScale;
		}

		/**
		 * @private
		 */
		public function set grayScale(value:Object):void
		{
			_grayScale = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		public function getEffect(metaData:Object):Object
		{
			return null;
		}
	}
}