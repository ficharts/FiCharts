package
{
	import com.dataGrid.DataGrid;
	import com.fiCharts.utils.StageUtil;
	
	import edit.EditPage;
	import edit.SeriesHead;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
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
			
			this.addChild(templatePage);
			this.addChild(editPage);
		}
		
		/**
		 */		
		public function toEditPage(config:XML):void
		{
			
		}
		
		/**
		 */		
		public function toPrevPage(config:XML, data:Array):void
		{
			
		}
		
		/**
		 */		
		private var templatePage:TemplePage;
		
		/**
		 */		
		private var editPage:EditPage
		
		/**
		 */		
		private var curPage:IPage;
		
	}
}