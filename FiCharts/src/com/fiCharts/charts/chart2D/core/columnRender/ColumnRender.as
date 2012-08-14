package com.fiCharts.charts.chart2D.core.columnRender
{
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	
	import flash.display.Graphics;

	/**
	 * 专门用户渲染柱体的效果类
	 */	
	public class ColumnRender
	{
		public function ColumnRender(graphics:Graphics, sourceColor:uint)
		{
			this.graphics = graphics;
			this.sourceColor = sourceColor;
		}
		
		/**
		 * 初始化各个参数， 准备渲染;
		 */		
		public function ready():void
		{
			fill.tx = fill.ty = 0;
			fill.fillRatioes = [0, 255 / 3, 255];
			fill.fillAngle = - Math.PI / 4;
			fill.fillAlphas = [this.fillAlpha, this.fillAlpha, this.fillAlpha];
			fill.fillColors = [StyleManager.transformBright(sourceColor, 1 + colorOffset)
				, StyleManager.transformBright(sourceColor, 1 + colorOffset), 
				StyleManager.transformBright(sourceColor, 1 - colorOffset)];
			
			edgeColor = StyleManager.transformBright(sourceColor, .5);
			brightEdgeColor =  StyleManager.transformBright(sourceColor, 1.5);
		}
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			
			fill.width = this.width;
			fill.height = this.height;
			StyleManager.setFill(graphics, fill);
			graphics.lineStyle(this.lineThikness, edgeColor, this.lineAlpha, false, 'normal', 'none', 'square');
			
			graphics.moveTo(0, 0);
			graphics.lineTo(0, height);
			graphics.lineTo(width, height);
			graphics.lineTo(width, 0);
			graphics.lineTo(0, 0);
			graphics.endFill();
			
			// 绘制高亮边
			graphics.lineStyle(this.lineThikness, brightEdgeColor, this.lineAlpha, false, 'normal', 'none', 'square');
			
			if (height >= 0)
			{
				if (ifReverseBrightLine)
				{
					graphics.moveTo(1, height);
					graphics.lineTo(1, 1);
					graphics.lineTo(width - 1, 1);
				}
				else
				{
					graphics.moveTo(1, 1);
					graphics.lineTo(1, height - 1);
					graphics.lineTo(width - 1, height - 1);
				}
			}
			else
			{
				graphics.moveTo(1, - 1);
				graphics.lineTo(1, height + 1);
				graphics.lineTo(width - 1, height + 1);
			}
		}
		
		/**
		 * 是否反转高光, 高光默认是在左下方； 
		 */		
		private var _ifReverseBrightLine:Boolean = false;

		/**
		 */
		public function get ifReverseBrightLine():Boolean
		{
			return _ifReverseBrightLine;
		}

		/**
		 * @private
		 */
		public function set ifReverseBrightLine(value:Boolean):void
		{
			_ifReverseBrightLine = value;
		}

		
		/**
		 */		
		private var _colorOffset:Number = .1;

		public function get colorOffset():Number
		{
			return _colorOffset;
		}

		public function set colorOffset(value:Number):void
		{
			_colorOffset = value;
		}

		private var _lineThikness:Number = 1;

		public function get lineThikness():Number
		{
			return _lineThikness;
		}

		public function set lineThikness(value:Number):void
		{
			_lineThikness = value;
		}

		private var _lineAlpha:Number = 1;

		public function get lineAlpha():Number
		{
			return _lineAlpha;
		}

		public function set lineAlpha(value:Number):void
		{
			_lineAlpha = value;
		}
		
		private var _fillAlpha:Number = .8;

		public function get fillAlpha():Number
		{
			return _fillAlpha;
		}

		public function set fillAlpha(value:Number):void
		{
			_fillAlpha = value;
		}
		
		/**
		 */		
		private var _width:Number;

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		/**
		 */		
		private var _height:Number;

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}
		
		/**
		 */		
		private var graphics:Graphics;
		
		/**
		 * 原始颜色； 
		 */		
		private var sourceColor:uint;
		
		/**
		 * 外边阴影颜色 
		 */		
		private var edgeColor:uint;
		
		/**
		 * 内边高光颜色 
		 */		
		private var brightEdgeColor:uint;
		
		/**
		 */		
		protected var fill:GradientColorStyle = new GradientColorStyle;
	}
}