package com.fiCharts.charts.chart2D.bar.stack
{
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	
	/**
	 */	
	public class StackedBarCombilePointRender extends PointRenderBace
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
				valueLabelUI.x = - this.style.radius - valueLabelUI.width - this.valueLabel.hMargin;
			else
				valueLabelUI.x = this.style.radius + this.valueLabel.hMargin;
		}
	}
}