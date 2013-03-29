package 
{
	import com.fiCharts.utils.StageUtil;
	
	import flash.display.Sprite;

	/**
	 */	
	public class SChart extends Sprite
	{
		private var dataGrid:DataGrid;
		
		/**
		 */		
		public function SChart()
		{
			this.dataGrid = new DataGrid();
			StageUtil.initApplication(this, this.init);
		}
		
		/**
		 */		
		private function init() : void
		{
			this.addChild(this.dataGrid);
			this.dataGrid.x  = this.dataGrid.y = 20;
			this.dataGrid.render();
		}
		
	}
}
