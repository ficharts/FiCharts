package preview
{
	import com.fiCharts.charts.chart2D.encry.CSB;
	import com.fiCharts.charts.common.IChart;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.greensock.TweenLite;
	
	import fl.controls.Label;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import preview.stylePanel.ChartStylePanel;
	import preview.stylePanel.StyleChangedEvt;
	
	/**
	 * 图表呈现及发布页
	 */	
	public class PreviewPage extends PageBase
	{
		public function PreviewPage(main:BiaoMei)
		{
			super();
			
			this.main = main;
			this.addChild(bg);
			this.addChild(chartContainer);
			
			stylePanel.w = 200;
			stylePanel.h = 45;
			
			stylePanel.x =  stylePanel.y = 12;
			chartContainer.addChild(stylePanel);
			
			stylePanel.render();
			stylePanel.addEventListener(Event.CHANGE, styleChangedHandler, false, 0, true);
			
			//初始化图表
			chart = new Chart2D;
			initChart();
			chart.render();
			
			renderBG();
		}
		
		/**
		 */		
		private var topGutter:uint = 100;
		
		/**
		 */		
		public function alert(ms:String):void
		{
			
		}
		
		/**
		 */		
		private var chartContainer:Sprite = new Sprite;
		
		/**
		 */		
		override public function renderBG():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xEEEEEE, 0.6);
			this.graphics.drawRect(0, 0, this.w, this.topGutter - 30);
			this.graphics.endFill();
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xEEEEEE);
			bg.graphics.drawRoundRect(chart.x - dis, chart.y - dis, 
				chart.width + 2 * dis, chart.height + 2 * dis, 5, 5);
			bg.graphics.endFill();
			
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(chart.x, chart.y, chart.width, chart.height);
			bg.graphics.endFill();
			
			// 绘制提示信息
			var sorryIcon:sorry = new sorry;
			var mat:Matrix = new Matrix();
			mat.tx = chart.x + (chart.width - sorryIcon.width) / 2;
			mat.ty = chart.y + (chart.height - sorryIcon.height) / 2 - 50;
			bg.graphics.beginBitmapFill(sorryIcon, mat);
			bg.graphics.lineStyle(0, 0, 0);
			bg.graphics.drawRect(mat.tx, mat.ty, sorryIcon.width, sorryIcon.height);
			bg.graphics.endFill();
			
			var labelStyle:LabelStyle = new LabelStyle;
			XMLVOMapper.fuck(labelStyleXML, labelStyle);
			alertLabel.style = labelStyle;
			alertLabel.y = mat.ty + sorryIcon.height;
			alertLabel.text = "您好像漏掉了什么";
			alertLabel.render();
			alertLabel.x = chart.x + (chart.width - alertLabel.width) / 2;
			bg.addChild(alertLabel);
		}
		
		/**
		 */		
		private var bg:Sprite = new Sprite;
		
		/**
		 */		
		private var alertLabel:LabelUI = new LabelUI;
		
		/**
		 */		
		private var labelStyleXML:XML =  <label>
											<format color='555555' font='微软雅黑' size='15'/>
											<text>
												<effects>
													<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='0.9'/>
												</effects>
											</text>
										</label>
		/**
		 */		
		private var dis:uint = 3;
		
		/**
		 */		
		private function styleChangedHandler(evt:Event):void
		{
			evt.stopPropagation();
			
			if (chart)
			{
				chart.setStyle(stylePanel.getStyleType());
				chart.render();
			}
		}
		
		/**
		 */		
		private var stylePanel:ChartStylePanel = new ChartStylePanel;
		
		/**
		 */		
		private var main:BiaoMei;
		
		/**
		 */		
		public function renderChart(config:XML, data:Array):void
		{
			if(config && data && data.length)
			{
				this.chartContainer.visible = true;
				updateChart(config);
				
				PerformaceTest.start("预览图表");
				
				chart.setConfigXML(config.toString());
				chart.setDataArry(data);
				chart.setStyle(stylePanel.getStyleType());
				chart.render();
				
				PerformaceTest.end("预览图表");
				
			}
			else
			{
				this.chartContainer.visible = false;
			}
		}
		
		/**
		 * 判断是否需要改变图表主程序，如果不改变则啥事都不做
		 * 
		 * 降低性能损耗
		 */		
		private function updateChart(config:XML):void
		{
			PerformaceTest.start("创建图表");
			
			//当前图表类型是饼图
			if (ifHasPieSeries(config))
			{
				if (chart == null)
				{
					chart = new Pie2D;	
					initChart();
				}
				else if(chart is Chart2D)
				{
					chartContainer.removeChild(chart);
					chart = null;
					
					chart = new Pie2D;
					initChart();
				}
			}
			else//当前需要的图表类型是混合图表类型
			{
				if (chart == null)
				{
					chart = new Chart2D;
					initChart();
				}
				else if (chart is Pie2D)
				{
					chartContainer.removeChild(chart);
					chart = null;
					
					chart = new Chart2D;
					initChart();
				}
			}
			
			
			PerformaceTest.end("创建图表");
		}
		
		/**
		 */		
		private function initChart():void
		{
			chart.width = 880;
			chart.height = 540;
			
			chart.x = (this.w - chart.width) / 2;
			chart.y = topGutter;
			chartContainer.addChildAt(chart, 0);
		}
		
		/**
		 */		
		private function ifHasPieSeries(config:XML):Boolean
		{
			if (config.series.hasOwnProperty("pie"))
				return true;
			
			return false;
		}
		
		/**
		 */		
		private var chart:CSB;
		
	}
}