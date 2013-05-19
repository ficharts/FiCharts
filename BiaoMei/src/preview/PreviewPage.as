package preview
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.dataGrid.DataGridEvent;
	import com.fiCharts.charts.chart2D.encry.CSB;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.ImgSaver;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.net.Post;
	import com.fiCharts.utils.system.FiTrace;
	import com.greensock.TweenLite;
	
	import edit.LabelInput;
	
	import fl.controls.TextInput;
	import fl.core.UIComponent;
	
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
		}
		
		/**
		 */		
		private var bottomPartContainer:Sprite = new Sprite;
		
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
			stylePanel.h = 30;
			stylePanel.x =  stylePanel.y = ( this.topGutter - stylePanel.h ) /2 ;
			editPanel.addChild(stylePanel);
			stylePanel.render();
			stylePanel.addEventListener(Event.CHANGE, styleChangedHandler, false, 0, true);
			
			var btnH:uint = 26;
			var btnW:uint = 70;
			
			// 发微博
			weiboBtn.text = "发微博";
			weiboBtn.w = btnW;
			weiboBtn.h = btnH;
			weiboBtn.x = (this.w - weiboBtn.w * 2 - 30);
			weiboBtn.y = (topGutter - weiboBtn.h) / 2;
			
			weiboBtn.bgStyleXML = <states>
										<normal radius="3">
											<border color="#167AC5" pixelHinting="true"/>
											<fill color='#3BB0FB' alpha='1'/>
										</normal>
										<hover radius="3">
											<border color="#3BB0FB" pixelHinting="true"/>
											<fill color='#88CEFD' alpha='1'/>
										</hover>
										<down radius="3">
											<border color="#167AC5" pixelHinting="true"/>
											<fill color='#167AC5' alpha='1'/>
										</down>
									</states>;
			
			weiboBtn.labelStyleXML = <label>
						                <format color='FFFFFF' font='微软雅黑' size='12' letterSpacing="3"/>
											<!--text>
												<effects>
													<shadow color='555555' distance='1' angle='90' blur='1' alpha='0.9'/>
												</effects>
											</text-->
						            </label>
				
			
			weiboBtn.render();
			weiboBtn.addEventListener(MouseEvent.CLICK, sendWeiboHandler, false, 0, true);
			disWeiBoBen();
			editPanel.addChild(weiboBtn);
			
			
			
			// 存图片
			savaImgBtn.w = 70;
			savaImgBtn.h = 26;
			savaImgBtn.x = (this.w - savaImgBtn.w - 20);
			savaImgBtn.y = (topGutter - savaImgBtn.h) / 2;
			savaImgBtn.text = "存图片";
			
			savaImgBtn.labelStyleXML = <label>
											<format color='666666' font='微软雅黑' size='12' letterSpacing="3"/>
											<text>
												<effects>
													<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='0.9'/>
												</effects>
											</text>
										</label>
				
			savaImgBtn.bgStyleXML = <states>
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
			
			savaImgBtn.render();
			savaImgBtn.addEventListener(MouseEvent.CLICK, saveImgHandler, false, 0, true);
			editPanel.addChild(savaImgBtn);
			
			
			
			
			
			
			weiboField.defaultTxt = "说点啥吧";
			weiboField.setTextFormat(12);
			weiboField.ifWordwrap = true;
			weiboField.defaultStyleXML = <style radius="5">
											<fill color="FFFFFF" alpha='1'/>
											<border color='#eeeeee' thikness='1' alpha='1' pixelHinting='true'/>
										</style>
				
			weiboField.selectStyleXML = <style radius="5">
											<fill color="FFFFFF" alpha='1'/>
											<border color='#2494E6' thikness='1' alpha='0.6' pixelHinting='true'/>
										</style>
			weiboField.h = 40;
			weiboField.w = 420;
			weiboField.render();
			weiboField.y = (this.topGutter - weiboField.h) / 2;
			weiboField.x = 350;
			weiboField.addEventListener(Event.RESIZE, weiboFieldResized);
			weiboField.addEventListener(Event.CHANGE, weiboFieldTextChanged);
			editPanel.addChild(weiboField);
			
			
			textLenLabel.style = textLenLabelStyle;
			XMLVOMapper.fuck(textLenLabelStyleXML, textLenLabelStyle);
			textLenLabel.text = "140";
			textLenLabel.render();
			editPanel.addChild(textLenLabel);
			
			layoutTextLenLabel();
		}
		
		/**
		 */		
		private function layoutTextLenLabel():void
		{
			textLenLabel.x = weiboField.x - textLenLabel.width - 5;
			textLenLabel.y =  - 2;
		}
		
		/**
		 */		
		private var textLenLabel:LabelUI = new LabelUI;
		
		/**
		 */		
		private var textLenLabelStyle:LabelStyle = new LabelStyle;
		
		/**
		 */		
		private var textLenLabelStyleXML:XML = <label>
													<format color='AAAAAA' font='Constantia' size='30' letterSpacing="3"/>
														<text>
															<effects>
																<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='0.9'/>
															</effects>
														</text>
												</label>
		
		/**
		 * 
		 */		
		private function weiboFieldTextChanged(evt:Event):void
		{
			var textLen:uint = textareastrlen(weiboField.text);
			var textLeft:int = 140 - textLen;
			
			if (textLeft < 0 && ifRightTextLen)
			{
				ifRightTextLen = false;
				(textLenLabel.style as LabelStyle).format.color = "FF0000";
				textLenLabel.render();
				
				disWeiBoBen();
			}
			else if (this.ifRightTextLen == false && textLeft >= 0)
			{
				ifRightTextLen = true;
				(textLenLabel.style as LabelStyle).format.color = "AAAAAA";
				textLenLabel.render();
				
				enWeiboBtn();
			}
			else
			{
				if (ifJustSpaceWords)
					disWeiBoBen();
				else
					enWeiboBtn();
			}
			
			// 刷新数字
			textLenLabel.text = textLeft.toString();
			textLenLabel.render();
			layoutTextLenLabel();
		}
		
		/**
		 */		
		private function get ifJustSpaceWords():Boolean
		{
			var text:String = weiboField.text
			var len:uint = text.length;
			
			var result:Boolean = true;
			var code:Number;
			
			for (var i:uint = 0; i < len; i ++)
			{
				code = text.charCodeAt(i);
				if(code != 32 && code != 13)
				{
					result = false;
					break;
				}
			}
			
			return result;
		}
		
		/**
		 */		
		private function disWeiBoBen():void
		{
			
			this.weiboBtn.alpha = 0.6;
			weiboBtn.mouseEnabled = false;
		}
		
		/**
		 */		
		private function enWeiboBtn():void
		{
			
			this.weiboBtn.alpha = 1;
			weiboBtn.mouseEnabled = true;
		}
		
		/**
		 */		
		private var ifRightTextLen:Boolean = true;
		
		/**
		 */		
		private function textareastrlen(str:String):uint
		{
			var len:uint;
			var i:uint;
			len = 0;
			
			for (i = 0; i < str.length; i ++)
			{
				if (str.charCodeAt(i) > 255)
				{
					len += 2;
				}
				else
				{
					len ++;
				}
			}
			
			if (len % 2 != 0)
			{
				len = len + 1;
			}
			
			return len / 2;
		}
		
		/**
		 */		
		private function weiboFieldResized(evt:Event):void
		{
			this.drawTopPanel(weiboField.h + 20);
			
			var heightDis:Number = weiboField.h - this.topGutter + 20;
			TweenLite.to(bottomPartContainer, 0.3, {y: heightDis});
			
			this.h = sourceHeight + heightDis;
			this.dispatchEvent(new DataGridEvent(DataGridEvent.UPDATA_SEIZE));
		}
		
		/**
		 */		
		private var weiboField:LabelInput = new LabelInput;
		
		/**
		 */		
		private function sendWeiboHandler(evt:MouseEvent):void
		{
			var bmd:ByteArray = PNGEncoder.encode(BitmapUtil.getBitmapData(chart));
			var data:Object = {"status": this.weiboField.text, "access_token":this.token, "pic":bmd, "visible":1};
			
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
		private var topGutter:uint = 50;
		
		/**
		 */		
		private var chartContainer:Sprite = new Sprite;
		
		/**
		 */		
		override public function renderBG():void
		{
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
		private var sourceHeight:Number = 0;
		
		/**
		 */		
		private function drawTopPanel(height:Number):void
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