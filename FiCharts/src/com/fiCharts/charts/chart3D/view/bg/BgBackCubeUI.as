package com.fiCharts.charts.chart3D.view.bg
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.model.vo.bg.BgBackCubeXYSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.CubeVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.YZSurfaceVO;
	import com.fiCharts.charts.chart3D.view.CubeUI;
	
	public class BgBackCubeUI extends CubeUI
	{
		public function BgBackCubeUI(cubeVO:CubeVO)
		{
			super(cubeVO);
		}
		
		override protected function initSurface():void
		{
			cubeVO.frontSideSurface = new BgBackCubeXYSurfaceVO;
			cubeVO.rightSideSurface = new YZSurfaceVO;
			cubeVO.topSideSurface = new XZSurfaceVO
				;
			
			frontSurface = new SurfaceUIBase(cubeVO.frontSideSurface);
			rightSideSurface = new SurfaceUIBase(cubeVO.rightSideSurface);
			topSurface = new SurfaceUIBase(cubeVO.topSideSurface);
			
			addChild(frontSurface);
			addChild(rightSideSurface);
			addChild(topSurface);
		}
	}
}