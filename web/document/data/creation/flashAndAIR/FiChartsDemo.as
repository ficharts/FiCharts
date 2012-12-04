package
{
	import flash.display.Sprite;
	
	public class FiChartsDemo extends Sprite
	{
		public function FiChartsDemo()
		{
			super();
			
			var chart:Chart2D = new Chart2D();
			chart.width = 500;
			chart.height = 500;
			chart.setConfigXML(configXML.toString());
			chart.render();
			addChild(chart);
		}
		
		/**
		 */		
		private var configXML:XML = <config precision="2" title="2011年全球手机销量" ySuffix="亿部">
									    <axis>
									        <x title="厂商" type="field"/>
									        <y title="销量" type="linear"/>
									    </axis>
									    <series>
									        <column xField="label" yField="value"/>
									    </series>
									    <data>
									        <set label="Nokia" value="4.171"/>
									        <set label="Samsung" value="3.294"/>
									        <set label="Apple" value="0.932"/>
									        <set label="LG" value="0.881"/>
									        <set label="ZTE" value="0.661"/>
									        <set label="Others" value="5.521"/>
									    </data>
									</config>
									
	}
}