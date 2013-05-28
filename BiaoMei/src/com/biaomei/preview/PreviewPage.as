package com.biaomei.preview
{
	import com.fiCharts.charts.chart2D.encry.CSB;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.ImgSaver;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import com.biaomei.preview.stylePanel.ChartStylePanel;
	
	import ui.LabelBtn;
	
	/**
	 * 图表呈现及发布页
	 */	
	public class PreviewPage extends PageBase
	{
		public function PreviewPage(main:BiaoMei)
		{
			super();
			
			this.main = main;
			
			bottomPartContainer.addChild(bg);
			bottomPartContainer.addChild(chartContainer);
			this.addChild(bottomPartContainer);
			
			//初始化图表
			chart = new Chart2D;
			initChart();
			chart.render();
			
			renderBG();
			initEditPanel();
			disableEditPanel();
			
			this.addChild(weiboControl.messagePanel);
		}
		
		/**
		 */		
		internal var bottomPartContainer:Sprite = new Sprite;
		
		/**
		 */		
		public function initWeiboToken(value:String):void
		{
			token = value;
		}
		
		/**
		 */		
		internal var token:String = "";
		
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
			this.editPanel.alpha = 0.8;
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
			chart.width = 910;
			chart.height = 580;
			
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
			stylePanel.h = 27;
			stylePanel.x =  stylePanel.y = ( this.topGutter - stylePanel.h ) /2 ;
			editPanel.addChild(stylePanel);
			stylePanel.render();
			stylePanel.addEventListener(Event.CHANGE, styleChangedHandler, false, 0, true);
			
			// 存图片
			savaImgBtn.w = btnW;
			savaImgBtn.h = btnH;
			savaImgBtn.x = (this.w - savaImgBtn.w * 2 - 20 - 10);
			savaImgBtn.y = (topGutter - savaImgBtn.h) / 2;
			savaImgBtn.text = "存图片";
			savaImgBtn.tips = "图表存为图片至本地"
				
			savaImgBtn.labelStyleXML = btnLabelStyleXML;
			savaImgBtn.bgStyleXML = btnBgStyleXML;
			
			savaImgBtn.render();
			savaImgBtn.addEventListener(MouseEvent.CLICK, saveImgHandler, false, 0, true);
			editPanel.addChild(savaImgBtn);
			
			//保存数据按钮
			saveBtn.w = btnW;
			saveBtn.h = btnH;
			saveBtn.x = (this.w - saveBtn.w - 20);
			saveBtn.y = (topGutter - saveBtn.h) / 2;
			saveBtn.text = "导出文件";
			saveBtn.tips = "导出包含数据和图表配置的文件";
			saveBtn.labelStyleXML = btnLabelStyleXML;
			saveBtn.bgStyleXML = btnBgStyleXML;
			
			saveBtn.render();
			saveBtn.addEventListener(MouseEvent.CLICK, saveDataHandler, false, 0, true);
			editPanel.addChild(saveBtn);
			
			weiboControl = new WeiboControl(this);
		}
		
		/**
		 */		
		private function saveDataHandler(evt:MouseEvent):void
		{
			main.editPage.exportData();
		}
		
		/**
		 * 保存数据按钮 
		 */		
		private var saveBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var btnLabelStyleXML:XML = <label>
											<format color='666666' font='微软雅黑' size='12' letterSpacing="3"/>
											<text>
												<effects>
													<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='0.9'/>
												</effects>
											</text>
										</label>
		
		/**
		 */			
		private var btnBgStyleXML:XML = <states>
										<normal radius="3">
											<border color="#DDDDDD" pixelHinting="true"/>
											<fill color='#EEEEEE' alpha='1'/>
										</normal>
										<hover radius="3">
											<border color="#CCCCCC" pixelHinting="true"/>
											<fill color='#DDDDDD' alpha='1'/>
										</hover>
										<down radius="3">
											<border color="#BBBBBB" pixelHinting="true"/>
											<fill color='#CCCCCC' alpha='1'/>
										</down>
									</states>;
			
		/**
		 */		
		private function saveImgHandler(evt:MouseEvent):void
		{
			ImgSaver.saveImg(this.chart, "biaomei.png");
		}
		
		/**
		 */		
		internal var btnH:uint = 26;
		
		/**
		 */		
		internal var btnW:uint = 70;
		
		/**
		 */		
		internal var editPanel:Sprite = new Sprite;
		
		/**
		 */		
		private var savaImgBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		internal var topGutter:uint = 51;
		
		/**
		 */		
		private var chartContainer:Sprite = new Sprite;
		
		/**
		 */		
		override public function renderBG():void
		{
			super.renderBG();
			
			// 绘制编辑面板背景
			XMLVOMapper.fuck(this.editBgStyleXML, this.editBgStyle);
			drawTopPanel(this.topGutter);
			
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
			alertLabel.text = "这家伙好像漏掉了啥";
			alertLabel.render();
			alertLabel.x = chart.x + (chart.width - alertLabel.width) / 2;
			bg.addChild(alertLabel);
			
			// 存储下原始页面高度，页面高度因微博输入框高度变化时便有了根据
			sourceHeight = this.h;
		}
		
		/**
		 */		
		internal var sourceHeight:Number = 0;
		
		/**
		 */		
		internal function drawTopPanel(height:Number):void
		{
			editPanel.graphics.clear();
			editBgStyle.width = this.w;
			editBgStyle.height = height;
			StyleManager.drawRect(editPanel, editBgStyle);
		}
		
		/**
		 */		
		private var editBgStyle:Style = new Style;
		
		/**
		 */		
		private var editBgStyleXML:XML = <style>
											<border color="EEEEEE"/>
											<fill color="#EFEFEF, #EFEFEF" alpha="0.3,0.3" angle="-90"/>
										</style>
		
		/**
		 */		
		private var dis:uint = 3;
		
		/**
		 */		
		private var labelStyleXML:XML =  <label>
											<format color='555555' font='微软雅黑' size='15'/>
											<text>
												<effects>
													<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='1'/>
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
		internal var chart:CSB;
		
		/**
		 * 微博相关控制，避免页面代码过多
		 */		
		private var weiboControl:WeiboControl;
		
	}
}