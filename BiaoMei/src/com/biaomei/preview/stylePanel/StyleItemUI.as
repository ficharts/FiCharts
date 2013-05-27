package com.biaomei.preview.stylePanel
{
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class StyleItemUI extends ChartItemBase
	{
		public function StyleItemUI(type:String, img:String)
		{
			 super(type, img);
		}
		
		/**
		 */		
		override public function downHandler():void
		{
			var styleEvt:StyleChangedEvt = new StyleChangedEvt(StyleChangedEvt.STYLE_SELECTED);
			styleEvt.styleItem = this;
			
			this.dispatchEvent(styleEvt);
		}
		
		/**
		 */		
		public function disSelect():void
		{
			this.mouseEnabled = true;
			
			this.stateControl.enable = true;
			this.currState = states.getNormal;
			this.render();
		}
		
		/**
		 */		
		public function selected():void
		{
			this.mouseEnabled = false;
			this.currState = states.getDown;
			this.render();
			this.stateControl.enable = false;
			
		}
	}
}