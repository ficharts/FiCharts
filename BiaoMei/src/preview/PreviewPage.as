package preview
{
	import com.adobe.images.PNGEncoder;
	import com.fiCharts.charts.chart2D.encry.CSB;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.ImgSaver;
	import com.fiCharts.utils.net.Post;
	import com.fiCharts.utils.system.FiTrace;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.tlf_internal;
	
	import navBar.LabelBtn;
	
	import preview.stylePanel.ChartStylePanel;
	
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
			
			//初始化图表
			chart = new Chart2D;
			initChart();
			chart.render();
			
			renderBG();
			initEditPanel();
			disableEditPanel();
		}
		
		/**
		 */		
		public function initWeiboToken(value:String):void
		{
			token = value;
		}
		
		/**
		 */		
		private var token:String = "";
		
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
				enableEditPanel();
				
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
				disableEditPanel();
			}
		}
		
		/**
		 */		
		private function disableEditPanel():void
		{
			this.editPanel.alpha = 0.5;
			editPanel.mouseChildren = editPanel.mouseEnabled = false;
		}
		
		/**
		 */		
		private function enableEditPanel():void
		{
			this.editPanel.alpha = 1;
			editPanel.mouseChildren = editPanel.mouseEnabled = true;
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
			chart.y = topGutter + (this.h - topGutter - chart.height) / 2;
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
		private function initEditPanel():void
		{
			this.addChild(editPanel);
			
			stylePanel.w = 200;
			stylePanel.h = 45;
			stylePanel.x =  stylePanel.y = 12;
			editPanel.addChild(stylePanel);
			stylePanel.render();
			stylePanel.addEventListener(Event.CHANGE, styleChangedHandler, false, 0, true);
			
			// 发微博
			weiboBtn.text = "发微博";
			weiboBtn.w = 150;
			weiboBtn.h = 40;
			weiboBtn.x = (this.w - weiboBtn.w - 20);
			weiboBtn.y = (topGutter - weiboBtn.h) / 2;
			weiboBtn.bgStyleXML = <states>
										<normal>
											<fill color='#CCCCCC' alpha='1'/>
										</normal>
										<hover>
											<fill color='#DDDDDD' alpha='1'/>
										</hover>
										<down>
											<fill color='#EEEEEE' alpha='1'/>
										</down>
									</states>;
			weiboBtn.render();
			weiboBtn.addEventListener(MouseEvent.CLICK, sendWeiboHandler, false, 0, true);
			editPanel.addChild(weiboBtn);
			
			
			// 存图片
			savaImgBtn.w = 150;
			savaImgBtn.h = 40;
			savaImgBtn.x = weiboBtn.x - savaImgBtn.w - 20;
			savaImgBtn.y = (topGutter - savaImgBtn.h) / 2;
			savaImgBtn.text = "存图片";
			savaImgBtn.bgStyleXML = <states>
										<normal>
											<fill color='#CCCCCC' alpha='1'/>
										</normal>
										<hover>
											<fill color='#DDDDDD' alpha='1'/>
										</hover>
										<down>
											<fill color='#EEEEEE' alpha='1'/>
										</down>
									</states>;
			
			savaImgBtn.labelStyleXML = <label>
											<format color='666666' font='微软雅黑' size='16'/>
										</label>
			
			savaImgBtn.render();
			savaImgBtn.addEventListener(MouseEvent.CLICK, saveImgHandler, false, 0, true);
			editPanel.addChild(savaImgBtn);
		}
		
		/**
		 */		
		private function sendWeiboHandler(evt:MouseEvent):void
		{
			var data:Object = {};
			var bmd:ByteArray = PNGEncoder.encode(BitmapUtil.getBitmapData(chart));
			
			data.status = "表魅，给数据添加清新味道";
			data.access_token = this.token;
			data.pic = bmd;
			
			post = new Post("https://api.weibo.com/2/statuses/upload.json", data);
			post.sendfile();
		}
		
		/**
		 */		
		private var post:Post;
		
		/**
		 * 发送微博按钮
		 */		
		private var weiboBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private function saveImgHandler(evt:MouseEvent):void
		{
			ImgSaver.saveImg(this.chart, "biaomei.png");
		}
		
		/**
		 */		
		private var editPanel:Sprite = new Sprite;
		
		/**
		 */		
		private var savaImgBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var topGutter:uint = 70;
		
		/**
		 */		
		private var chartContainer:Sprite = new Sprite;
		
		/**
		 */		
		override public function renderBG():void
		{
			editPanel.graphics.clear();
			editPanel.graphics.beginFill(0xEEEEEE, 0.6);
			editPanel.graphics.drawRect(0, 0, this.w, this.topGutter);
			editPanel.graphics.endFill();
			
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
		private var dis:uint = 3;
		
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
		private var bg:Sprite = new Sprite;
		
		/**
		 */		
		private var alertLabel:LabelUI = new LabelUI;
		
		/**
		 */		
		private var chart:CSB;
		
	}
}