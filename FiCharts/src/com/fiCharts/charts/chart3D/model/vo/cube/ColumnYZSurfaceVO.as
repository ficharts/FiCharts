package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.utils.graphic.StyleManager;

	public class ColumnYZSurfaceVO extends YZSurfaceVO
	{
		public function ColumnYZSurfaceVO()
		{
			super();
		}
		
		/**
		 */		
		override public function generateColorEffect(isUp:int) : void
		{
			colorFillVO.width = zSize;
			colorFillVO.height = ySize;
			colorFillVO.tx = 0;
			
			if (isUp == 1)
				colorFillVO.ty = - ySize;
			else
				colorFillVO.ty = 0;
			
			colorFillVO.fillAngle = Math.PI * 1.1 / 2;
			colorFillVO.fillColors = [StyleManager.transformColor(fillColor, 1.8, 1.8, 1.8), 
				StyleManager.transformColor(fillColor, .9, .9, .9)];
		}
	}
}