package com.fiCharts.charts.chart3D.model.vo.bg
{
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	
	public class BgBackCubeXYSurfaceVO extends XYSurfaceVO
	{
		public function BgBackCubeXYSurfaceVO()
		{
			super();
		}
		
		/**
		 */		
		override public function generateColorEffect(isUp:int):void
		{
			var fillVO:GradientColorStyle = new GradientColorStyle();
			fillVO.width = xSize;
			fillVO.height = ySize;
			fillVO.tx = 0;
			fillVO.ty = - ySize;
			fillVO.fillAngle = Math.PI * 1 / 2;
			
			fillVO.fillColors = [StyleManager.transformColor(fillColor, 1, 1, 1), 
				StyleManager.transformColor(fillColor, .9, .9, .9)];
			
			this.colorFillVO = fillVO;
		}
	}
}