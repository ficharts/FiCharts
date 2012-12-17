package
{
	import com.fiCharts.charts.chart2D.encry.ChartShellBase;
	import com.fiCharts.charts.chart2D.encry.PieChartBase;
	
	/**
	 * 此类仅用于构建 2D 饼状图
	 */	
	public class Pie2D extends ChartShellBase
	{
		public function Pie2D()
		{
			this.dec.License = LicenseXML;
			this.dec.Config = Chart2DConfigXML;
			
			super();
		}
		
		/**
		 */
		override protected function createChart():void
		{
			chart = new PieChartBase
			
			super.createChart(); 
		}
		
		/**
		 *  这里的压缩文件是由  Pie2DConfig.xml 压缩得来， 源文件可查看完整配置；
		 */		
		[Embed(source="Pie2DConfig.z", mimeType="application/octet-stream")]
		private var Chart2DConfigXML:Class;
		
		/**
		 */	
		[Embed(source="license.z", mimeType="application/octet-stream")]
		private var LicenseXML:Class;
		
		
	}
}