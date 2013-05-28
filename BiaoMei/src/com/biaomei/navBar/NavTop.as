package com.biaomei.navBar
{
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.LabelBtn;
	
	/**
	 */	
	public class NavTop extends Sprite
	{
		public function NavTop(main:BiaoMei)
		{
			super();
			this.main = main;
			this.addChild(progressBar);
			this.addChild(curSelectShape);
			this.addChild(btnContainer);
			
			this.addChild(progressImgsOut);
			this.addChild(this.progressImgsOver);
			this.addChild(progressImgMask);
			
			init();
			
			initPogressBar();
			initProgressImg();
		}
		
		/**
		 */		
		private var curSelectShape:Shape = new Shape;
		
		/**
		 */		
		private function initPogressBar():void
		{
			this.graphics.clear();
			
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, this.w, this.h);
			
			this.graphics.beginFill(0xCCCCCC);
			this.graphics.drawRect(0, this.h - progreesLineH, w, progreesLineH); 
			this.graphics.endFill();
			
			progressBar.graphics.beginFill(0x4EA6EA, 1);
			progressBar.graphics.drawRect(0, this.h - progreesLineH, w, progreesLineH);
			progressBar.graphics.endFill();
			
			progressBar.width = 0;
			
			// 绘制logo
			//this.graphics.clear();
			var logoBMD:BitmapData = new logo;
			BitmapUtil.drawBitmapDataToSprite(logoBMD, this, logoBMD.width, logoBMD.height, 20, 20, false);
			this.graphics.endFill();
		}
		
		/**
		 */		
		private var flashTime:Number = 0.7;
		
		/**
		 */		
		private function initProgressImg():void
		{
			var temOver:BitmapData = new tmp_over;
			var temOut:BitmapData = new tmp_out;
			
			var tx:Number = this.templateBtn.x + (templateBtn.w - temOver.width) / 2;
			BitmapUtil.drawBitmapDataToSprite(temOver, progressImgsOver, temOver.width, temOver.height, tx);
			BitmapUtil.drawBitmapDataToSprite(temOut, progressImgsOut, temOut.width, temOut.height, tx);
			
			var dataOver:BitmapData = new data_over;
			var dataOut:BitmapData = new data_out;
			
			tx = this.dataBtn.x + (dataBtn.w - dataOver.width) / 2;
			BitmapUtil.drawBitmapDataToSprite(dataOver, progressImgsOver, dataOver.width, dataOver.height, tx);
			BitmapUtil.drawBitmapDataToSprite(dataOut, progressImgsOut, dataOut.width, dataOut.height, tx);
			
			var reviewOver:BitmapData = new show_over;
			var showOut:BitmapData = new show_out;
			
			tx = this.previewBtn.x + (previewBtn.w - reviewOver.width) / 2;
			BitmapUtil.drawBitmapDataToSprite(reviewOver, progressImgsOver, reviewOver.width, reviewOver.height, tx);
			BitmapUtil.drawBitmapDataToSprite(showOut, progressImgsOut, showOut.width, showOut.height, tx);
			
			progressImgsOver.y = progressImgsOut.y = 20;
			progressImgsOver.mouseEnabled = progressImgsOut.mouseEnabled = false;
			
			progressImgMask.graphics.clear();
			progressImgMask.graphics.beginFill(0);
			progressImgMask.graphics.drawRect(0, 0, w, h);
			progressImgsOver.mask = progressImgMask;
			
			progressImgMask.width = 0;
			
			//progressImgsOver.filters = [new DropShadowFilter(1, 90,0x000000, 1, 1,1,1,3)];
		}
		
		/**
		 */		
		private var progressImgMask:Shape = new Shape;
		
		/**
		 */		
		private var progressImgsOver:Sprite = new Sprite;
		
		/**
		 */		
		private var progressImgsOut:Sprite = new Sprite;
		
		/**
		 */		
		private var progreesLineH:uint = 3;
		
		/**
		 */		
		private var progressBar:Shape = new Shape;
		
		/**
		 */		
		private var btnContainer:Sprite = new Sprite;
		
		/**
		 */		
		private function init():void
		{
			var btnWidth:uint = 100;
			var btnHeight:uint = 90;
			
			templateBtn.tips = "根据模板创建图表";
			dataBtn.tips = "填写数据，详细定义图表类型及属性";
			previewBtn.tips = "发布图表";
			
			templateBtn.w = dataBtn.w = previewBtn.w = btnWidth;
			templateBtn.h = dataBtn.h = previewBtn.h = btnHeight;
			
			templateBtn.x = this.w - btnWidth * 3;;
			dataBtn.x = this.w - btnWidth * 2;
			previewBtn.x = this.w - btnWidth;
			
			templateBtn.y = dataBtn.y = previewBtn.y = this.h - btnHeight - progreesLineH;
			
			templateBtn.text = "选模板" ;
			templateBtn.labelStyleXML = disLabelStyleXML;
			templateBtn.render();
			btnContainer.addChild(templateBtn);
			templateBtn.addEventListener(MouseEvent.CLICK, toTemplatePageHandler, false, 0, true);
			
			dataBtn.text = "填数据";
			dataBtn.labelStyleXML = disLabelStyleXML;
			dataBtn.render();
			btnContainer.addChild(dataBtn);
			dataBtn.addEventListener(MouseEvent.CLICK, toEditPageHandler, false, 0, true);
			
			previewBtn.text = "秀图表"
			previewBtn.labelStyleXML = disLabelStyleXML;
			previewBtn.render();
			btnContainer.addChild(previewBtn);
			previewBtn.addEventListener(MouseEvent.CLICK, toPreviewPageHandler, false, 0, true);
			
			this.currentNav = this.previewChartNav;
			
			curSelectShape.alpha = 0;
			curSelectShape.graphics.clear();
			//curSelectShape.graphics.lineStyle(2, 0xFFFFFF);
			curSelectShape.graphics.beginFill(0xDDDDDDD, 0.5);
			curSelectShape.graphics.drawRoundRect(25, 10, btnWidth - 50, btnHeight - 45, 0, 0);
			curSelectShape.graphics.endFill();
			
			//TweenLite.to(curSelectShape, 1, {alpha: 1});
		}
		
		/**
		 */		
		private var disLabelStyleXML:XML = <label vAlign="bottom">
												<format color='#AAAAAA' font='微软雅黑' size='13' letterSpacing="3"/>
											</label>
			
		/**
		 */			
		private var ableLabelStyleXML:XML = <label vAlign="bottom">
												<format color='#329AE7' font='微软雅黑' size='13' letterSpacing="3"/>
												
											</label>
		/**
		 */		
		public function toTemplatePage():void
		{
			this.currentNav.toTemplatePage(this);
			exchangePageBtn(this.templateBtn);
			
			TweenLite.to(progressBar, flashTime, {width: dataBtn.x});
			TweenLite.to(progressImgMask, flashTime, {width: dataBtn.x});
			
			
			this.templateBtn.updateLabelStyle(this.ableLabelStyleXML);
			this.dataBtn.updateLabelStyle(this.disLabelStyleXML);
			this.previewBtn.updateLabelStyle(this.disLabelStyleXML);
			
			TweenLite.to(curSelectShape, flashTime / 2, {x: templateBtn.x, alpha: 1});
		}
		
		/**
		 */		
		public function toEditPage():void
		{
			this.currentNav.toEditPage(this);
			exchangePageBtn(this.dataBtn);
			
			TweenLite.to(progressBar, flashTime, {width: dataBtn.x + dataBtn.w});
			TweenLite.to(progressImgMask, flashTime, {width: dataBtn.x + dataBtn.w});
			
			this.templateBtn.updateLabelStyle(this.ableLabelStyleXML);
			this.dataBtn.updateLabelStyle(this.ableLabelStyleXML);
			this.previewBtn.updateLabelStyle(this.disLabelStyleXML);
			
			TweenLite.to(curSelectShape, flashTime / 2, {x: dataBtn.x});
		}
		
		/**
		 */		
		public function toPreviewPage():void
		{
			this.currentNav.toPreviewPage(this);
			exchangePageBtn(this.previewBtn);
			
			TweenLite.to(progressBar, flashTime, {width: this.w});
			TweenLite.to(progressImgMask, flashTime, {width: this.w});
			
			this.templateBtn.updateLabelStyle(this.ableLabelStyleXML);
			this.dataBtn.updateLabelStyle(this.ableLabelStyleXML);
			this.previewBtn.updateLabelStyle(this.ableLabelStyleXML);
			
			TweenLite.to(curSelectShape, flashTime / 2, {x: previewBtn.x});
		}
		
		/**
		 */		
		private function toTemplatePageHandler(evt:MouseEvent):void
		{
			toTemplatePage();
		}
		
		/**
		 */		
		private function toEditPageHandler(evt:MouseEvent):void
		{
			toEditPage();
		}
		
		/**
		 */		
		private function toPreviewPageHandler(evt:MouseEvent):void
		{
			toPreviewPage();
		}
		
		/**
		 */		
		private function exchangePageBtn(btn:LabelBtn):void
		{
			if (currentPageBtn)
				currentPageBtn.disSelect();
			
			currentPageBtn = btn;
			currentPageBtn.selected();
		}
		
		/**
		 */		
		private var currentPageBtn:LabelBtn;
		
		/**
		 */		
		public var w:Number = 950;
		
		/**
		 */		
		public var h:Number = 90;
		
		/**
		 */		
		internal var main:BiaoMei;
		
		/**
		 */		
		internal var currentNav:INav;
		
		/**
		 */		
		internal var templateNav:INav = new TemplateNav;
		
		/**
		 */		
		internal var editNav:INav = new EditNav;
		
		/**
		 */		
		internal var previewChartNav:INav = new PreviewChartNav;
		
		/**
		 */		
		internal var previewBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		internal var dataBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		internal var templateBtn:LabelBtn = new LabelBtn;
		
	}
}