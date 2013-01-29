package com.fiCharts.charts.chart2D.column2D.stack
{
	public class StackedPercentColumnPointRender extends StackedColumnPointRender
	{
		public function StackedPercentColumnPointRender(visible:Boolean = false)
		{
			super(visible);
		}
		
		/**
		 */		
		override protected function get yTipLabel():String
		{
			return itemVO.yValue.toString();
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