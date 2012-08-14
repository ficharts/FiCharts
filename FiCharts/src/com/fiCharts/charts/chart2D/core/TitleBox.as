package com.fiCharts.charts.chart2D.core
{
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.layout.LayoutManager;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class TitleBox extends Sprite
	{
		public function TitleBox()
		{
			super(); 
			
			addChild(titleLabel);
			addChild(subTitleLabel);
		}
		
		/**
		 */		
		public function render():void
		{
			titleLabel.render();
			subTitleLabel.render();
			
			if (ifHasTitle && !ifHasSubTitle)// 仅有大标题
			{
				this.boxHeight = (titleLabel.style as LabelStyle).vMargin * 2 + titleLabel.height;
				titleLabel.y = (titleLabel.style as LabelStyle).vMargin;
				
				LayoutManager.hLayoutStyleUI(titleLabel, this.boxWidth);
			}
			else if (ifHasTitle && ifHasSubTitle)// 同时存在两种标题
			{
				this.boxHeight = (titleLabel.style as LabelStyle).vMargin * 2 + titleLabel.height + 
								 (subTitleLabel.style as LabelStyle).vMargin * 2 + subTitleLabel.height;
				
				titleLabel.y = (titleLabel.style as LabelStyle).vMargin;
				subTitleLabel.y = boxHeight - subTitleLabel.height - (subTitleLabel.style as LabelStyle).vMargin;
				
				LayoutManager.hLayoutStyleUI(titleLabel, this.boxWidth);
				LayoutManager.hLayoutStyleUI(subTitleLabel, this.boxWidth);
			}
			else if (!ifHasTitle && ifHasSubTitle)// 仅有小标题
			{
				this.boxHeight = (subTitleLabel.style as LabelStyle).vMargin * 2 + subTitleLabel.height;
				subTitleLabel.y = (subTitleLabel.style as LabelStyle).vMargin;
				
				LayoutManager.hLayoutStyleUI(subTitleLabel, this.boxWidth);
			}
			else// 没有标题
			{
				
			}
			
		}
		
		/**
		 * 是否含有标题， 只要含有主标题或者副标题任意一项
		 * 
		 * 都算含有
		 * 
		 */		
		public function get ifHasTitles():Boolean
		{
			if (ifHasTitle || ifHasSubTitle)
				return true;
			else
				return false;
		}
		
		/**
		 */		
		private function get ifHasTitle():Boolean
		{
			return !RexUtil.ifTextNull(titleLabel.text);
		}
		
		/**
		 */		
		private function get ifHasSubTitle():Boolean
		{
			return !RexUtil.ifTextNull(this.subTitleLabel.text);
		}
		
		/**
		 */		
		private var _boxWidth:Number;

		public function get boxWidth():Number
		{
			return _boxWidth;
		}

		public function set boxWidth(value:Number):void
		{
			_boxWidth = value;
		}

		/**
		 */		
		private var _boxHeight:Number = 0;

		public function get boxHeight():Number
		{
			return _boxHeight;
		}

		public function set boxHeight(value:Number):void
		{
			_boxHeight = value;
		}

		/**
		 */		
		public function updateStyle(title:LabelStyle, subTitle:LabelStyle):void
		{
			titleLabel.style = title;
			subTitleLabel.style = subTitle;
		}
		
		/**
		 */		
		private var titleLabel:LabelUI = new LabelUI;
		
		/**
		 */		
		private var subTitleLabel:LabelUI = new LabelUI;
	}
}