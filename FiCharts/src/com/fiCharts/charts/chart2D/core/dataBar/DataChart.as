package com.fiCharts.charts.chart2D.core.dataBar
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	public class DataChart extends Sprite
	{
		public function DataChart()
		{
			super();
		}
		
		/**
		 */		
		public var dataItems:Vector.<SeriesDataItemVO>
		
		/**
		 */		
		public var hAxis:AxisBase;
		
		/**
		 */		
		public var vAxis:AxisBase;
		
		/**
		 */		
		public var chartHeight:Number = 0;
		
		/**
		 */		
		public var chartWidth:Number = 0;
		
		/**
		 */		
		public var dataStep:uint = 1;
		
		/**
		 */		
		public var style:Style;
		
		/**
		 */		
		public function render():void
		{
			var item:SeriesDataItemVO;
			var i:uint;
			var len:uint = dataItems.length;
			
			graphics.clear();
			StyleManager.setShapeStyle(style, this.graphics);
			
			for (i = 0; i < len; i += dataStep)
			{
				item = dataItems[i];
				item.x = this.hAxis.valueToX(item.xVerifyValue, i);
				item.y = vAxis.valueToY(item.yVerifyValue) * factor;
				
				if (i == 0)
				{
					this.graphics.moveTo(item.x, item.y + baseLine)
				}
				else
				{
					graphics.lineTo(item.x, item.y + baseLine);
				}
			}
			
		}
		
		public var factor:Number = 1;
		
		/**
		 */		
		public var baseLine:Number = 0;
		
	}
}