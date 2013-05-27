package com.biaomei.navBar
{
	public class EditNav implements INav
	{
		public function EditNav()
		{
		}
		
		/**
		 */		
		public function toTemplatePage(nav:NavTop):void
		{
			nav.currentNav = nav.templateNav;
			nav.main.toTemplatePage();
		}
		
		/**
		 */		
		public function toEditPage(nav:NavTop):void
		{
		}
		
		/**
		 */		
		public function toPreviewPage(nav:NavTop):void
		{
			nav.currentNav = nav.previewChartNav;
			nav.main.toPreviewPage();
		}
		
	}
}