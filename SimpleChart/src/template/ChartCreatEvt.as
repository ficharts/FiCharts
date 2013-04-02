package template
{
	import flash.events.Event;
	
	/**
	 * 图表的创建与改变类型时用到的事件
	 */	
	public class ChartCreatEvt extends Event
	{
		/**
		 * 创建图表事件 
		 */		
		public static const SELECT_CHART:String = "selectChart";
		
		/**
		 */		
		public function ChartCreatEvt(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		public var chartTPUI:ChartTPUI;
		
	}
}