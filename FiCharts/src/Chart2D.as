package
{
	import com.fiCharts.charts.chart2D.encry.ChartBase;
	import com.fiCharts.charts.chart2D.encry.ChartShellBase;
	import com.fiCharts.charts.chart2D.encry.Dec;
	
	/**
	 * 2D图表主程序，用此类可以构建柱状图，趋势图，堆积图，混合图表等。
	 */	
	public class Chart2D extends ChartShellBase
	{
		/**
		 */
		public function Chart2D()
		{
			this.dec = new Dec;
			this.dec.License = LicenseXML;
			this.dec.Config = Chart2DConfigXML;
			
			super();
		}
		
		/**
		 */
		override protected function createChart():void
		{
			chart = new ChartBase();
			
			super.createChart(); 
		}
		
		/**
		 *  这里的压缩文件是由  chart2DConfig.xml 压缩得来， 源文件可查看完整配置；
		 */		
		[Embed(source="chart2DConfig.z", mimeType="application/octet-stream")]
		private var Chart2DConfigXML:Class;
		
		/**
		 */	
		[Embed(source="license.z", mimeType="application/octet-stream")]
		private var LicenseXML:Class;
		
	}
}