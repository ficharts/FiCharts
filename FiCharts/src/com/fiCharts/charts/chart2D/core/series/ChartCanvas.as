package com.fiCharts.charts.chart2D.core.series
{
	import com.fiCharts.charts.chart2D.encry.SB;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
			this.addChild(itemRenderCanvas);
			this.addChild(valueLabelsCanvas);
			valueLabelsCanvas.mouseEnabled = valueLabelsCanvas.mouseChildren = false;
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