package com.fiCharts.charts.chart2D.bar.stack
{
	import com.fiCharts.charts.chart2D.column2D.stack.StackedColumnPointRender;
	
	public class StackedBarPointRender extends StackedColumnPointRender
	/**
	 */	
	{
		public function StackedBarPointRender(visible:Boolean = false)
		{
			super(visible);
			
			this.isHorizontal = true;
		}
		
		/**
		 */		
		override protected function layoutInnerLabel():void
		{
			valueLabelUI.y = - valueLabelUI.height / 2;
			
			if (Number(_itemVO.xValue) > 0)
				valueLabelUI.x = - valueLabelUI.width - this.radius;
			else
				valueLabelUI.x = this.radius;
			
			// 当柱体太小不能容纳标签时隐藏标签�
			if (Math.abs(columnDataItem.width) < valueLabelUI.width)
				valueLabelUI.visible = false;
			else
				valueLabelUI.visible = true;
		}
		
		/**
		 */		
		override protected function layoutValueLabel():void
		{
			valueLabelUI.y = - valueLabelUI.height / 2;
			var stackWidth:Number = Math.abs(this.columnDataItem.width);
			
			if (Number(_itemVO.xValue) < 0)
			{
				valueLabelUI.x = stackWidth / 2 - valueLabelUI.width / 2;
			}
			else
			{
				valueLabelUI.x = - stackWidth / 2 - valueLabelUI.width / 2;
			}
			
			// 当柱体太小不能容纳标签时隐藏标签�
			if (stackWidth < valueLabelUI.width)
				valueLabelUI.visible = false;
			else
				valueLabelUI.visible = true;
			
		}
	}
}