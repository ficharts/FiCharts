package com.fiCharts.charts.chart2D.marker
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderProxy;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 * 只显示数值
	 * 
	 * @author wallen
	 * 
	 */	
	public class MarkerSeriesItemRender extends ItemRenderBace
	{
		public function MarkerSeriesItemRender()
		{
			super();
		}
		
		/**
		 */		
		override public function render():void
		{
			this.radius = style.radius;
			
			style.tx = style.ty = - style.radius;
			style.width = style.height = style.radius * 2;
			
			canvas.graphics.clear();
			
			StyleManager.setShapeStyle(style, canvas.graphics, itemVO.metaData);
			
			canvas.graphics.moveTo(Math.cos(Math.PI * 2) * style.radius, Math.sin(Math.PI * 2) * style.radius);
			
			var current:uint = edges;
			
			while (current --)
				canvas.graphics.lineTo(Math.cos(current / edges * Math.PI * 2) * style.radius, Math.sin(current / edges * Math.PI * 2) * style.radius);
			
			canvas.graphics.endFill();
		}
		
		/**
		 */		
		private var _edges:uint = 3;
		
		/**
		 */
		public function get edges():uint
		{
			return _edges;
		}
		
		/**
		 * @private
		 */
		public function set edges(value:uint):void
		{
			_edges = value;
		}
		
	}
}