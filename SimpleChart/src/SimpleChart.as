package
{
	import com.dataGrid.DataGrid;
	import com.fiCharts.utils.StageUtil;
	
	import edit.EditPage;
	import edit.SeriesHead;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import preview.PreviewPage;
	
	import temple.TemplePage;

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
		}
		
		/**
		 */		
		public function toEditPage(config:XML):void
		{
			this.editPage.createNewChart(config);
		}
		
		/**
		 */		
		public function toChartPage(config:XML, data:Array):void
		{
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
		
		
	}
}