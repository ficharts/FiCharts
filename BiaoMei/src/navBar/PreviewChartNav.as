package navBar
{
	public class PreviewChartNav implements INav
	{
		public function PreviewChartNav()
		{
		}
		
		/**
		 */		
		public function toTemplatePage(nav:NavBottom):void
		{
			nav.currentNav = nav.templateNav;
			nav.main.toTemplatePage();
		}
		
		/**
		 */		
		public function toEditPage(nav:NavBottom):void
		{
			nav.currentNav = nav.editNav;
			nav.main.toEditPage();
		}
		
		/**
		 */		
		public function toPreviewPage(nav:NavBottom):void
		{
			
		}
		
	}
}