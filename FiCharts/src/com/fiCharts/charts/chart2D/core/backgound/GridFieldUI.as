package com.fiCharts.charts.chart2D.core.backgound
{
	import com.fiCharts.charts.chart2D.core.model.GridFieldStyle;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	/**
	 */
	public class GridFieldUI extends Sprite
	{
		public static const HORITICAL:String = 'horitical';
		public static const VERTICAL:String = 'vartical';
		public static const BOTH:String = 'both';

		/**
		 *  Construcator.
		 */
		public function GridFieldUI()
		{
			super();
			
			this.mouseChildren = this.mouseEnabled = false;
			horizontalGrid.mask = hGridMask;
			verticalGrid.mask =  vGridMask
			addChild(horizontalGrid);
			addChild(verticalGrid);
			addChild(vGridMask);
			addChild(hGridMask);
			addChild(border);
			
		}
		
		/**
		 */		
		public function scrollHGrid(pos:Number):void
		{
			verticalGrid.x = pos;
		}
		
		/**
		 */		
		public function scrollVGrid(pos:Number):void
		{
			horizontalGrid.y = pos;
		}

		/**
		 *  Draw series BG.
		 */
		public function render(horiTicks:Vector.<Number>, vertiTicks:Vector.<Number>, 
							   style:GridFieldStyle):void
		{
			drawHorizontalGidLine(vertiTicks, style);
			drawVerticalGidLine(horiTicks, style);
			
			graphics.clear();
			StyleManager.setFillStyle(graphics, style);
			graphics.drawRoundRect(0, 0, style.width, style.height, style.radius, style.radius);
			
			border.graphics.clear();
			StyleManager.setLineStyle(border.graphics, style.getBorder);
			border.graphics.drawRoundRect(0, 0, style.width, style.height, style.radius, style.radius);
			
			var borderThikness:Number = 0;
			
			if (style.vGrid.border)
				borderThikness = style.vGrid.getBorder.thikness;
			else
				borderThikness = 0;
			
			vGridMask.graphics.clear();
			vGridMask.graphics.beginFill(0, 0);
			vGridMask.graphics.drawRoundRect( - borderThikness, 0, 
				style.width + borderThikness * 2, style.height, style.radius, style.radius);
			
			if (style.hGrid.border)
				borderThikness = style.hGrid.getBorder.thikness;
			else
				borderThikness = 0;
				
			hGridMask.graphics.clear();
			hGridMask.graphics.beginFill(0,0);
			hGridMask.graphics.drawRoundRect(0, - borderThikness, 
				style.width, style.height + borderThikness * 2, style.radius, style.radius);
		}

		/**
		 * 绘制横向分隔条
		 */
		public function drawHorizontalGidLine(ticks:Vector.<Number>, style:GridFieldStyle):void
		{
			var i:uint;
			var departs:int = ticks.length - 1;
			var lineY:Number;
			var partHeight:Number = style.height / departs;
			
			horizontalGrid.graphics.clear();
			
			// 绘制填充
			for (i = 0; i <= departs; i++)
			{
				lineY = style.height + ticks[i];
				
				if (i % 2 != 0 && i <= departs)
				{
					horizontalGrid.graphics.lineStyle(0, 0, 0);
					StyleManager.setFillStyle(horizontalGrid.graphics, style.hGrid);
					horizontalGrid.graphics.drawRect(0, lineY, style.width, partHeight);
					horizontalGrid.graphics.endFill();
				}
			}
			
			// 绘制网格
			StyleManager.setLineStyle(horizontalGrid.graphics, style.hGrid.getBorder);
			for (i = 0; i <= departs; i++)
			{
				lineY = style.height + ticks[i];
				
				horizontalGrid.graphics.moveTo(0, lineY);
				horizontalGrid.graphics.lineTo(style.width, lineY);
			}
			
			StyleManager.setEffects(horizontalGrid, style.hGrid);
		}

		/**
		 * 绘制纵向分隔条
		 */
		public function drawVerticalGidLine(ticks:Vector.<Number>, style:GridFieldStyle):void
		{
			var i:uint;
			var departs:uint = ticks.length - 1;
			var partLength:Number = style.width / departs;
			var lineX:Number;
			
			verticalGrid.graphics.clear();
			for (i = 0; i <= departs; i++)
			{
				lineX = ticks[i];
				
				if (i % 2 != 0 && i <= departs)
				{
					verticalGrid.graphics.lineStyle(0, 0, 0);
					StyleManager.setFillStyle(verticalGrid.graphics, style.vGrid);
					verticalGrid.graphics.drawRect(lineX, 0, partLength, style.height);
					verticalGrid.graphics.endFill();
				}
			}
			
			StyleManager.setLineStyle(verticalGrid.graphics, style.vGrid.getBorder);
			for (i = 0; i <= departs; i++)
			{
				lineX = ticks[i];
				
				verticalGrid.graphics.moveTo(lineX, 0);
				verticalGrid.graphics.lineTo(lineX, style.height);
			}
			
			StyleManager.setEffects(verticalGrid, style.vGrid);
		}
		
		/**
		 */		
		private var horizontalGrid:Shape = new Shape();
		private var verticalGrid:Shape = new Shape();
		private var vGridMask:Shape = new Shape;
		private var hGridMask:Shape = new Shape;
		private var border:Shape = new Shape;
		
	}
}