package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.column2D.Column2DUI;
	import com.fiCharts.charts.chart2D.core.events.Chart2DEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class StackedColumnUI extends Column2DUI
	{
		public function StackedColumnUI(dataItem:SeriesDataItemVO)
		{
			super(dataItem);
		}
		
		/**
		 */		
		override public function downHandler():void
		{
			this.y = dataItem.y + 1;;
			
			var event:Chart2DEvent = new Chart2DEvent(Chart2DEvent.ITEM_CLICKED);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		override public function normalHandler():void
		{
			dataItem.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.HIDE_TOOLTIP));
			
			y = dataItem.y;
		}
			
		/**
		 */		
		override public function hoverHandler():void
		{
			y = dataItem.y;
		}
		
	}
}