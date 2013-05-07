package navBar
{
	import com.fiCharts.utils.layout.LayoutManager;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class NavBottom extends Sprite
	{
		public function NavBottom(main:BiaoMei)
		{
			super();
			this.main = main;
			this.addChild(btnContainer);
			this.addChild(header);
			
			header.graphics.beginFill(0x4EA6EA, 1);
			header.graphics.drawRect(0, -3, w + 1, 3);
			header.graphics.endFill();
			
			header.graphics.lineStyle(1, 0x1B8CE0, 1);
			header.graphics.moveTo(0, 0);
			header.graphics.lineTo(w + 1, 0);
			
			this.graphics.beginFill(0xDDDDDD);
			this.graphics.drawRect(0, -3, w + 1, 3);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0xBCBCBC)
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(this.w + 1, 0);
			
			this.graphics.lineStyle(1, 0xDEDEDE);
			this.graphics.moveTo(326, 0);
			this.graphics.lineTo(326, this.h);
			
			this.graphics.moveTo(326 * 2 + 1, 0);
			this.graphics.lineTo(326 * 2 + 1, this.h);
			
			init();
			
			header.width = 0;
			TweenLite.to(header, 0.3, {width: 327});
		}
		
		/**
		 */		
		private var header:Shape = new Shape;
		
		/**
		 */		
		private var btnContainer:Sprite = new Sprite;
		
		/**
		 */		
		private function init():void
		{
			currentNav = this.templateNav;
			exchangePageBtn(templateBtn)
			
			templateBtn.w = dataBtn.w = previewBtn.w = 326;
			templateBtn.h = dataBtn.h = previewBtn.h = this.h;
			templateBtn.text = "1.选模板" ;
				
			templateBtn.render();
			btnContainer.addChild(templateBtn);
			templateBtn.addEventListener(MouseEvent.CLICK, toTemplatePageHandler, false, 0, true);
			
			dataBtn.text = "2.写数据";
			dataBtn.render();
			dataBtn.x = templateBtn.w + 1;
			btnContainer.addChild(dataBtn);
			dataBtn.addEventListener(MouseEvent.CLICK, toEditPageHandler, false, 0, true);
			
			previewBtn.text = "3.秀图表"
			previewBtn.render();
			previewBtn.x = dataBtn.x + dataBtn.width + 1;
			btnContainer.addChild(previewBtn);
			previewBtn.addEventListener(MouseEvent.CLICK, toPreviewPageHandler, false, 0, true);
		}
		
		/**
		 */		
		public function toTemplatePage():void
		{
			this.currentNav.toTemplatePage(this);
			exchangePageBtn(this.templateBtn);
			
			TweenLite.to(header, 0.3, {width: 327});
		}
		
		/**
		 */		
		public function toEditPage():void
		{
			this.currentNav.toEditPage(this);
			exchangePageBtn(this.dataBtn);
			
			TweenLite.to(header, 0.3, {width: dataBtn.x + dataBtn.w + 2});
		}
		
		/**
		 */		
		public function toPreviewPage():void
		{
			this.currentNav.toPreviewPage(this);
			exchangePageBtn(this.previewBtn);
			
			TweenLite.to(header, 0.3, {width: this.w + 2});
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
		public var w:Number = 980;
		
		/**
		 */		
		public var h:Number = 40;
		
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