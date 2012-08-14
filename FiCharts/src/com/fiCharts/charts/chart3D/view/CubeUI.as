package com.fiCharts.charts.chart3D.view
{
	import com.fiCharts.charts.chart3D.ManagerFor3D;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnXZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnYZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.CubeVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.YZSurfaceVO;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 柱状体
	 *  
	 * @author wallen
	 * 
	 */	
	public class CubeUI extends Sprite
	{
		private var _cubeVO:CubeVO;

		public function get cubeVO():CubeVO
		{
			return _cubeVO;
		}

		public function set cubeVO(value:CubeVO):void
		{
			_cubeVO = value;
		}

		
		/**
		 * @param cubeVO
		 */		
		public function CubeUI(cubeVO:CubeVO)
		{
			super();
			
			this.mouseChildren = false;
			this.cubeVO = cubeVO;
			
			initSurface();
		}
		
		/**
		 */		
		protected function initSurface():void
		{
			cubeVO.frontSideSurface = new XYSurfaceVO;
			cubeVO.rightSideSurface = new YZSurfaceVO;
			cubeVO.topSideSurface = new XZSurfaceVO;
			
			frontSurface = new SurfaceUIBase(cubeVO.frontSideSurface);
			rightSideSurface = new SurfaceUIBase(cubeVO.rightSideSurface);
			topSurface = new SurfaceUIBase(cubeVO.topSideSurface);

			addChild(frontSurface);
			addChild(rightSideSurface);
			addChild(topSurface);
		}
		
		/**
		 */		
		public function render():void
		{
			ManagerFor3D.generateCube2DPath(cubeVO);
			ManagerFor3D.generateCubeColor(cubeVO);
			
			this.x = cubeVO.location2D.x;
			this.y = cubeVO.location2D.y;
			
			
			frontSurface.render();
			rightSideSurface.render();
			topSurface.render();
		}
		
		/**
		 */		
		protected var frontSurface:SurfaceUIBase;
		
		protected var rightSideSurface:SurfaceUIBase;
		
		protected var topSurface:SurfaceUIBase;
	}
}