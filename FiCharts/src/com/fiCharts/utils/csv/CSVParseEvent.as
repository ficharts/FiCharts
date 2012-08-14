package com.fiCharts.utils.csv
{
	import flash.events.Event;
	
	public class CSVParseEvent extends Event
	{
		public static const PARSE_COMPLETE : String = 'parseComplete';
		
		public var parsedXML : XML;
		
		/**
		 * @param type
		 * @param xml
		 */		
		public function CSVParseEvent( type:String, xml : XML )
		{
			super( type );
			
			parsedXML = xml;
		}
	}
}