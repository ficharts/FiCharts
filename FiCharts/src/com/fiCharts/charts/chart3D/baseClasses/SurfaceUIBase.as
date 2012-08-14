package com.fiCharts.charts.chart3D.baseClasses
{
	
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.Point2D;
	
	import flash.display.Sprite;
	
	public class SurfaceUIBase extends Sprite
	{
		
		/**
		 * @param surfaceVO
		 */		
		public function SurfaceUIBase(surfaceVO:SurfaceVOBase)
		{
			super();
			this.surfaceVO = surfaceVO;
			surfaceUI = new Sprite();
			addChild(surfaceUI);
		}
		
		/**
		 */		
		protected var surfaceVO:SurfaceVOBase;
		
		/**
		 */		
		public function render():void
		{
			this.x = surfaceVO.location2D.x;
			this.y = surfaceVO.location2D.y;
			
			surfaceUI.graphics.clear();
			surfaceUI.graphics.moveTo(0, 0);
			
			StyleManager.setFill(surfaceUI.graphics, surfaceVO.colorFillVO);
			
			for each (var point:Point2D in surfaceVO.path2D)
				surfaceUI.graphics.lineTo(point.x, point.y);	 
			
			surfaceUI.graphics.lineTo(0, 0);
			surfaceUI.graphics.endFill();
		}
		
		/**
		 */		
		protected var surfaceUI:Sprite;
	}
}