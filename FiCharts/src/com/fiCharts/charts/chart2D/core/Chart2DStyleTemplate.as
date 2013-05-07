package com.fiCharts.charts.chart2D.core
{
	import com.fiCharts.utils.Map;

	/**
	 * 图表的样式控制系统，存储默认的几种样式表；
	 */	
	public class Chart2DStyleTemplate
	{
		/**
		 */		
		public function Chart2DStyleTemplate()
		{
		}
		
		/**
		 */		
		public static function pushCustomTheme(style:XML):void
		{
			themeMap.put(CUSTOM, style);
		}
		
		/**
		 */		
		public static function pushTheme(styleXML:XML):void
		{
			themeMap.put(styleXML.name().toString(), styleXML);
		}
		
		/**
		 * 背景，标题，坐标轴等样式, 默认取经典色系样式；
		 */		
		public static function getTheme(styleName:String):XML
		{
			if (themeMap.containsKey(styleName))
				return themeMap.getValue(styleName) as XML;
			else
				return themeMap.getValue(SIMPLE) as XML;
		}
		
		/**
		 * 序列颜色列表
		 */		
		public static function getColors(styleName:String):XMLList
		{
			return getTheme(styleName).colors;
		}
		
		/**
		 */		
		public static const BLACK:String = 'Black';
		public static const CLASSIC:String = 'Classic';
		public static const SIMPLE:String = 'Simple';
		public static const CUSTOM:String = 'custom';
			
		/**
		 */		
		private static var themeMap:Map = new Map;
		
	}
}