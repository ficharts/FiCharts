package com.fiCharts.charts.chart2D.bar
{
	import com.fiCharts.charts.chart2D.column2D.ColumnPointRender;
	
	/**
	 */	
	public class BarPointRender extends ColumnPointRender
	{
		public function BarPointRender(visible:Boolean = false)
		{
			super(visible);
			
			this.isHorizontal = true;
		}
		
		/**
		 */		
		override protected function layoutInnerLabel():void
		{
			valueLabelUI.y = - valueLabelUI.height / 2;
			
			var offset:uint = this.radius;
			
			if (offset < 3)
				offset = 3;
			
			if (Number(_itemVO.xValue) > 0)
				valueLabelUI.x = - valueLabelUI.width - offset;
			else
				valueLabelUI.x = offset;
				  
				// 当柱体太小不能容纳标签时隐藏标签；
				if (Math.abs(columnDataItem.width) < valueLabelUI.width)
					valueLabelUI.visible = false;
				else
					valueLabelUI.visible = true;
		}
		
		/**
		 */		
		override protected function layoutValueLabel():void
		{
			var offset:uint = this.radius;
			
			if (offset < 5)
				offset = 5;
			
			valueLabelUI.y = - valueLabelUI.height / 2;
			
			if (Number(_itemVO.xValue) > 0)
				valueLabelUI.x = offset;
			else
				valueLabelUI.x = - offset - valueLabelUI.width;
		}
		
	}
}