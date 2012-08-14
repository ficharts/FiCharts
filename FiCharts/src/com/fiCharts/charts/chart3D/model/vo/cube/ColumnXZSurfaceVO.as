package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.StyleManager;

	public class ColumnXZSurfaceVO extends XZSurfaceVO
	{
		public function ColumnXZSurfaceVO()
		{
			super();
		}
		
		/**
		 */		
		override public function generateColorEffect(isUp:int) : void
		{
			colorFillVO.width = xSize;
			colorFillVO.height = zSize;
			colorFillVO.tx = 0;
			colorFillVO.ty = - zSize;
			
			colorFillVO.fillAngle = Math.PI * 5 / 8;
			colorFillVO.fillColors = [StyleManager.transformColor(fillColor, 1.7, 1.7, 1.7), fillColor];
		}
	}
}