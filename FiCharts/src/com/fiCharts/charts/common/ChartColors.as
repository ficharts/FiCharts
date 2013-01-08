package com.fiCharts.charts.common
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Colors;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 */	
	public class ChartColors
	{
		
		/**
		 */		
		public static const overBright:uint = 25;
		
		/**
		 */		
		public static function clear():void
		{
			colors.clear();
		}
		
		/**
		 * 默认的图表色谱， 共12个；
		 */		
		public static function set colors(value:Colors):void
		{
			if (_colors)
				_colors.clear();
			
			_colors = XMLVOMapper.updateObject(value, _colors) as Colors;
		}
		
		/**
		 */		
		public static function get colors():Colors
		{
			return _colors;			
		}
		
		/**
		 */		
		private static var _colors:Colors;
			
		/**
		 */		
		public function ChartColors()
		{
			
		}
		
		/**
		 */		
		public function get chartColor():uint
		{
			var resultColor:uint;
			
			if (chartColorIndex >= colors.length)
			{
				resultColor = radomColor;
			}
			else
			{
				resultColor = colors.getColor(chartColorIndex);
				chartColorIndex += 1;
			}
			
			return resultColor;
		}
		
		/**
		 * 获取单序列2D柱图图表的条目颜色
		 */		
		public function singleColumnColor(_singleIndex:int):uint
		{
			var singleColor:uint;
			
			if(_singleIndex >= colors.length)
			{
				singleColor = radomColor;
			}
			else
			{
				singleColor = colors.getColor(_singleIndex);
				_singleIndex ++;
			}
			
			return singleColor;
		}
		
		/**
		 */		
		public function get radomColor():uint
		{
			var resultColor:uint;
			
			var random:int = Math.random() * (colors.length - 1);
			resultColor = colors.getColor(random);;
			
			var adjustColor:Number = .3 + Math.random() * 1;
			resultColor = StyleManager.transformColor(resultColor * Math.random(), adjustColor, adjustColor, adjustColor);
			
			return resultColor;
		}
		
		/**
		 */		
		private var chartColorIndex:uint = 0;
	}
}	