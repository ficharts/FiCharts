package
{
	import flash.display.Sprite;
	
	/**
	 */	
	public class PageBase extends Sprite
	{
		public function PageBase()
		{
			super();
			//this.hide();
		}
		
		/**
		 */		
		public function show():void
		{
			this.visible = true;
		}
		
		/**
		 */		
		public function hide():void
		{
			this.visible = false;
		}
		
		/**
		 */		
		public function renderBG():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
		
		/**
		 */		
		public var w:Number = 980;
		
		/**
		 */		
		public var h:Number = 680;
	}
}