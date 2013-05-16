package com.fiCharts.utils.layout
{
	import flash.geom.Rectangle;

	/**
	 * 以方格子的方式排列内容
	 */	
	public class BoxLayout
	{
		public function BoxLayout()
		{
		}
		
		/**
		 * 设置起始点的坐标 
		 */		
		public function setLoc(x:Number, y:Number):void
		{
			this.rect.x = x;
			this.rect.y = y;
		}
		
		/**
		 * 设置单元格的尺寸和总宽
		 */		
		public function setItemSizeAndFullWidth(rectW:Number, itemW:Number, itemH:Number):void
		{
			this.rect.width = rectW;
			
			this.cellW = itemW;
			this.cellH = itemH;
			
			maxColumnNum = Math.floor(rectW / cellW);
			this.gap = (rectW - maxColumnNum * cellW) / (maxColumnNum + 1);
		}
		
		/**
		 * 设置总体宽高，用于水平单行的排列
		 */		
		public function setHoriHeightAndGap(h:Number, iW:Number, gap:uint = 7):void
		{
			this.gap = gap;
			this.cellH = h - 2 * gap;
			this.cellW = iW;
		}
		
		/**
		 */		
		public function horiLayout(item:IBoxItem):void
		{
			item.itemW = this.cellW;
			item.itemH = this.cellH;
			
			item.x = rect.x + gap + curColumn * (cellW + gap);
			item.y = rect.y + gap;
			
			curColumn += 1;
		}
		
		/**
		 */		
		public function get horiWidth():Number
		{
			return this.gap * (curColumn + 1)  + curColumn * this.cellW;
		}
		
		/**
		 */		
		private var maxColumnNum:uint = 0;
		
		/**
		 */		
		private var maxRowNum:uint = 0;
		
		/**
		 * 准备开始布局了
		 */		
		public function ready():void
		{
			this.curColumn = this.curRow = 0;
		}
		
		/**
		 */		
		public function getRectHeight():Number
		{
			this.rect.height = (this.curRow + 1) * this.cellH + (this.curRow + 2) * this.gap;
			
			return this.rect.height;
		}
		
		/**
		 * 一个一个布局
		 */		
		public function layout(item:IBoxItem):void
		{
			if (curColumn >= maxColumnNum)
			{
				curRow += 1;
				curColumn = 0;
			}
			
			item.itemW = this.cellW;
			item.itemH = this.cellH;
			
			item.x = rect.x + this.gap + cellW * curColumn + this.gap * curColumn;
			item.y = rect.y + this.gap + cellH * curRow + this.gap * curRow;
			
			curColumn ++;
		}
		
		/**
		 */		
		private var curColumn:uint = 0;
		
		/**
		 */		
		private var curRow:uint = 0;
		
		/**
		 * 布局范围
		 */		
		private var _rect:Rectangle = new Rectangle;

		/**
		 */
		public function get gap():uint
		{
			return _gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:uint):void
		{
			_gap = value;
		}

		/**
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}

		/**
		 * @private
		 */
		public function set rect(value:Rectangle):void
		{
			_rect = value;
		}
		
		/**
		 * 单元格的宽
		 */		
		private var cellW:Number = 0;
		
		/**
		 * 单元格的高 
		 */		
		private var cellH:Number = 0;
		
		/**
		 * 内边距
		 */		
		private var _padding:uint = 20;
		
		/**
		 * 内部元件之间的间距，相当于是行距和列距
		 */		
		private var _gap:uint = 10;

	}
}