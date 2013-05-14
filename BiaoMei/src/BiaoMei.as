package
{
	import alert.AlertEvent;
	import alert.AlertPanel;
	
	import com.dataGrid.DataGridEvent;
	import com.fiCharts.utils.ExternalUtil;
	import com.fiCharts.utils.StageUtil;
	import com.greensock.TweenLite;
	
	import edit.EditPage;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import navBar.NavTop;
	
	import preview.PreviewPage;
	
	import template.TemplePage;
	
	
	/**
	 */	
	public class BiaoMei extends Sprite
	{
		public function BiaoMei()
		{
			StageUtil.initApplication(this, this.init);
		}
		
		/**
		 */		
		private function init():void
		{
			pageContainer.y = 90;
			this.addChild(pageContainer);
			
			templatePage = new TemplePage(this);
			editPage = new EditPage(this);
			previewPage = new PreviewPage(this);
			
			editPage.x = templatePage.w;
			previewPage.x = templatePage.w * 2;
			
			pageContainer.addPage(templatePage);
			pageContainer.addPage(editPage);
			pageContainer.addPage(previewPage);
			
			nav = new NavTop(this);
			addChild(nav);
			
			toTemplatePage();
			
			this.addChild(maskShape);
			pageContainer.mask = maskShape;
			
			this.addEventListener(DataGridEvent.UPDATA_SEIZE, sizeChangedHandler, false, 0, true);
			
			initAPI();
		}
		
		/**
		 */		
		private function initAPI():void
		{
			ExternalInterface.addCallback("setToken", setToken);
			ExternalInterface.call("ready");
		}
		
		/**
		 */		
		private function setToken(value:String):void
		{
			this.previewPage.initWeiboToken(value);
		}
		
		/**
		 * 页面动态刷新高度时调用
		 */		
		private function sizeChangedHandler(evt:DataGridEvent):void
		{
			renderBg();
		}
		
		/**
		 */		
		private var maskShape:Shape = new Shape;
		
		/**
		 * 页面的容器，负责导航页面时移动当前页面的为止到显示范围内
		 */		
		private var pageContainer:PageContainer = new PageContainer
		
		/**
		 */		
		public function toTemplatePage():void
		{
			//templatePage.reset();
			exchangeToPage(templatePage);
			TweenLite.to(pageContainer, 0.5, {x:0});
		}
		
		/**
		 */		
		public function toEditPage():void
		{
			exchangeToPage(editPage);
			TweenLite.to(pageContainer, 0.5, {x:- editPage.x});
		}
		
		/**
		 * 模板页向其他页切换时，需要调用此方法
		 * 
		 * 只有模板发生改变时，才可以调用此方法，编辑页刷新数据；
		 */		
		public function updateData():void
		{
			if (templatePage.changed)
			{
				editPage.preUpdateData(templatePage.templateXML);
				templatePage.changed = false;
			}
		}
		
		/**
		 */		
		public function toPreviewPage():void
		{
			exchangeToPage(previewPage);
			TweenLite.to(pageContainer, 0.5, {x:- previewPage.x});
			
			if (editPage.ifDataChanged)
			{
				previewPage.renderChart(editPage.getChartConfigXML(), editPage.getChartData());
				this.editPage.chartRenderd();
			}
		}
		
		/**
		 * 切换到目标页面
		 */		
		private function exchangeToPage(newPage:PageBase):void
		{
			currPage = newPage;
			renderBg();
		}
		
		/**
		 */		
		private function renderBg():void
		{
			//内容区域
			maskShape.graphics.clear();
			maskShape.graphics.beginFill(0);
			maskShape.graphics.drawRect(1, this.nav.h, currPage.w - 2, currPage.h - 1);
			maskShape.graphics.endFill();
			
			// 边框
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xEEEEEE);
			this.graphics.drawRect(0, 0, 950 - 1, currPage.h + this.nav.h);
			this.graphics.endFill();
			
			ExternalUtil.call("updatePageHeight", currPage.h + nav.h);
		}
		
		/**
		 * 模板页
		 */		
		private var templatePage:TemplePage;
		
		/**
		 * 编辑页
		 */		
		private var editPage:EditPage;
		
		/**
		 * 预览页
		 */		
		private var previewPage:PreviewPage;
		
		/**
		 * 当前页面
		 */		
		private var currPage:PageBase;
		
		/**
		 * 底部导航条
		 */		
		public var nav:NavTop;
	}
}