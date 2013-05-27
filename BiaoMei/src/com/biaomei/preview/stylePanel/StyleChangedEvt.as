package com.biaomei.preview.stylePanel
{
	import flash.events.Event;
	
	/**
	 */	
	public class StyleChangedEvt extends Event
	{
		public static const STYLE_SELECTED:String = 'styleSelected';
		
		/**
		 */		
		public function StyleChangedEvt(type:String)
		{
			super(type, true);
		}
		
		/**
		 */		
		override public function clone():Event
		{
			var evt:StyleChangedEvt = new StyleChangedEvt(STYLE_SELECTED);
			evt.styleItem = styleItem;
			
			return evt;
		}
		
		/**
		 */		
		public var styleItem:StyleItemUI;
	}
}