package com.fiCharts.charts.chart2D.bar.stack
{
	public class StackedPercentBarPointRender extends StackedBarPointRender
	{
		public function StackedPercentBarPointRender(visible:Boolean = false)
		{
			super(visible);
		}
		
		/**
		 */		
		override public function get xTipLabel():String
		{
			return itemVO.xValue.toString();
		}
	}
}