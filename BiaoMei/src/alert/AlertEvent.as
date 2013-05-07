package alert
{
	import flash.events.Event;
	
	public class AlertEvent extends Event
	{
		/**
		 */		
		public static const ALLOW:String = 'allow';
		
		/**
		 */		
		public static const FORBID:String = 'forbid';
		
		/**
		 */		
		public function AlertEvent(type:String)
		{
			super(type, true);
		}
	}
}