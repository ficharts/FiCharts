package navBar
{
	public class EditNav implements INav
	{
		public function EditNav()
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
		}
		
		/**
		 */		
		public function toPreviewPage(nav:NavBottom):void
		{
			nav.currentNav = nav.previewChartNav;
			nav.main.toPreviewPage();
		}
		
	}
}