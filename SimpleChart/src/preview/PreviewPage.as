package preview
{
	import flash.display.Sprite;
	
	/**
	 * 图表呈现及发布页
	 */	
	public class PreviewPage extends PageBase
	{
		public function PreviewPage(main:SimpleChart)
		{
			super();
			
			chart.width = 500;
			chart.height = 500;
			this.addChild(chart);
			
			this.main = main;
		}
		
		/**
		 */		
		private var main:SimpleChart;
		
		/**
		 */		
		public function renderChart(config:XML, data:Array):void
		{
			chart.setConfigXML(config.toString());
			chart.setDataArry(data);
			chart.render();
		}
		
		/**
		 */		
		private var chart:Chart2D = new Chart2D;
	}
}