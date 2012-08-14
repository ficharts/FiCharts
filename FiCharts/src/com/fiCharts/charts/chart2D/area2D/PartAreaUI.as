package com.fiCharts.charts.chart2D.area2D
{
	import com.fiCharts.charts.chart2D.line.PartLineUI;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	/**
	 */	
	public class PartAreaUI extends PartLineUI
	{
		public function PartAreaUI(dataItem:SeriesDataItemVO)
		{
			super(dataItem);
		}
		
		/**
		 */		
		override public function render():void
		{
			partUIRender.renderPartUI(canvas, this.style, this.metaData);
			
			maskUI.graphics.clear();
			maskUI.graphics.beginFill(0, 0.3);
			maskUI.graphics.drawRect(locX, this.locY, this.locWidth, this.locHeight);
			maskUI.graphics.endFill();
		}
	}
}