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
		}
		
		/**
		 */		
		public function toEditPage(nav:NavBottom):void
		{
			nav.currentNav = nav.editNav;
		}
		
		/**
		 */		
		public function toChartPage(nav:NavBottom):void
		{
		}
	}
}