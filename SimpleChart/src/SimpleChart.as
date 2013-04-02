package
{
	import com.fiCharts.utils.StageUtil;
	
	import edit.EditPage;
	
	import flash.display.Sprite;
	
	import navBar.NavBottom;
	
	import preview.PreviewPage;
	
	import template.ChartCreatEvt;
	import template.TemplePage;

	/**
	 */	
	public class SimpleChart extends Sprite
	{
		public function SimpleChart()
		{
			StageUtil.initApplication(this, this.init);
		}
		
		/**
		 */		
		private function init():void
		{
				
			templatePage = new TemplePage(this);
			editPage = new EditPage(this);
			chartPage = new PreviewPage(this);
			
			this.addChild(chartPage);
			this.addChild(editPage);
			this.addChild(templatePage);
			
			templatePage.renderBG();
			editPage.renderBG();
			chartPage.renderBG();
			
			bottomNav = new NavBottom(this);
			addChild(bottomNav);
			
			bottomNav.toTemplatePage();
			
		}
		
		/**
		 */		
		private function createChartHandler(evt:ChartCreatEvt):void
		{
			evt.stopPropagation();
			editPage.createNewChart(currTemplateXML);
		}
		
		/**
		 */		
		private var currTemplateXML:XML;
		
		/**
		 */		
		public function toTemplatePage():void
		{
			if (this.currPage)
				currPage.hide();
			
			currPage = templatePage;
			currPage.show();
			bottomNav.y = currPage.h;
		}
		
		/**
		 */		
		public function toEditPage():void
		{
			currPage.hide();
			currPage = editPage;
			currPage.show();
		}
		
		/**
		 */		
		public function toChartPage(config:XML, data:Array):void
		{
			currPage.hide();
			currPage = chartPage;
			currPage.show();
			
			chartPage.renderChart(config, data);
		}
		
		/**
		 */		
		private var templatePage:TemplePage;
		
		/**
		 */		
		private var editPage:EditPage;
		
		/**
		 */		
		private var chartPage:PreviewPage;
		
		/**
		 */		
		private var currPage:PageBase;
		
		/**
		 */		
		private var bottomNav:NavBottom;
		
		
	}
}