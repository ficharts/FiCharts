package com.fiCharts.charts.legend.view
{
	import com.fiCharts.charts.legend.model.LegendVO;
	
	import flash.events.Event;
	
	public class LegendEvent extends Event
	{
		/**
		 */		
		public static const LEGEND_ITEM_OVER:String = 'legendItemOver';
		public static const LEGEND_ITEM_OUT:String = 'legendItemOut';
		
		/**
		 */		
		public static const SHOW_LEGEND:String = 'showLegend'
		public static const HIDE_LEGEND:String = 'hideLegend';
		
		/**
		 */		
		public function LegendEvent(type:String, legendVO:LegendVO = null)
		{
			super(type);
			
			this.legendVO = legendVO;
		}
		
		/**
		 */		
		public var legendVO:LegendVO;
	}
}