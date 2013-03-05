package com.fiCharts.utils.csv
{
	import flash.events.Event;
	
	/**
	 */	
	public class CSVParseEvent extends Event
	{
		public static const PARSE_COMPLETE : String = 'parseComplete';
		
		/**
		 */		
		public var parsedVOes:Vector.<Object>;
		
		/**
		 * @param type
		 * @param xml
		 */		
		public function CSVParseEvent(type:String, voes:Vector.<Object>)
		{
			super( type );
			
			parsedVOes = voes;
		}
	}
}