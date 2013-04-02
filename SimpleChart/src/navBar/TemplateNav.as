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
		public function toChartPage(nav:NavBottom):void
		{
		}
	}
}