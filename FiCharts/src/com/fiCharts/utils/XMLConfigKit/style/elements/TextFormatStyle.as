package com.fiCharts.utils.XMLConfigKit.style.elements
{
	import com.fiCharts.utils.RexUtil;
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
		public function get letterSpacing():uint
		{
			return _letterSpacing;
		}

		/**
		 * @private
		 */
		public function set letterSpacing(value:uint):void
		{
			_letterSpacing = value;
		}

		/**
		 */		
		public function getFormat(metaData:Object):TextFormat
		{
			if (_format == null)
				_format = new TextFormat();
				
			// 颜色和字体大小可设置元数据
			_format.color = StyleManager.getColor(metaData, this.color);
			_format.size = RexUtil.getTagValueFromMataData(this.size, metaData);
			
			_format.font = this.font;
			_format.bold = this.bold;
			_format.italic = this.italic;
			_format.letterSpacing = this.letterSpacing;
			_format.leading = this.leading;
			
			return _format;
		}
		
		/**
		 */		
		private var _letterSpacing:uint = 1;
		
		/**
		 */		
		private var _format:TextFormat;
		
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

		private var _size:Object = 12;

		public function get size():Object
		{
			return _size;
		}

		public function set size(value:Object):void
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
		 * 行距
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