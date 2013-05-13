package navBar
{
	public class TemplateNav implements INav
	{
		public function TemplateNav()
		{
		}
		
		/**
		 */		
		public function toTemplatePage(nav:NavTop):void
		{
		}
		
		/**
		 */		
		public function toEditPage(nav:NavTop):void
		{
			nav.currentNav = nav.editNav;
			nav.main.updateData();
			nav.main.toEditPage();
		}
		
		/**
		 */		
		public function toPreviewPage(nav:NavTop):void
		{
			nav.currentNav = nav.previewChartNav;
			nav.main.updateData();
			nav.main.toPreviewPage();
		}
		
	}
}