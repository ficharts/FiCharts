package preview.stylePanel
{
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class StyleItemUI extends ChartItemBase
	{
		public function StyleItemUI(type:String, img:String)
		{
			this.styleXML = <states>
								<normal>
									<border color='#EEEEEE' alpha='0.6'/>
								</normal>
								<hover>
									<border color='#555555' thikness='1' alpha='1'/>
									<fill color='#4EA6EA' alpha='0.3'/>
								</hover>
								<down>
									<border color='#000000' thikness='2' alpha='1'/>
								</down>
							</states>
				
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