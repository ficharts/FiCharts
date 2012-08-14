package com.fiCharts.charts.chart3D.view.bg
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.charts.chart3D.model.vo.bg.YZBackgroundAixsVO;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	public class SideBackgroundAxisUI extends SurfaceUIBase
	{
		public function SideBackgroundAxisUI(surfaceVO:SurfaceVOBase)
		{
			super(surfaceVO);
		}
		
		/**
		 */		
		private function get sideBackgroundAxisVO():YZBackgroundAixsVO
		{
			return super.surfaceVO as YZBackgroundAixsVO;
		}
		
		/**
		 */		
		override public function render() : void
		{
			this.x = sideBackgroundAxisVO.location2D.x;
			this.y = sideBackgroundAxisVO.location2D.y;
			
			graphics.clear();
			
			//绘制侧面
			graphics.lineStyle(sideBackgroundAxisVO.lineThikness, sideBackgroundAxisVO.lineColor);
			graphics.beginFill(surfaceVO.fillColor, .3);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(sideBackgroundAxisVO.offSet, - sideBackgroundAxisVO.offSet);
			graphics.lineTo(sideBackgroundAxisVO.offSet, - sideBackgroundAxisVO.offSet - sideBackgroundAxisVO.ySize);
			graphics.lineTo(0, - sideBackgroundAxisVO.ySize);
			graphics.lineTo(0, 0);
			graphics.endFill();
			
			//绘制分割线；
			var i:uint;
			var length:uint = sideBackgroundAxisVO.linePositions.length;
			for (i = 0; i < length; i ++)
			{
				graphics.moveTo(0, sideBackgroundAxisVO.linePositions[i]);
				graphics.lineTo(sideBackgroundAxisVO.offSet, 
					sideBackgroundAxisVO.linePositions[i] - sideBackgroundAxisVO.offSet);
			}
			
			graphics.lineStyle(sideBackgroundAxisVO.lineThikness, 
				StyleManager.transformColor(sideBackgroundAxisVO.lineColor, 1.8, 1.8, 1.8));
			
			for (i = 0; i < length; i ++)
			{
				graphics.moveTo(sideBackgroundAxisVO.lineThikness, sideBackgroundAxisVO.linePositions[i] + 
					sideBackgroundAxisVO.lineThikness / 2);
				
				graphics.lineTo(sideBackgroundAxisVO.offSet - sideBackgroundAxisVO.lineThikness / 2, 
					sideBackgroundAxisVO.linePositions[i] - sideBackgroundAxisVO.offSet + 
					sideBackgroundAxisVO.lineThikness + sideBackgroundAxisVO.lineThikness / 2);
			}
			
			
		}
	}
}