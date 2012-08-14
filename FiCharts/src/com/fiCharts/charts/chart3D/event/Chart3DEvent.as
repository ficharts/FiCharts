package com.fiCharts.charts.chart3D.event
{
	import flash.events.Event;
	
	public class Chart3DEvent extends Event
	{
		public static const CONFIG_CHANGED:String = "configChanged";
		
		/**
		 */		
		public function Chart3DEvent(type:String)
		{
			super(type, false);
		}
	}
}