package template
{
	import flash.events.Event;
	
	/**
	 * 图表的创建与改变类型时用到的事件
	 */	
	public class ChartCreatEvent extends Event
	{
		/**
		 * 创建图表事件 
		 */		
		public static const SELECT_CHART:String = "selectChart";
		
		/**
		 */		
		public static const SELECT_CHART_AND_EDIT:String = 'selectChartAndEdit';
		
		/**
		 */		
		public function ChartCreatEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		public var chart:ChartTempleItem;
		
	}
}