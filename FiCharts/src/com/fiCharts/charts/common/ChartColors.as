package com.fiCharts.charts.common
{
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 */	
	public class ChartColors
	{
		
		/**
		 */		
		public static const overBright:uint = 25;
		
		/**
		 * 默认的图表色谱， 共12个；
		 */		
		public static var colors:Object;
			
		/**
		 */		
		public function ChartColors()
		{
			colorNum = colors.children().length() - 1;
		}
		
		/**
		 */		
		private var colorNum:uint;
		
		/**
		 */		
		public function get chartColor():uint
		{
			var resultColor:uint;
			
			if (chartColorIndex > colorNum)
			{
				resultColor = radomColor;
			}
			else
			{
				resultColor = StyleManager.getUintColor(colors.color[chartColorIndex]);
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
			
			if(_singleIndex > colorNum)
			{
				singleColor = radomColor;
			}
			else
			{
				singleColor = StyleManager.getUintColor(colors.color[_singleIndex]);
				_singleIndex ++;
			}
			
			return singleColor;
		}
		
		/**
		 */		
		public function get radomColor():uint
		{
			var resultColor:uint;
			
			var random:int = Math.random() * colorNum;
			resultColor = StyleManager.getUintColor(colors.color[random]);
			
			var adjustColor:Number = .3 + Math.random() * 1;
			resultColor = StyleManager.transformColor(resultColor * Math.random(), adjustColor, adjustColor, adjustColor);
			
			return resultColor;
		}
		
		/**
		 */		
		private var chartColorIndex:uint = 0;
	}
}	