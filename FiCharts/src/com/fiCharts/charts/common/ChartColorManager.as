package com.fiCharts.charts.common
{
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 */	
	public class ChartColorManager
	{
		
		/**
		 */		
		public static const overBright:uint = 25;
		
		/**
		 * 默认的图表色谱， 共12个；
		 */		
		public static var chartColors:XML = <colors>
												<color value="0x7893a8"/>
												<color value="0x607e07"/>
												<color value="0xa65d2f"/>
												<color value="0x025e5e"/>
												<color value="0x8c2f2f"/>
												<color value="0x5f315f"/>
												<color value="0x3a5719"/>
												<color value="0xa68111"/>
												<color value="0x797306"/>
												<color value="0x045f8e"/>
												<color value="0x2F8A93"/>
												<color value="0x4CA0CB"/>
											 </colors>
			
		/**
		 */		
		public function ChartColorManager()
		{
			colorNum = chartColors.children().length() - 1;
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
				resultColor = uint(chartColors.color[chartColorIndex].@value);
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
				singleColor = uint(chartColors.color[_singleIndex].@value);
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
			resultColor = uint(chartColors.color[random].@value);
			
			var adjustColor:Number = .3 + Math.random() * 1;
			resultColor = StyleManager.transformColor(resultColor * Math.random(), adjustColor, adjustColor, adjustColor);
			
			return resultColor;
		}
		
		/**
		 */		
		private var chartColorIndex:uint = 0;
	}
}	