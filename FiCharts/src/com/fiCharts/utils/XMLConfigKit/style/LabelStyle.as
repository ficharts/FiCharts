package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectable;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.fiCharts.utils.XMLConfigKit.style.elements.TextFormatStyle;
	
	import flash.text.TextFormat;
	
	/**
	 */	
	public class LabelStyle extends ContainerStyle implements IEffectable, IStyleElement
	{
		/**
		 */		
		public static const NORMAL:String = "normal";
		public static const VERTICAL:String = "vertical";
		public static const ROTATION:String = "rotation";
		public static const INNER:String = 'inner';
		public static const NONE:String = "none"
		
		/**
		 */		
		public function LabelStyle()
		{
			super();
		}
		
		/**
		 * 标签的布局方式：正常，  垂直， 旋转；
		 */
		private var _layout:String = "normal";
		
		public function get layout():String
		{
			return _layout;
		}
		
		public function set layout(value:String):void
		{
			_layout = value;
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
		private var _text:Text = new Text;

		public function get text():Text
		{
			return _text;
		}

		/**
		 * 为了简化文本赋值，此处可以直接传入字符串类型数据，并且将字符串自动
		 * 
		 * 付给 TEXT 的 value
		 */		
		public function set text(value:Text):void
		{
			_text = value;
		}
		
		/**
		 */		
		public function getTextFormat(metaData:Object = null):TextFormat
		{
			return _textFormat.getFormat(metaData);
		}

		/**
		 */		
		private var _textFormat:TextFormatStyle = new TextFormatStyle;

		/**
		 */
		public function get format():Object
		{
			return _textFormat;
		}

		/**
		 * @private
		 */
		public function set format(value:Object):void
		{
			_textFormat = XMLVOMapper.getInstanceFromLib(value) as TextFormatStyle;
		}
		
	}
}