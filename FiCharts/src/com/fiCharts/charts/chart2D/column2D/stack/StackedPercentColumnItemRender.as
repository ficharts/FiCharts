package com.fiCharts.charts.chart2D.column2D.stack
{
	public class StackedPercentColumnItemRender extends StackedColumnItemRender
	{
		public function StackedPercentColumnItemRender(visible:Boolean = false)
		{
			super(visible);
		}
		
		/**
		 */		
		override public function get yTipLabel():String
		{
			return '<b>' + itemVO.yValue + '</b>';
		}
		
		/**
		 */		
		override public function get zTipLabel():String
		{
			var percentTip:String;
			percentTip = '<b>' + itemVO.zLabel + '<b>';
			
			if (itemVO.zDisplayName)
				percentTip = itemVO.zDisplayName + ':' + percentTip;
			
			return '<br>' + percentTip;
		}
	}
}