package com.fiCharts.charts.chart2D.bar.stack
{
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.common.ICombilePointRender;
	
	/**
	 */	
	public class StackedBarCombilePointRender extends PointRenderBace implements ICombilePointRender
	{
		public function StackedBarCombilePointRender()
		{
			//super();
			this._isEnable = true;
		}
		
		/**
		 */		
		override public function enable():void
		{
		}
		
		/**
		 */		
		override public function disable():void
		{
		}
		
		/**
		 */		
		override protected function layoutValueLabel():void
		{
			valueLabelUI.y = - valueLabelUI.height / 2;
			
			if (Number(_itemVO.xValue) < 0)
				valueLabelUI.x = - this.radius - valueLabelUI.width - this.valueLabel.hMargin;
			else
				valueLabelUI.x = this.radius + this.valueLabel.hMargin;
		}
	}
}