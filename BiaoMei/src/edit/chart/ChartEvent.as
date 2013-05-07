package edit.chart
{
	import flash.events.Event;
	
	/**
	 */	
	public class ChartEvent extends Event
	{
		public static const DELETE_SERIES:String = 'deleteSeries';
		
		/**
		 */		
		public function ChartEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		public var seriesItem:SeriesProxy;
		
		
	}
}