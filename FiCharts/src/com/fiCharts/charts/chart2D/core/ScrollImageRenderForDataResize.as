package com.fiCharts.charts.chart2D.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * 绘制序列截图，配合数据滚动与缩放
	 * 
	 */	
	public class ScrollImageRenderForDataResize extends Sprite
	{
		public function ScrollImageRenderForDataResize()
		{
			super();
			this.mouseEnabled = this.mouseEnabled = false;
			this.addChild(canvas);
			this.mask = maskS;
			addChild(maskS);
		}
		
		/**
		 */		
		private var maskS:Shape = new Shape;
		
		/**
		 */		
		public function drawMask(w:Number, h:Number):void
		{
			maskS.graphics.clear();
			maskS.graphics.beginFill(0, 0);
			maskS.graphics.drawRect(0, - h, w, h);
		}
		
		/**
		 */		
		private var canvas:Shape = new Shape;
		
		/**
		 */		
		public var startPos:Number = 0;
		
		/**
		 */		
		public var endPos:Number = 0;
		
		/**
		 * 绘制图像
		 */		
		public function draw(bmd:BitmapData, matr:Matrix, w:Number, h:Number):void
		{
			canvas.graphics.beginBitmapFill(bmd, matr, false, true);
			canvas.graphics.drawRect(matr.tx, matr.ty, w, h);
			
			if (matr.tx < this.startPos)
				this.startPos = matr.tx;
			
			if (matr.tx + w > this.endPos)
				endPos = matr.tx + w;
		}
		
		/**
		 * 清空绘图和位置信息
		 */		
		public function reset():void
		{
			canvas.graphics.clear();
			canvas.x = 0;
			
			endPos = 0;
			startPos = 0;
		}
		
		/**
		 */		
		public function scroll(pos:Number):void
		{
			canvas.x = pos;
		}
		
		/**
		 */		
		public function scale(value:Number):void
		{
			
		}
	}
}