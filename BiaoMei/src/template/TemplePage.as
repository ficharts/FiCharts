package template
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 图表模板页
	 */	
	public class TemplePage extends PageBase
	{
		public function TemplePage(main:BiaoMei)
		{
			super(); 
			
			this.main = main;
			chartTemplates = XML(ByteArray(new TEMPL).toString());
			
			boxLayout.setLoc(0, 0);
			boxLayout.setItemSizeAndFullWidth(this.w, 180, 150);
			layoutCharts();
			
			this.addEventListener(ChartCreatEvent.SELECT_CHART, selectChartHandler, false, 0, true);
			this.addEventListener(ChartCreatEvent.SELECT_CHART_AND_EDIT, selectChartAndEdit, false, 0, true);
			
			this.renderBG();
		}
		
		/**
		 */		
		private function selectChartAndEdit(evt:ChartCreatEvent):void
		{
			evt.stopPropagation();
			
			_selectChart(evt.chart);
			
			main.toEditPage();
			main.updateData();
		}
		
		/**
		 * 每次进入模版页时都需重设一下当前模版
		 */		
		public function reset():void
		{
			if (currentChartTPUI)
				currentChartTPUI.disSelect();
			
			changed = false;
		}
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 * 按照一定的布局规则排列模板图片
		 */		
		private function layoutCharts():void
		{
			boxLayout.ready();
			var chart:ChartTempleItem;
			
			for each(var item:XML in chartTemplates.chart)
			{
				chart = new ChartTempleItem(item.@type, item.@img, XML(item.config.toXMLString()));
				boxLayout.layout(chart);
				chart.render();
				addChild(chart);
			}
		}
		
		/**
		 */		
		private function selectChartHandler(evt:ChartCreatEvent):void
		{
			evt.stopPropagation();
			
			_selectChart(evt.chart);
		}
		
		/**
		 */		
		private function _selectChart(chart:ChartTempleItem):void
		{
			changed = true;
			
			if (currentChartTPUI)
				currentChartTPUI.disSelect();
			
			currentChartTPUI = chart;
			currentChartTPUI.selected();
			
			main.bottomNav.toEditPage();
		}
		
		/**
		 * 当前模板被改变
		 */		
		public var changed:Boolean = false;
		
		/**
		 * 当前的模板数据，XML
		 */		
		public function get templateXML():XML 
		{
			return this.currentChartTPUI.config;
		}
		
		/**
		 */		
		private var currentChartTPUI:ChartTempleItem;
		
		/**
		 */		
		private var main:BiaoMei;
		
		/**
		 * 图表模板配置文件 
		 */		
		private var chartTemplates:XML;
		
		[Embed(source="./templates.xml", mimeType="application/octet-stream")]
		public var TEMPL:Class;
		
	}
}