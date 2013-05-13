package navBar
{
	import com.fiCharts.utils.layout.LayoutManager;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class NavTop extends Sprite
	{
		public function NavTop(main:BiaoMei)
		{
			super();
			this.main = main;
			this.addChild(btnContainer);
			this.addChild(progressLine);
			
			progressLine.graphics.beginFill(0x4EA6EA, 1);
			progressLine.graphics.drawRect(0, this.h -3, w, 3);
			progressLine.graphics.endFill();
			
			this.graphics.clear();
			this.graphics.beginFill(0xCCCCCC);
			this.graphics.drawRect(0, this.h -3, w, 3); 
			this.graphics.endFill();
			
			init();
			
			progressLine.width = 0;
			TweenLite.to(progressLine, 0.3, {width: dataBtn.x});
		}
		
		/**
		 */		
		private var progressLine:Shape = new Shape;
		
		/**
		 */		
		private var btnContainer:Sprite = new Sprite;
		
		/**
		 */		
		private function init():void
		{
			currentNav = this.templateNav;
			exchangePageBtn(templateBtn)
			
			var btnWidth:uint = 100;
			var btnHeight:uint = 40;
			
			templateBtn.w = dataBtn.w = previewBtn.w = btnWidth;
			templateBtn.h = dataBtn.h = previewBtn.h = btnHeight;
			
			templateBtn.x = this.w - btnWidth * 3;;
			dataBtn.x = this.w - btnWidth * 2;
			previewBtn.x = this.w - btnWidth;
			
			templateBtn.y = dataBtn.y = previewBtn.y = this.h - btnHeight - 3;
			
			templateBtn.text = "选模板" ;
			templateBtn.render();
			btnContainer.addChild(templateBtn);
			templateBtn.addEventListener(MouseEvent.CLICK, toTemplatePageHandler, false, 0, true);
			
			dataBtn.text = "写数据";
			dataBtn.render();
			btnContainer.addChild(dataBtn);
			dataBtn.addEventListener(MouseEvent.CLICK, toEditPageHandler, false, 0, true);
			
			previewBtn.text = "秀图表"
			previewBtn.render();
			btnContainer.addChild(previewBtn);
			previewBtn.addEventListener(MouseEvent.CLICK, toPreviewPageHandler, false, 0, true);
		}
		
		/**
		 */		
		public function toTemplatePage():void
		{
			this.currentNav.toTemplatePage(this);
			exchangePageBtn(this.templateBtn);
			
			TweenLite.to(progressLine, 0.3, {width: dataBtn.x});
		}
		
		/**
		 */		
		public function toEditPage():void
		{
			this.currentNav.toEditPage(this);
			exchangePageBtn(this.dataBtn);
			
			TweenLite.to(progressLine, 0.3, {width: dataBtn.x + dataBtn.w});
		}
		
		/**
		 */		
		public function toPreviewPage():void
		{
			this.currentNav.toPreviewPage(this);
			exchangePageBtn(this.previewBtn);
			
			TweenLite.to(progressLine, 0.3, {width: this.w});
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