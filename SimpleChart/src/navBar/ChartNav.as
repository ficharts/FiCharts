package navBar
{
	public class ChartNav implements INav
	{
		public function ChartNav()
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
		}
		
		/**
		 */		
		public function toChartPage(nav:NavBottom):void
		{
			nav.currentNav = nav.chartNav;
		}
	}
}