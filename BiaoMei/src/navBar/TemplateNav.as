package navBar
{
	public class TemplateNav implements INav
	{
		public function TemplateNav()
		{
		}
		
		/**
		 */		
		public function toTemplatePage(nav:NavBottom):void
		{
		}
		
		/**
		 */		
		public function toEditPage(nav:NavBottom):void
		{
			nav.currentNav = nav.editNav;
			nav.main.updateData();
			nav.main.toEditPage();
		}
		
		/**
		 */		
		public function toPreviewPage(nav:NavBottom):void
		{
			nav.currentNav = nav.previewChartNav;
			nav.main.updateData();
			nav.main.toPreviewPage();
		}
		
	}
}