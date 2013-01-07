package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 */	
	public class Colors implements IStyleElement
	{
		public function Colors()
		{
		}
		
		/**
		 */		
		private var _style:String;

		public function get style():String
		{
			return _style;
		}

		/**
		 */		
		public function set style(value:String):void
		{
			if(_style != value)
			{
				_style = value;
				
				clear();
				
				var xml:Object = XMLVOMapper.getStyleXMLBy_ID(_style);
				
				if (xml)
					XMLVOMapper.fuck(xml, this);
			}
		}

		/**
		 */
		public function get color():String
		{
			return null;
		}
		
		/**
		 */
		public function set color(value:String):void
		{
			values.push(StyleManager.getUintColor(value));
		}
		
		/**
		 */		
		public function clear():void
		{
			values.length = 0;
		}
		
		/**
		 */		
		public function get length():uint
		{
			return values.length;
		}
		
		/**
		 * 根据颜色序号获取颜色值
		 */		
		public function getColor(index:uint):uint
		{
			return values[index];
		}
		
		/**
		 */		
		private var values:Vector.<int> = new Vector.<int>;

	}
}