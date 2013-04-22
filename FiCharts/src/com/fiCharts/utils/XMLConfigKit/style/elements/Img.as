package com.fiCharts.utils.XMLConfigKit.style.elements
{
	import com.fiCharts.utils.ClassUtil;
	
	import flash.display.BitmapData;

	/**
	 */	
	public class Img implements IFiElement
	{
		public function Img()
		{
		}
		
		/**
		 * 图片的位图类路径, 根据此可以生成图片数据
		 */		
		private var _classPath:String = "";

		public function get height():Number
		{
			if (_height == 0 && data)
				_height = data.height;
			
			return _height;
		}

		/**
		 */		
		public function set height(value:Number):void
		{
			_height = value;
		}

		/**
		 * 
		 */		
		public function get width():Number
		{
			if (_width == 0 && data)
				_width = data.width;
			
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get data():BitmapData
		{
			if (_data == null)
				_data = ClassUtil.getObjectByClassPath(classPath) as BitmapData;
				
			return _data;
		}

		/**
		 */		
		public function set data(value:BitmapData):void
		{
			_data = value;
		}

		/**
		 */		
		public function get classPath():String
		{
			return _classPath;
		}

		public function set classPath(value:String):void
		{
			_classPath = value;
		}
		
		/**
		 * 图片的位图数据
		 */		
		private var _data:BitmapData;
		
		/**
		 */		
		private var _width:Number = 0;
		
		/**
		 */		
		private var _height:Number = 0;

	}
}