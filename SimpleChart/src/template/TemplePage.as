package template
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 图表模板页
	 */	
	public class TemplePage extends PageBase
	{
		public function TemplePage(main:SimpleChart)
		{
			super(); 
			
			this.main = main;
			chartTemplates = XML(ByteArray(new TEMPL).toString());
			
			for each(var item:XML in chartTemplates.chart)
			{
				var chart:ChartTPUI = new ChartTPUI(item.@img, XML(item.config.toXMLString()));
				chart.render();
				addChild(chart);
				chart.x = this.width + 20;
			}
			
			this.addEventListener(ChartCreatEvt.SELECT_CHART, selectChartHandler, false, 0, true)
		}	
		
		/**
		 */		
		private function selectChartHandler(evt:ChartCreatEvt):void
		{
			evt.stopPropagation();
			
			if (currentChartTPUI == null)
				
			
			if (currentChartTPUI)
				currentChartTPUI.disSelect();
			
			currentChartTPUI = evt.chartTPUI;
			currentChartTPUI.selected();
		}
		
		/**
		 * 当前的模板数据，XML
		 */		
		public function get template():XML 
		{
			return this.currentChartTPUI.config;
			
			
		}
		
		/**
		 */		
		private var currentChartTPUI:ChartTPUI;
		
		/**
		 */		
		private var main:SimpleChart;
		
		/**
		 * 图表模板配置文件 
		 */		
		private var chartTemplates:XML;
		
		[Embed(source="./templates.xml", mimeType="application/octet-stream")]
		public var TEMPL:Class;
		
	}
}