package
{
	import com.fiCharts.charts.chart2D.encry.ChartBase;
	import com.fiCharts.charts.chart2D.encry.ChartShellBase;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 2D图表主程序
	 */	
	public class Chart2D extends ChartShellBase
	{
		/**
		 */
		public function Chart2D()
		{
			var chart2DConfig:ByteArray = ByteArray(new Chart2DConfigXML);
			chart2DConfig.uncompress();
			setDefaultConfig(chart2DConfig.toString());
			this.init();
		}
		
		/**
		 */
		override protected function initChart():void
		{
			chart = new ChartBase();
			resizeChart();
			
			super.initChart(); 
		}
		
		/**
		 *  这里的压缩文件是由  chart2DConfig.xml 压缩得来， 源文件可查看完整配置；
		 */		
		[Embed(source="chart2DConfig.z", mimeType="application/octet-stream")]
		private var Chart2DConfigXML:Class;
		
	}
}