package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.column2D.ColumnPointRender;
	
	/**
	 */	
	public class StackedColumnPointRender extends ColumnPointRender
	{
		public function StackedColumnPointRender(visible:Boolean = true)
		{
			super(visible);
		}
		
		/**
		 */		
		override public function layout():void
		{
			x = _itemVO.dataItemX;
			y = _itemVO.dataItemY;
			
			if (this.valueLabel.enable)
			{
				if(valueLabelUI == null)
				{
					valueLabelUI = createValueLabelUI();
					//addChild(valueLabelUI);
				}
				
				layoutInnerLabel();
			}
		}
		
		/**
		 */		
		override protected function layoutInnerLabel():void
		{
			var temHeight:Number = Math.abs(columnDataItem.height)
			var temX:Number;
			var temY:Number;
			valueLabelUI.rotation = 0;
			
			if (columnDataItem.width < valueLabelUI.width)
			{
				valueLabelUI.rotation = - 90;
				temX = - valueLabelUI.width / 2;
				if (Number(_itemVO.yValue) < 0)
					temY = - temHeight / 2 + valueLabelUI.height / 2;
				else
					temY = temHeight / 2 + valueLabelUI.height / 2;
				
				if (temHeight < valueLabelUI.height)
					valueLabelUI.visible = false;
				else
					valueLabelUI.visible = true;
			}
			else
			{
				temX = - valueLabelUI.width / 2;
				if (Number(_itemVO.yValue) < 0)
					temY = - temHeight / 2 - valueLabelUI.height / 2;
				else
					temY = temHeight / 2 - valueLabelUI.height / 2;
				
				// 当柱体太小不能容纳标签时隐藏标签；
				if (temHeight < valueLabelUI.height)
					valueLabelUI.visible = false;
				else
					valueLabelUI.visible = true;
			}
			
			valueLabelUI.x = temX;
			valueLabelUI.y = temY;
		}
		
	}
}