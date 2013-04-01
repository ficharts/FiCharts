package temple
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 图表模板页
	 */	
	public class TemplePage extends Sprite implements IPage
	{
		public function TemplePage(main:SimpleChart)
		{
			super(); 
			
			this.main = main;
			chartTemplates = XML(ByteArray(new TEMPL).toString());
			
			for each(var item:XML in chartTemplates.chart)
			{
				var chart:ChartImgUI = new ChartImgUI(item.@img, XML(item.config.toXMLString()));
				chart.render();
				addChild(chart);
			}
			
			this.addEventListener(ChartCreatEvt.CREATE_CHART, createChartHandler, false, 0, true)
		}	
		
		/**
		 */		
		private function createChartHandler(evt:ChartCreatEvt):void
		{
			evt.stopPropagation();
			main.toEditPage(evt.configXML);
		}
		
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