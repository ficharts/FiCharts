package edit
{
	import flash.events.Event;
	
	public class LabelInputEvent extends Event
	{
		
		/**
		 * text 上敲击Enter键时离开textfield， 
		 */		
		public static const ENTER_LEAVE:String = "enterLeave";
		
		/**
		 */		
		public function LabelInputEvent(type:String)
		{
			super(type, false);
		}
	}
}