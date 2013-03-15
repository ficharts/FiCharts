package com.fiCharts.charts.chart2D.core.zoomBar
{
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.utils.interactive.DragControl;
	import com.fiCharts.utils.interactive.IDragCanvas;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class ZoomPointRight extends Sprite implements IDragCanvas
	{
		/**
		 */		
		public function ZoomPointRight(zoomBar:ZoomBar)
		{
			this.zoomBar = zoomBar;
			this.addChild(rightZoomPoint);
			
			dragControl = new DragControl(rightZoomPoint, this);
		}
		
		/**
		 */		
		public function render():void
		{
			//以填充色为基准
			rightZoomPoint.metaData = metaData;
			this.rightZoomPoint.render();
		}
		
		/**
		 */		
		public var metaData:Object;
		
		/**
		 */		
		public function setZoomPointRender(render:DataRender):void
		{
			render.toNormal();
			rightZoomPoint.dataRender = render;
		}
		
		/**
		 */		
		private var zoomBar:ZoomBar;
		
		/**
		 */		
		public function startScroll():void
		{
		}
		
		/**
		 */		
		public function scrolling(offset:Number, sourceOffset:Number):void
		{
			rightZoomPoint.x += offset;
			
			if (rightZoomPoint.x < 0)
				rightZoomPoint.x = 0
			else if (rightZoomPoint.x > max)
				rightZoomPoint.x = max;
			
			zoomBar.zoomWinRight(rightZoomPoint.x);
		}
		
		/**
		 */		
		public var max:Number = 0;
		
		/**
		 */		
		public function stopScroll(offset:Number, sourceOffset:Number):void
		{
		}
		
		/**
		 */		
		internal function update(x:Number, w:Number):void
		{
			rightZoomPoint.x = x + w;
		}
		
		/**
		 */		
		private var dragControl:DragControl;
		
		/**
		 */		
		private var rightZoomPoint:ZoomPointUI = new ZoomPointUI;
	}
}