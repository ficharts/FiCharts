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
			this.hide();
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
			this.graphics.beginFill(0xEEEEEE);
			this.graphics.drawRect(0,0,w,h);
		}
		
		/**
		 */		
		public var w:Number = 760;
		
		/**
		 */		
		public var h:Number = 500;
	}
}