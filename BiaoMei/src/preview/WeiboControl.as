package preview
{
	import com.adobe.images.PNGEncoder;
	import com.dataGrid.DataGridEvent;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.ImgSaver;
	import com.fiCharts.utils.net.Post;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import ui.LabelBtn;
	import ui.LabelInput;

	/**
	 * 
	 * 微博文字输入与发送微博控制
	 * 
	 */	
	public class WeiboControl
	{
		/**
		 */		
		public function WeiboControl(prevPage:PreviewPage)
		{
			this.page = prevPage;
			
			messagePanel.rect = page.getBounds(page);
			
			initWeiboBtn();
			initWeiboField();
		}
		
		/**
		 */		
		private function initWeiboBtn():void
		{
			// 发微博
			weiboBtn.text = "发微博";
			weiboBtn.w = page.btnW;
			weiboBtn.h = page.btnH;
			weiboBtn.x = (page.w - weiboBtn.w * 3 - 20 - 10 * 2);
			weiboBtn.y = (page.topGutter - weiboBtn.h) / 2;
			weiboBtn.tips = "点击发布带图表的微博"
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
			page.editPanel.addChild(weiboBtn);
		}
		
		/**
		 */		
		private function initWeiboField():void
		{
			weiboField.defaultTxt = "说点啥吧";
			weiboField.tips = "微博输入框";
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
			weiboField.y = (page.topGutter - weiboField.h) / 2;
			weiboField.x = weiboBtn.x - 10 - weiboField.w;
			weiboField.addEventListener(Event.RESIZE, weiboFieldResized);
			weiboField.addEventListener(Event.CHANGE, weiboFieldTextChanged);
			page.editPanel.addChild(weiboField);
			
			
			textLenLabel.style = textLenLabelStyle;
			XMLVOMapper.fuck(textLenLabelStyleXML, textLenLabelStyle);
			textLenLabel.text = "140";
			textLenLabel.render();
			page.editPanel.addChild(textLenLabel);
			
			layoutTextLenLabel();
		}
		
		/**
		 * 
		 */		
		private function weiboFieldTextChanged(evt:Event):void
		{
			var textLen:uint = textareastrlen(weiboField.text);
			var textLeft:int = 140 - textLen;
			
			if (textLeft < 0)
			{
				disWeiBoBen();
				
				if (ifRightTextLen)
				{
					ifRightTextLen = false;
					(textLenLabel.style as LabelStyle).format.color = "FF0000";
					textLenLabel.render();
				}
			}
			else if (this.ifRightTextLen == false && textLeft >= 0)
			{
				ifRightTextLen = true;
				(textLenLabel.style as LabelStyle).format.color = "AAAAAA";
				textLenLabel.render();
				
				enWeiboBtn();
			}
			else if (textLeft >= 140)
			{
				disWeiBoBen();
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
		private var weiboField:LabelInput = new LabelInput;
		
		/**
		 */		
		private function weiboFieldResized(evt:Event):void
		{
			page.drawTopPanel(weiboField.h + 20);
			
			var heightDis:Number = weiboField.h - page.topGutter + 20;
			TweenLite.to(page.bottomPartContainer, 0.3, {y: heightDis});
			
			page.h = page.sourceHeight + heightDis;
			page.dispatchEvent(new DataGridEvent(DataGridEvent.UPDATA_SEIZE));
		}
		
		/**
		 */		
		private function sendWeiboHandler(evt:MouseEvent):void
		{
			var bmd:ByteArray = PNGEncoder.encode(BitmapUtil.getBitmapData(page.chart));
			var data:Object = {"status": this.weiboField.text, "access_token":page.token, "pic":bmd, "visible":1};
			
			post = new Post("https://api.weibo.com/2/statuses/upload.json", data);
			post.addEventListener(Event.COMPLETE, complete);
			post.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			post.sendfile();
		}
		
		/**
		 */		
		private function complete(evt:Event):void
		{
			messagePanel.info("发布成功");
		}
		
		/**
		 */		
		private function errorHandler(evt:IOErrorEvent):void
		{
			messagePanel.info("太贪心了，发过了还发", "alert");
		}
		
		/**
		 */		
		private var post:Post;
		
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
		 * 发送微博按钮
		 */		
		private var weiboBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var page:PreviewPage;
		
		/**
		 */		
		internal var messagePanel:MessagePanel = new MessagePanel;
	}
}