package com.fiCharts.utils.XMLConfigKit.style.elements
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectElement;
	import com.fiCharts.utils.graphic.StyleManager;

	public class BorderLine extends Fill implements IFiElement
	{
		public function BorderLine()
		{
		}
		
		/**
		 * 
		 */
		public function get thickness():Object
		{
			return _thikness;
		}

		public function set thickness(value:Object):void
		{
			_thikness = value;
		}
		
		/**
		 * 
		 */		
		private var _thikness:Object = 1;
		
		/**
		 * 此为兼容性属性，之前写错了名字，旧的配置文件用到的
		 * 
		 * 地方很多，这里保留旧的，同时提供正确的 thickness
		 */		
		public function get thikness():Object
		{
			return _thikness;
		}
		
		public function set thikness(value:Object):void
		{
			_thikness = value;
		}
		
		/**
		 * 圆角时 pixelHinting = true
		 */		
		private var _pixelHinting:Object = false;

		public function get pixelHinting():Object
		{
			return _pixelHinting;
		}

		public function set pixelHinting(value:Object):void
		{
			_pixelHinting = XMLVOMapper.boolean(value);
		}

		/**
		 * normal none
		 */		
		private var _scaleMode:String = 'normal';

		public function get scaleMode():String
		{
			return _scaleMode;
		}

		public function set scaleMode(value:String):void
		{
			_scaleMode = value;
		}

		/**
		 *  square, null, round
		 */		
		private var _caps:String = 'square';

		public function get caps():String
		{
			return _caps;
		}

		public function set caps(value:String):void
		{
			_caps = value;
		}

		/**
		 */		
		private var _joints:String = 'miter';

		public function get joints():String
		{
			return _joints;
		}

		public function set joints(value:String):void
		{
			_joints = value;
		}

		private var _miterLimit:Number = 1.4;

		/**
		 */
		public function get miterLimit():Number
		{
			return _miterLimit;
		}

		/**
		 * @private
		 */
		public function set miterLimit(value:Number):void
		{
			_miterLimit = value;
		}
		
	}
}