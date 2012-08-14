package com.fiCharts.charts.chart3D.view.bg
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.charts.chart3D.model.vo.bg.XYBackgoundAxisVO;
	import com.fiCharts.utils.graphic.StyleManager;
	
	public class XYBackgroundAxisUI extends SurfaceUIBase
	{
		public function XYBackgroundAxisUI(surfaceVO:SurfaceVOBase)
		{
			super(surfaceVO);
		}
		
		private function get backgroundAxisVO():XYBackgoundAxisVO
		{
			return super.surfaceVO as XYBackgoundAxisVO;
		}
		
		/**
		 */		
		override public function render() : void
		{
			this.x = backgroundAxisVO.location2D.x;
			this.y = backgroundAxisVO.location2D.y;
			
			var i:uint;
			var startIndex:uint = 0;
			var length:uint = backgroundAxisVO.linePositions.length;
			graphics.clear();
			graphics.lineStyle(backgroundAxisVO.lineThikness, backgroundAxisVO.lineColor);
			
			for (i = startIndex; i < length; i ++)
			{
				graphics.moveTo(0, backgroundAxisVO.linePositions[i]);
				graphics.lineTo(backgroundAxisVO.xSize, backgroundAxisVO.linePositions[i]);
			}
			
			//return;
			
			graphics.lineStyle(backgroundAxisVO.lineThikness, 
				StyleManager.transformColor(backgroundAxisVO.lineColor, 1.8, 1.8, 1.8));
			
			for (i = startIndex; i < length; i ++)
			{
				graphics.moveTo(0, backgroundAxisVO.linePositions[i] + backgroundAxisVO.lineThikness);
				graphics.lineTo(backgroundAxisVO.xSize, backgroundAxisVO.linePositions[i] + 
					backgroundAxisVO.lineThikness);
			}
		}
	}
}