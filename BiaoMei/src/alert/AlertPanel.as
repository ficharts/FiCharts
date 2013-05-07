package alert
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import navBar.LabelBtn;
	
	/**
	 */	
	public class AlertPanel extends Sprite
	{
		public function AlertPanel()
		{
			super();
		}
		
		/**
		 */		
		private function allowHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new AlertEvent(AlertEvent.ALLOW));
		}
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0.6);
			this.graphics.drawRect(0, 0, w, h);
			
			allowBtn.text = '替换'
			allowBtn.addEventListener(MouseEvent.CLICK, allowHandler);
			allowBtn.render();
			this.addChild(allowBtn);
		}
		
		/**
		 */		
		private var allowBtn:LabelBtn = new LabelBtn();
		
		/**
		 */		
		public var w:Number;
		
		/**
		 */		
		public var h:Number;
		
	}
}