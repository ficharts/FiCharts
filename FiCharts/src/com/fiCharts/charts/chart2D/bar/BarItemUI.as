package com.fiCharts.charts.chart2D.bar
{
	import com.fiCharts.charts.chart2D.column2D.Column2DUI;
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class BarItemUI extends Column2DUI
	{
		public function BarItemUI(dataItem:SeriesDataPoint)
		{
			super(dataItem);
		}
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.clear();
			
			currState.ty = 0;
			currState.height = this.columnHeight;
			
			currState.tx = 0;
			currState.width = this.columnWidth;
			
			StyleManager.drawRect(this, currState, metaData);
		}
		
		/**
		 */		
		override public function hoverHandler():void
		{
			super.hoverHandler();
			
			y = this.dataItem.y;
		}
		
		/**
		 */		
		override public function downHandler():void
		{
			y = this.dataItem.y + 1;
			
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_CLICKED);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		override public function normalHandler():void
		{
			super.normalHandler()
				
			//dataItem.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.HIDE_TOOLTIP));
			
			y = this.dataItem.y;
		}
		
	}
}