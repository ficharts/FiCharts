package com.fiCharts.charts.chart2D.bar.stack
{
	public class StackedPercentBarItemRender extends StackedBarItemRender
	{
		public function StackedPercentBarItemRender(visible:Boolean = false)
		{
			super(visible);
		}
		
		/**
		 */		
		override public function get xTipLabel():String
		{
			return itemVO.xLabel;
		}
	}
}