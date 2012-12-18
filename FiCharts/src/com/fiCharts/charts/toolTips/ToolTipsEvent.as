package com.fiCharts.charts.toolTips
{
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ToolTipsEvent extends Event
	{
		public static const SHOW_TOOL_TIPS:String = "showToolTips";
		public static const HIDE_TOOL_TIPS:String = "hideToolTips";
			
		/**
		 */		
		public var toolTipsHolder:ToolTipHolder;
		
		/**
		 */		
		public function ToolTipsEvent(type:String, toolTipsVO:ToolTipHolder = null)
		{
			super(type, true);
			this.toolTipsHolder = toolTipsVO;
		}
	}
}