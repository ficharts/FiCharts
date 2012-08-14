package com.fiCharts.utils.net
{
	import flash.events.Event;
	
	public class URLServiceEvent extends Event
	{
		public static const GET_DATA:String = "getData";
		public static const LOADING_ERROR:String = "loadingError";
		
		/**
		 */		
		public var data:String;
		
		/**
		 */		
		public function URLServiceEvent(type:String, data:String = null)
		{
			super(type);
			this.data = data;
		}
		
	}
}