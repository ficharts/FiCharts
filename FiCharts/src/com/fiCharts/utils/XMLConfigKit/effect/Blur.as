package com.fiCharts.utils.XMLConfigKit.effect
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	
	import flash.filters.BlurFilter;

	public class Blur implements IEffectElement, IStyleElement
	{
		public function Blur()
		{
		}
		
		/**
		 */		
		public function getEffect(metaData:Object):Object
		{
			if (blur == null)
				blur = new BlurFilter(this.blurX, this.blurY, 3);
			
			return blur;
		}
		
		/**
		 */		
		private var _blurX:int = 2;

		public function get blurX():int
		{
			return _blurX;
		}

		public function set blurX(value:int):void
		{
			_blurX = value;
		}

		/**
		 */		
		private var _blurY:int = 2;

		public function get blurY():int
		{
			return _blurY;
		}

		public function set blurY(value:int):void
		{
			_blurY = value;
		}
		
		/**
		 */		
		private var blur:BlurFilter;
	}
}