package com.biaomei.navBar
{
	import flash.events.Event;
	
	/**
	 */	
	public class NavEvent extends Event
	{
		/**
		 */		
		public static const TO_NEXT_PAGE:String = "toNestPage";
		
		/**
		 */		
		public static const TO_PREV_PAGE:String = "toPrevPage";
		
		/**
		 * 模板被选择后，底部导航的下一步才会激活 
		 */		
		public static const HAVE_TEMPLATE:String = "haveTemplate";
			
		/**
		 */			
		public function NavEvent(type:String)
		{
			super(type, true);
		}
	}
}