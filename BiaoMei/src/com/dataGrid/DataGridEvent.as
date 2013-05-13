package com.dataGrid
{
	import flash.events.Event;
	
	/**
	 */	
	public class DataGridEvent extends Event
	{
		/**
		 */		
		public static const DATA_CHNAGED:String = "dataChanged";
		
		/**
		 */		
		public static const ADD_ROW:String = "addRow";
		
		/**
		 */		
		public static const UPDATA_SEIZE:String = "upDataSize";
		
		/**
		 */		
		public function DataGridEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		override public function clone():Event
		{
			return new DataGridEvent(this.type);
		}
	}
}