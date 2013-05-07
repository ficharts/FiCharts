package com.dataGrid
{
	import flash.events.Event;
	
	public class DataGridEvent extends Event
	{
		/**
		 */		
		public static const DATA_CHNAGED:String = "dataChanged";
		
		/**
		 */		
		public function DataGridEvent(type:String)
		{
			super(type, true);
		}
	}
}