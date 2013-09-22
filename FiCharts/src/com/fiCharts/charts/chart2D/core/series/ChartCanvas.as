package com.fiCharts.charts.chart2D.core.series
{
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 */	
	public class ChartCanvas extends Sprite
	{
		public function ChartCanvas()
		{
			super();
			
			this.addChild(seriesCanvas);
			this.addChild(dataLine);
			this.addChild(itemRenderCanvas);
			this.addChild(valueLabelsCanvas);
			valueLabelsCanvas.mouseEnabled = valueLabelsCanvas.mouseChildren = false;
		}
		
		/**
		 */		
		public var dataLine:Shape = new Shape;
		
		/**
		 * 此背景透明区域的绘制是为了便于判断鼠标是否位于图表区域， 从而
		 * 
		 * 决定数据缩放控制的开启和关闭
		 */		
		public function drawBG(w:Number, h:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, - h, w, h);
			this.graphics.endFill();
		}
		
		/**
		 * 鼠标移动时更新数据线的位置， 这个位置是以数据节点为基准的
		 */		
		public function updataDataLinePos(x:Number, y:Number):void
		{
			dataLine.x = x;
		}
		
		/**
		 * 绘制跟随鼠标移动的数据线
		 */		
		public function drawDataLine(h:Number, border:BorderLine):void
		{
			this.dataLine.graphics.clear();
			StyleManager.setLineStyle(dataLine.graphics, border);
			this.dataLine.graphics.moveTo(0, 0);
			this.dataLine.graphics.lineTo(0, - h);
		}
		
		/**
		 */		
		public function addValueLabel(bm:Bitmap):void
		{
			valueLabelsCanvas.addChild(bm);
		}
		
		/**
		 */		
		public function drawValueLabel(bd:BitmapData, mar:Matrix, px:Number, py:Number):void
		{
			valueLabelsCanvas.graphics.beginBitmapFill(bd, mar, false);
			valueLabelsCanvas.graphics.drawRect(px, py, bd.width, bd.height);
			valueLabelsCanvas.graphics.endFill();
		}
		
		/**
		 */		
		public function setItemAndValueLabelsAlpha(value:Number):void
		{
			valueLabelsCanvas.alpha = itemRenderCanvas.alpha = value;
		}
		
		/**
		 * 每次序列渲染之前需先清空数值标签
		 */		
		public function clearValuelabels():void
		{
			valueLabelsCanvas.graphics.clear();
			while (valueLabelsCanvas.numChildren)
				valueLabelsCanvas.removeChildAt(0);
		}
		
		/**
		 */		
		public function addItemRender(render:Sprite):void
		{
			itemRenderCanvas.addChild(render);
		}
		
		/**
		 */		
		public function clearItemRenders():void
		{
			while (itemRenderCanvas.numChildren)
				itemRenderCanvas.removeChildAt(0);
		}
		
		/**
		 */		
		private var seriesCanvas:Sprite = new Sprite;
		
		/**
		 */		
		private var itemRenderCanvas:Sprite = new Sprite;
		
		/**
		 */		
		private var valueLabelsCanvas:Sprite = new Sprite;
		
		/**
		 */		
		public function addSeries(series:Vector.<SB>):void
		{
			while (seriesCanvas.numChildren)
				seriesCanvas.removeChildAt(0);
			
			for each (var seriesItem:SB in series)
				seriesCanvas.addChild(seriesItem);
		}
		
	}
}