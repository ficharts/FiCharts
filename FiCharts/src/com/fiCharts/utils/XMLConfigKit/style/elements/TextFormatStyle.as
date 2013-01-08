package com.fiCharts.utils.XMLConfigKit.style.elements
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.text.TextFormat;
	
	/**
	 * 
	 */	
	public class TextFormatStyle implements IFiElement
	{
		/**
		 */		
		public function TextFormatStyle()
		{
		}
		
		/**
		 */		
		public function getFormat(metaData:Object):flash.text.TextFormat
		{
			_format = new flash.text.TextFormat(this.font, this.size, null, this.bold, this.italic);
			_format.leading = this.leading;
			
			_format.color = StyleManager.getColor(metaData, this.color);
			
			return _format;
		}
		
		/**
		 */		
		private var _format:flash.text.TextFormat;
		
		/**
		 */		
		private var _font:String = 'Arial';

		public function get font():String
		{
			return _font;
		}

		public function set font(value:String):void
		{
			_font = value;
		}

		private var _size:uint = 12;

		public function get size():uint
		{
			return _size;
		}

		public function set size(value:uint):void
		{
			_size = value;
		}

		/**
		 */		
		private var _italic:Object = false;

		public function get italic():Object
		{
			return _italic;
		}

		public function set italic(value:Object):void
		{
			_italic = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}
		
		/**
		 */		
		public function get color():Object
		{
			return _color;
		}
		
		/**
		 */		
		private var _color:Object;
		
		/**
		 */		
		public function set bold(value:Object):void
		{
			_bold = XMLVOMapper.boolean(value);
		}
		
		public function get bold():Object
		{
			return _bold;
		}
		
		/**
		 */		
		private var _bold:Object = false;
		
		/**
		 * 行距 
		 */		
		private var _leading:uint = 4;

		/**
		 */
		public function get leading():uint
		{
			return _leading;
		}

		/**
		 * @private
		 */
		public function set leading(value:uint):void
		{
			_leading = value;
		}
		
	}
}