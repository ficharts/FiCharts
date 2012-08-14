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
		override protected function get xTipLabel():String
		{
			return itemVO.xLabel;
		}
		
		/**
		 */		
		override protected function get zTipLabel():String
		{
			var percentTip:String;
			percentTip = itemVO.zLabel;
			
			if (itemVO.zDisplayName)
				percentTip = itemVO.zDisplayName + ':' + percentTip;
			
			return '<br>' + percentTip;
		}
		
	}
}