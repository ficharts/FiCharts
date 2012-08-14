package
{
	import com.fiCharts.charts.chart2D.encry.ChartBase;
	import com.fiCharts.charts.chart2D.encry.ChartShellBase;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 2D图表主程序
	 */	
	public class Chart2D extends ChartShellBase
	{
		/**
		 */
		public function Chart2D()
		{
			/*
			* 加载配置文件，这是ficharts的基础配置文件, 主要是样式模板，这样可以简化图表配置.
			* 用户的图表配置文件先会继承基础配置文件,省去了大部分配置信息。为了方便查看基础配置信息，此文件没有压缩，
			× 你可以将此文件压缩并嵌入SWF中一起编译。
			*/
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, configLoadedHandler);
			urlLoader.load(new URLRequest('Chart2DConfig.xml'));
		}
		
		/**
		 */		
		private function configLoadedHandler(evt:Event):void
		{
			setDefaultConfig(evt.target.data);
			this.init();
		}
		
		
		//----------------------------------------
		//
		// 初始化
		//
		//----------------------------------------
		
		/**
		 * @param evt
		 */
		override protected function resizeHandler(evt:Event):void
		{
			if (stage.stageWidth <=  ChartShellBase.MIN_SIZE || stage.stageHeight <= ChartShellBase.MIN_SIZE)
				return;
			
			resizeChart();
			chart.render();
		}
		
		/**
		 */
		private function resizeChart():void
		{
			chart.chartWidth = stage.stageWidth;
			chart.chartHeight = stage.stageHeight;
		}
		
		/**
		 */
		override protected function initChart():void
		{
			chart = new ChartBase();
			resizeChart();
			
			super.initChart(); 
		}
		
	}
}