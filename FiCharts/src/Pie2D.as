package
{
	import com.fiCharts.charts.chart2D.encry.ChartShellBase;
	import com.fiCharts.charts.chart2D.encry.PieChartBase;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 2D 饼状图
	 */	
	public class Pie2D extends ChartShellBase
	{
		public function Pie2D()
		{
			super();
			
			var pie2DConfig:ByteArray = ByteArray(new Chart2DConfigXML);
			pie2DConfig.uncompress();
			setDefaultConfig(pie2DConfig.toString());
			
			this.init();
		}
		
		/**
		 */
		override protected function initChart():void
		{
			chart = new PieChartBase
			resizeChart();
			
			super.initChart(); 
		}
		
		/**
		 *  这里的压缩文件是由  Pie2DConfig.xml 压缩得来， 源文件可查看完整配置；
		 */		
		[Embed(source="Pie2DConfig.z", mimeType="application/octet-stream")]
		private var Chart2DConfigXML:Class;
		
		
	}
}