package
{
	import com.fiCharts.charts.chart2D.encry.CSB;
	import com.fiCharts.charts.chart2D.encry.Dec;
	import com.fiCharts.charts.chart2D.encry.PCB;
	
	/**
	 * 此类仅用于构建 2D 饼状图
	 */	
	public class Pie2D extends CSB
	{
		public function Pie2D()
		{
			this.dec = new Dec;
			this.dec.Lc = LiByte;
			this.dec.Meta = MetaByte;
			
			super();
		}
		
		/**
		 */
		override protected function createChart():void
		{
			chart = new PCB
			
			super.createChart(); 
		}
		
		/**
		 *  这里的压缩文件是由  Pie2DConfig.xml 压缩得来， 源文件可查看完整配置；
		 */		
		[Embed(source="Pie2DConfig.z", mimeType="application/octet-stream")]
		private var MetaByte:Class;
		
		/**
		 */	
		[Embed(source="license.z", mimeType="application/octet-stream")]
		private var LiByte:Class;
		
		
	}
}