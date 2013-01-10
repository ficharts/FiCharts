package com.fiCharts.charts.chart2D.core.itemRender
{
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class LegendStateControl
	{
		public function LegendStateControl(dataItem:SeriesDataPoint, target:StatesControl)
		{
			dataItem.addEventListener(ItemRenderEvent.SERIES_OVER, overHandler, false, 0, true);
			dataItem.addEventListener(ItemRenderEvent.SERIES_OUT, outHandler, false, 0, true);
			dataItem.addEventListener(ItemRenderEvent.SERIES_HIDE, hideHandler, false, 0, true);
			dataItem.addEventListener(ItemRenderEvent.SERIES_SHOW, showHandler, false, 0, true);
			
			this.target = target;
		}
		
		/**
		 */		
		private var target:StatesControl;
		
		/**
		 */		
		private function overHandler(evt:Event):void
		{
			target.toHover();
		}
		
		/**
		 */		
		private function outHandler(evt:Event):void
		{
			target.toNormal();
		}
		
		/**
		 */		
		private function hideHandler(evt:Event):void
		{
			target.toHide();
		}
		
		/**
		 */		
		private function showHandler(evt:Event):void
		{
			target.toShow();
		}
	}
}