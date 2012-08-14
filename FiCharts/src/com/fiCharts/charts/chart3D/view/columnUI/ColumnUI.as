package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.ManagerFor3D;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnXZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnYZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.CubeVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.YZSurfaceVO;
	import com.fiCharts.charts.chart3D.view.CubeUI;
	import com.fiCharts.utils.MathUtil;
	
	import flash.geom.Rectangle;
	
	/**
	 */	
	public class ColumnUI extends CubeUI
	{
		public function ColumnUI(cubeVO:CubeVO)
		{
			super(cubeVO);
		}
		
		/**
		 */		
		override protected function initSurface():void
		{
			//创建VO
			cubeVO.frontSideSurface = new XYSurfaceVO;
			cubeVO.backSideSurface = new XYSurfaceVO;
			
			cubeVO.rightSideSurface = new ColumnYZSurfaceVO;
			cubeVO.leftSideSurface = new ColumnYZSurfaceVO;
			
			cubeVO.topSideSurface = new ColumnXZSurfaceVO;
			cubeVO.bottomSideSurface = new ColumnXZSurfaceVO;
			
			//创建UI
			frontSurface = new ColumnXYSurfaceUI(columnRenderVO.frontSideSurface);
			backSurface = new ColumnXYSurfaceUI(columnRenderVO.backSideSurface);
			
			rightSideSurface = new ColumnYZSurfaceUI(columnRenderVO.rightSideSurface);
			leftSideSurface = new ColumnYZSurfaceUI(columnRenderVO.leftSideSurface);
			
			topSurface = new ColumnXZSurfaceUI(columnRenderVO.topSideSurface);
			bottomSurface = new ColumnXZSurfaceUI(columnRenderVO.bottomSideSurface);
		
			if (columnRenderVO.direction == ColumnVO.COLUMN_UP)
			{
				addChild(bottomSurface);
				addChild(leftSideSurface);
				addChild(backSurface);
				addChild(rightSideSurface);
				addChild(frontSurface);
				addChild(topSurface);
			}
			else
			{
				addChild(topSurface);
				addChild(leftSideSurface);
				addChild(backSurface);
				addChild(rightSideSurface);
				addChild(frontSurface);
				addChild(bottomSurface);
			}
			
			frontSurface.alpha = rightSideSurface.alpha = topSurface.alpha = .9;
		}
		
		/**
		 * 2D 面每次都是根据3D信息重绘;重绘时柱体高度方向的位置与尺寸取整， 从终端限制尺寸精度；
		 */		
		override public function render():void
		{
			if (columnRenderVO.direction == ColumnVO.COLUMN_UP)
			{
				ManagerFor3D.generateColumn2DPath(cubeVO);
				ManagerFor3D.generateCubeColor(cubeVO);
			}
			else
			{
				ManagerFor3D.generateColumn2DPath(cubeVO, - 1);
				ManagerFor3D.generateCubeColor(cubeVO, - 1);
			}
			
			this.x = columnRenderVO.location2D.x;
			this.y = columnRenderVO.location2D.y;
			
			topSurface.render();
			leftSideSurface.render();
			rightSideSurface.render();
			frontSurface.render();
			backSurface.render();
			bottomSurface.render();
		}
		
		/**
		 */		
		private function get columnRenderVO():ColumnVO
		{
			return cubeVO as ColumnVO;
		}
		
		/**
		 */		
		public function setHeight(percent:Number):void
		{
			(frontSurface as ColumnSurfaceUIBase).renderWidthHeightPercent(percent);
			(rightSideSurface as ColumnSurfaceUIBase).renderWidthHeightPercent(percent);
			(topSurface as ColumnSurfaceUIBase).renderWidthHeightPercent(percent);
			
			(backSurface as ColumnSurfaceUIBase).renderWidthHeightPercent(percent);
			(leftSideSurface as ColumnSurfaceUIBase).renderWidthHeightPercent(percent);
			(bottomSurface as ColumnSurfaceUIBase).renderWidthHeightPercent(percent);
		}
		
		/**
		 */		
		private var leftSideSurface:ColumnSurfaceUIBase;
		private var backSurface:ColumnSurfaceUIBase;
		private var bottomSurface:ColumnSurfaceUIBase;
	}
}