package com.biaomei.edit.chart
{
	import flash.events.Event;
	import com.biaomei.edit.chart.header.SeriesHeader;
	
	/**
	 */	
	public class SeriesHeaderEvt extends Event
	{
		/**
		 */		
		public static const HEADER_SELECT:String = "headerSelect";

		/**
		 */		
		public function SeriesHeaderEvt(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		public var header:SeriesHeader;
	}
}