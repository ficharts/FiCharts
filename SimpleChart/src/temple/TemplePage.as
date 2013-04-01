package temple
{
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 图表模板页
	 */	
	public class TemplePage extends Sprite implements IPage
	{
		public function TemplePage(main:SimpleChart)
		{
			super(); 
			this.main = main;
			
			
			
		}	
		
		/**
		 */		
		private var main:SimpleChart;
		
		/**
		 * 图表模板配置文件 
		 */		
		private var chartTemplates:XML;
		
		[Embed(source="./templatess.xml", mimeType="application/octet-stream")]
		public var TEMPL:Class;
		
	}
}