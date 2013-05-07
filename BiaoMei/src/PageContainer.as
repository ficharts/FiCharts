package
{
	import flash.display.Sprite;
	
	/**
	 */	
	public class PageContainer extends Sprite
	{
		public function PageContainer()
		{
			super();
		}
		
		/**
		 */		
		public function addPage(page:Sprite):void
		{
			//page.x = this.width;
			this.addChild(page);
		}
	}
}