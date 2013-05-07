package
{
	import alert.AlertEvent;
	import alert.AlertPanel;
	
	import com.fiCharts.utils.StageUtil;
	import com.greensock.TweenLite;
	
	import edit.EditPage;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import navBar.NavBottom;
	
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
			this.addChild(pageContainer);
			
			templatePage = new TemplePage(this);
			editPage = new EditPage(this);
			previewPage = new PreviewPage(this);
			
			editPage.x = templatePage.w;
			previewPage.x = templatePage.w * 2;
			
			pageContainer.addPage(templatePage);
			pageContainer.addPage(editPage);
			pageContainer.addPage(previewPage);
			
			bottomNav = new NavBottom(this);
			addChild(bottomNav);
			
			toTemplatePage();
			
			this.addChild(maskShape);
			pageContainer.mask = maskShape;
			maskShape.graphics.clear();
			maskShape.graphics.beginFill(0);
			maskShape.graphics.drawRect(0, 0, templatePage.w, templatePage.height);
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xDEDEDE);
			this.graphics.drawRect(0, 0, 980, this.height);
			this.graphics.endFill();
			
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
			//if (this.currPage)
			//	currPage.hide();
			currPage = newPage;
			//currPage.show();
			bottomNav.y = currPage.h;
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
		public var bottomNav:NavBottom;
	}
}