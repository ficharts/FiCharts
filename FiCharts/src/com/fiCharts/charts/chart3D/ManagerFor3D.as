package com.fiCharts.charts.chart3D
{
	import com.fiCharts.charts.chart3D.model.vo.cube.CubeVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XZSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.YZSurfaceVO;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.Point2D;
	import com.fiCharts.utils.graphic.Point3D;
	
	import flash.geom.Matrix;

	public class ManagerFor3D
	{
		public function ManagerFor3D()
		{
		}
		
		/**
		 */		
		public static function generateCubeColor(cube:CubeVO, isUp:int = 1):void
		{
			cube.frontSideSurface.fillColor = StyleManager.transformColor(cube.color, 1.3, 1.3, 1.3);
			cube.rightSideSurface.fillColor = StyleManager.transformColor(cube.color, .7, .7, .7);
			cube.topSideSurface.fillColor = StyleManager.transformColor(cube.color, 1.5, 1.5, 1.5);
			
			cube.frontSideSurface.generateColorEffect(isUp);
			cube.rightSideSurface.generateColorEffect(isUp);
			cube.topSideSurface.generateColorEffect(isUp);
			
			if (cube.leftSideSurface)
			{
				cube.leftSideSurface.fillColor = StyleManager.transformColor(cube.color, .7, .7, .7);
				cube.leftSideSurface.generateColorEffect(isUp);
			}
			
			if (cube.backSideSurface)
			{
				cube.backSideSurface.fillColor = StyleManager.transformColor(cube.color, 1.3, 1.3, 1.3);				
				cube.backSideSurface.generateColorEffect(isUp);
			}
			
			if (cube.bottomSideSurface)
			{
				cube.bottomSideSurface.fillColor = StyleManager.transformColor(cube.color, 1.5, 1.5, 1.5);
				cube.bottomSideSurface.generateColorEffect(isUp);
			}
		}
		
		/**
		 * 生成柱状体的三个面，并将每个面转化为不具有轴侧效果的2D面路径；
		 */		
		public static function generateColumn2DPath(cube:CubeVO, isUp:int = 1):void
		{
			generate3DPath(cube, isUp, .5 * Math.cos(Math.PI / 4));
			transform3DTo2DPathWithoutMatrix(cube);
		}
		
		/**
		 * 生成柱状体的三个面并将每个面转化为2D路径；
		 * 
		 * @param cube
		 */		
		public static function generateCube2DPath(cube:CubeVO, isUp:int = 1):void
		{
			generate3DPath(cube, isUp);
			transform3DTo2DPath(cube);
		}
		
		private static function generate3DPath(cube:CubeVO, isUp:int, matrixRadio:Number = 1):void
		{
			//柱体坐标转换
			cube.location2D = transform3DTo2DPoint(cube.location3D);
			
			// 前立面
			var frontSurface:XYSurfaceVO = cube.frontSideSurface as XYSurfaceVO;
			frontSurface.location3D.x = frontSurface.location3D.y = frontSurface.location3D.z = 0;
			frontSurface.xSize = cube.xSize;
			frontSurface.ySize = cube.ySize;
			generateXYSurfacePath(frontSurface, isUp);
			
			//后立面
			if (cube.backSideSurface)
			{
				var backSurface:XYSurfaceVO = cube.backSideSurface as XYSurfaceVO;
				backSurface.location3D.x = backSurface.location3D.y = 0;
				backSurface.location3D.z = cube.zSize;
				backSurface.xSize = cube.xSize;
				backSurface.ySize = cube.ySize;
				generateXYSurfacePath(backSurface, isUp);
			}
			
			// 右立面
			var rightSurface:YZSurfaceVO = cube.rightSideSurface as YZSurfaceVO;
			rightSurface.location3D.x = cube.xSize;
			rightSurface.location3D.y = rightSurface.location3D.z = 0;
			rightSurface.ySize = cube.ySize;
			rightSurface.zSize = cube.zSize * matrixRadio;
			generateYZSurfacePath(rightSurface, isUp);
			
			// 左立面
			if (cube.leftSideSurface)
			{
				var leftSurface:YZSurfaceVO = cube.leftSideSurface as YZSurfaceVO;
				leftSurface.location3D.x = 0;
				leftSurface.location3D.y = leftSurface.location3D.z = 0;
				leftSurface.ySize = cube.ySize;
				leftSurface.zSize = cube.zSize * matrixRadio;
				generateYZSurfacePath(leftSurface, isUp);
			}
			
			// 上立面
			var topSurface:XZSurfaceVO = cube.topSideSurface as XZSurfaceVO;
			topSurface.location3D.x = topSurface.location3D.z = 0;
			topSurface.location3D.y = cube.ySize * isUp;
			topSurface.xSize = cube.xSize;
			topSurface.zSize = cube.zSize * matrixRadio;
			generateXZSurfacePath(topSurface);
			
			//下立面
			if (cube.bottomSideSurface)
			{
				var bottomSurface:XZSurfaceVO = cube.bottomSideSurface as XZSurfaceVO;
				bottomSurface.location3D.x = bottomSurface.location3D.z = 0;
				bottomSurface.location3D.y = 0;
				bottomSurface.xSize = cube.xSize;
				bottomSurface.zSize = cube.zSize * matrixRadio;
				generateXZSurfacePath(bottomSurface);
			}
		}
		
		/**
		 */		
		private static function generateXYSurfacePath(surface:XYSurfaceVO, isUp:int):void
		{
			var path:Vector.<Point3D> = new Vector.<Point3D>();
			var point:Point3D = new Point3D();
			point.x = point.z = 0
			point.y = surface.ySize * isUp;
			path.push(point);
			
			point = new Point3D();
			point.x = surface.xSize;
			
			point.y = surface.ySize * isUp;
			point.z = 0;
			path.push(point);
			
			point = new Point3D();
			point.x = surface.xSize;
			point.y = point.z = 0;
			path.push(point);
			
			surface.path3D = path;
		}
		
		/**
		 */		
		private static function generateYZSurfacePath(surface:YZSurfaceVO, isUp:int):void
		{
			var path:Vector.<Point3D> = new Vector.<Point3D>();
			var point:Point3D = new Point3D();
			point.x = point.z = 0
			point.y = surface.ySize * isUp;
			path.push(point);
			
			point = new Point3D();
			point.x = 0;
			point.y = surface.ySize * isUp;
			point.z = surface.zSize;
			path.push(point);
			
			point = new Point3D();
			point.x = 0;
			point.y = 0;
			point.z = surface.zSize;
			path.push(point);
			
			surface.path3D = path;
		}
		
		/**
		 */		
		private static function generateXZSurfacePath(surface:XZSurfaceVO):void
		{
			var path:Vector.<Point3D> = new Vector.<Point3D>();
			var point:Point3D = new Point3D();
			point.x = 0;
			point.y = 0;
			point.z = surface.zSize;
			path.push(point);
			
			point = new Point3D();
			point.x = surface.xSize;
			point.y = 0;
			point.z = surface.zSize;
			path.push(point);
			
			point = new Point3D();
			point.x = surface.xSize;
			point.y = 0;
			point.z = 0;
			path.push(point);
			
			surface.path3D = path;
		}
		
		//-----------------------------------------------------------------
		//
		//  坐标系转换
		//
		//-----------------------------------------------------------------
		
		
		//----------------------------------------------
		//
		// 无轴侧效果的转换
		//
		//----------------------------------------------
		
		private static function transform3DTo2DPathWithoutMatrix(cube:CubeVO):void
		{
			cube.frontSideSurface.location2D = transform3DTo2DPointWithoutMatrix(cube.frontSideSurface.location3D);
			cube.frontSideSurface.path2D = pathTo2DWithoutMatirx(cube.frontSideSurface.path3D, 0);
			
			cube.backSideSurface.location2D = transform3DTo2DPointWithoutMatrix(cube.backSideSurface.location3D, Math.PI / 4, .5);
			cube.backSideSurface.path2D = pathTo2DWithoutMatirx(cube.backSideSurface.path3D, 0);
			
			cube.leftSideSurface.location2D = transform3DTo2DPointWithoutMatrix(cube.leftSideSurface.location3D);
			cube.leftSideSurface.path2D = pathTo2DWithoutMatirx(cube.leftSideSurface.path3D, 0);
			
			cube.rightSideSurface.location2D = transform3DTo2DPointWithoutMatrix(cube.rightSideSurface.location3D);
			cube.rightSideSurface.path2D = pathTo2DWithoutMatirx(cube.rightSideSurface.path3D, 0);
			
			cube.topSideSurface.location2D = transform3DTo2DPointWithoutMatrix(cube.topSideSurface.location3D);
			cube.topSideSurface.path2D = pathTo2DWithoutMatirx(cube.topSideSurface.path3D, Math.PI / 2);
			
			cube.bottomSideSurface.location2D = transform3DTo2DPointWithoutMatrix(cube.bottomSideSurface.location3D);
			cube.bottomSideSurface.path2D = pathTo2DWithoutMatirx(cube.bottomSideSurface.path3D, Math.PI / 2);
		}
		
		
		/**
		 */		
		private static function pathTo2DWithoutMatirx(path3D:Vector.<Point3D>, rad:Number = 0):Vector.<Point2D>
		{
			var resultPath:Vector.<Point2D> = new Vector.<Point2D>();
			for each (var point3D:Point3D in path3D)
			{
				resultPath.push(transform3DTo2DPointWithoutMatrix(point3D, rad));
			}
			
			return resultPath;
		}
		
		private static function transform3DTo2DPointWithoutMatrix(point3D:Point3D, rad:Number = 0, r:Number = 1):Point2D
		{
			var resultPoint2D:Point2D = new Point2D();
			
			resultPoint2D.x = point3D.x + r * point3D.z * Math.cos(rad);			
			resultPoint2D.y = - point3D.y - r * point3D.z * Math.sin(rad);
			
			return resultPoint2D;
		}
		
		//--------------------------------------------------------
		//
		// 带轴侧效果的转换
		//
		//--------------------------------------------------------
		
		/**
		 * 将3D坐标及尺寸转换为2D.
		 */		
		private static function transform3DTo2DPath(cube:CubeVO):void
		{
			cube.frontSideSurface.location2D = transform3DTo2DPoint(cube.frontSideSurface.location3D);
			cube.frontSideSurface.path2D = pathTo2D(cube.frontSideSurface.path3D);
			
			cube.rightSideSurface.location2D = transform3DTo2DPoint(cube.rightSideSurface.location3D);
			cube.rightSideSurface.path2D = pathTo2D(cube.rightSideSurface.path3D);
			
			cube.topSideSurface.location2D = transform3DTo2DPoint(cube.topSideSurface.location3D);
			cube.topSideSurface.path2D = pathTo2D(cube.topSideSurface.path3D);
		}
		
		/**
		 */		
		private static function pathTo2D(path3D:Vector.<Point3D>):Vector.<Point2D>
		{
			var resultPath:Vector.<Point2D> = new Vector.<Point2D>();
			for each (var point3D:Point3D in path3D)
			{
				resultPath.push(transform3DTo2DPoint(point3D));
			}
			
			return resultPath;
		}
		
		/**
		 * @param point3D
		 * @return 
		 */		
		public static function transform3DTo2DPoint(point3D:Point3D):Point2D
		{
			var resultPoint2D:Point2D = new Point2D();
			
			resultPoint2D.x = point3D.x + point3D.z * Math.cos(Math.PI / 4) / 2;			
			resultPoint2D.y = - point3D.y - point3D.z * Math.sin(Math.PI / 4) / 2;
			
			return resultPoint2D;
		}
		
	}
}