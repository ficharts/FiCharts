package com.fiCharts.charts.chart2D.core.itemRender
{
	import flash.events.Event;
	
	/**
	 */	
	public class ItemRenderEvent extends Event
	{
		/**
		 * 仅仅隐藏或者显示 tooltip； 
		 */		
		public static const SHOW_TOOLTIP:String = "showTooltip";
		public static const HIDE_TOOLTIP:String =  "hideTooltip";
		
		/**
		 * 仅仅隐藏或者显示渲染节点;
		 */		
		public static const SHOW_ITEM_RENDER:String = 'showItemRender';
		public static const HIDE_ITEM_RENDER:String = 'hideItemRender';
		
		/**
		 * 整个序列显示或者隐藏时 itemRender 同时相应； 
		 */		
		public static const SERIES_HIDE:String = 'seriesHide';
		public static const SERIES_SHOW:String = 'seriesShow';
		public static const SERIES_OVER:String = 'seriesOver';
		public static const SERIES_OUT:String = 'seriesOut';
		
		/**
		 * 刷新数值标签，用于当用户进行图例显示/隐藏操作时;
		 */		
		public static const UPDATE_VALUE_LABEL:String = 'updateValueLabel'
		
		/**
		 */		
		public function ItemRenderEvent(type:String, ifToolTip:Boolean = false, bubble:Boolean = false)
		{
			super(type, bubble);
			this.ifToolTip = ifToolTip;
		}
		
		/**
		 */		
		public var ifToolTip:Boolean;
	}
}