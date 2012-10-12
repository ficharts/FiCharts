package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 */	
	public class MobleDemo extends Sprite
	{
		public function MobleDemo()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		/**
		 * 
		 */
		private function resize(evt:Event):void
		{
			if (chart == null)
			{
				chart = new Chart2D();
				chart.ifAutoResizeToStage = false; // 不自动适应舞台尺寸
				chart.width = stage.stageWidth;
				chart.height = stage.stageHeight / 2;
				chart.setConfigXML(columnConfig.toXMLString());
				chart.render();
				addChild(chart);
			}
			
			if (pie == null)
			{
				pie = new Pie2D;
				pie.ifAutoResizeToStage = false; // 不自动适应舞台尺寸
				pie.width = stage.stageWidth;
				pie.height = stage.stageHeight / 2;
				pie.y = stage.stageHeight / 2;
				pie.setConfigXML(pieConfig.toXMLString());
				pie.render();
				addChild(pie);
			}
			
		}
		
		/**
		 */		
		private var columnConfig:XML = <config precision="2" title="2011年全球手机销量" ySuffix="亿部">
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
		
			
		/**
		 */			
		private var pieConfig:XML = <config title='2011年全球手机销量' valueSuffix='亿部' precision="2">
									    <data>
									        <set label="Nokia" value="4.171"/>
									        <set label="Samsung" value="3.294"/>
									        <set label="Apple" value="0.932"/>
									        <set label="LG" value="0.881"/>
									        <set label="ZTE" value="0.661"/>
									        <set label="Others" value="5.521"/>
									    </data>
									 </config>
			
		/**
		 */		
		private var chart:Chart2D;
		
		/**
		 */		
		private var pie:Pie2D;
		
		
		
	}
}