package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnVO;
	import com.fiCharts.ui.text.Label;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.style.FillStyle;
	
	import flash.display.Sprite;
	
	public class ColumnValueLabelBase extends Sprite
	{
		public function ColumnValueLabelBase(labelString:String)
		{
			super();
			
			this.labelString = labelString;
			valueLabel = new Label();
			addChild(valueLabel);
		}
		
		/**
		 */		
		public function setFontStyle(fontStyle:LabelStyle):void
		{
			valueLabel.setTextFormat(fontStyle.getTextFormat());
		}
		
		/**
		 */		
		public function setFillStyle(fillStyle:Fill):void
		{
			this.fillStyle = fillStyle;
		}
		
		/**
		 */		
		protected var fillStyle:Fill;
		
		/**
		 */		
		public function layout(renderVO:ColumnVO):void
		{
			var offSet:Number = renderVO.zSize * Math.cos(Math.PI / 4) / 2;
			x = renderVO.location2D.x + renderVO.xSize / 2 + offSet / 2;
			y = renderVO.location2D.y - renderVO.ySize - offSet - bgHeight / 2;
		}
		
		/**
		 */		
		protected var labelString:String;
		
		/**
		 */		
		public function render():void
		{
			valueLabel.reLabel(labelString);
			valueLabel.x = - valueLabel.width / 2;
			valueLabel.y = - valueLabel.height / 2;
			
			this.graphics.clear();
			
			drawFill();
			
			var w:Number = 10;
			var h:Number = 6;
			var offY:Number = bgHeight / 2;
			var offX:uint = 0;
			
			graphics.beginFill(uint(fillStyle.color), Number(fillStyle.alpha));
			graphics.moveTo(offX, offY);
			graphics.lineTo(w / 2 + offX, offY);
			graphics.lineTo(offX, h + offY);
			graphics.lineTo(- w / 2 + offX, offY);
			graphics.lineTo(offX, offY);
			graphics.endFill();
		}
		
		/**
		 */		
		protected function drawFill():void
		{
			var fillVO:GradientColorStyle = new GradientColorStyle();
			fillVO.fillAngle = Math.PI / 2;
			fillVO.fillColors = [ StyleManager.transformBright(uint(fillStyle.color), 1.2), 
				StyleManager.transformBright(uint(fillStyle.color), .9)];
			
			fillVO.tx = leftX;
			fillVO.ty = topY;
			fillVO.width = bgWidth;
			fillVO.height = bgHeight;
			fillVO.fillAlphas = [fillStyle.alpha, fillStyle.alpha];
			StyleManager.setFill(this.graphics, fillVO);
			graphics.drawRoundRect(leftX, topY,bgWidth, bgHeight, bgHeight, bgHeight);
			
			graphics.endFill();
		}
		
		/**
		 */		
		protected function get bgWidth():Number
		{
			return valueLabel.width + widthExpender;
		}
		
		protected function get bgHeight():Number
		{
			return valueLabel.height + heightExpender;
		}
		
		/**
		 */		
		protected function get leftX():Number
		{
			return valueLabel.x - widthExpender / 2;
		}
		
		/**
		 */		
		protected function get topY():Number
		{
			return valueLabel.y - heightExpender / 2;
		}
		
		/**
		 */		
		protected var heightExpender:uint = 2;
		protected var widthExpender:uint = 10;
		protected var valueLabel:Label;
	}
}