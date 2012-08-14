package com.fiCharts.utils.graphic
{
	import flash.display.GradientType;

	public class GradientColorStyle
	{
		public function GradientColorStyle()
		{
		}
		
		/**
		 *  y angle.
		 */		
		private var _b:Number = 1;

		public function get b():Number
		{
			return _b;
		}

		public function set b(value:Number):void
		{
			_b = value;
		}
		
		/**
		 *  x angle.
		 */		
		private var _c:Number = 1;

		public function get c():Number
		{
			return _c;
		}

		public function set c(value:Number):void
		{
			_c = value;
		}
		
		/***********************************************
		 * 
		 *  Border
		 * 
		 **********************************************/		
		
		private var _borderThikness:Number = 0;
		
		public function get borderThikness():Number
		{
			return _borderThikness;
		}
		
		public function set borderThikness(value:Number):void
		{
			_borderThikness = value;
		}
		
		/**
		 */		
		private var _borderColor:uint = 0x000000;
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
		}
		
		/**
		 */		
		private var _borderAlpha:Number = 0;
		
		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}
		
		public function set borderAlpha(value:Number):void
		{
			_borderAlpha = value;
		}
		
		
		/***********************************************
		 * 
		 *  Fill
		 * 
		 **********************************************/		
		
		/**
		 * radial/linear
		 */		
		private var _fillType:String = "linear";
		
		public function get fillType():String
		{
			return _fillType;
		}
		
		public function set fillType(value:String):void
		{
			_fillType = value;
		}
		
		/**
		 */		
		private var _fillAngle:Number = 0;
		
		public function get fillAngle():Number
		{
			return _fillAngle;
		}
		
		public function set fillAngle(value:Number):void
		{
			_fillAngle = value;
		}
		
		/**
		 */		
		private var _fillColors:Array;
		
		public function get fillColors():Array
		{
			return _fillColors;
		}
		
		public function set fillColors(value:Array):void
		{
			_fillColors = value;
		}
		
		/**
		 */		
		private var _fillRatioes:Array = [ 0, 255 ];;
		
		public function get fillRatioes():Array
		{
			return _fillRatioes;
		}
		
		public function set fillRatioes(value:Array):void
		{
			_fillRatioes = value;
		}
		
		/**
		 */		
		private var _fillAlphas:Array = [ 1, 1 ];
		
		public function get fillAlphas():Array
		{
			return _fillAlphas;
		}
		
		public function set fillAlphas(value:Array):void
		{
			_fillAlphas = value;
		}
		
		
		
		
		/***********************************************
		 *  Size
		 **********************************************/	
		
		/**
		 */		
		private var _width:Number = 0;
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		/**
		 */		
		private var _height:Number = 0;
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		/**
		 */		
		private var _tx:Number = 0;
		
		public function get tx():Number
		{
			return _tx;
		}
		
		public function set tx(value:Number):void
		{
			_tx = value;
		}
		
		/**
		 */		
		private var _ty:Number = 0;
		
		public function get ty():Number
		{
			return _ty;
		}
		
		public function set ty(value:Number):void
		{
			_ty = value;
		}
	}
}