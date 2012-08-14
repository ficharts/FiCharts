package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.charts.chart3D.baseClasses.LocationVOBase;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;

	public class CubeVO extends LocationVOBase
	{
		public function CubeVO()
		{
			super();
		}
		
		/**
		 */		
		private var _color:uint;

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
		}

		/**
		 */		
		private var _sizeX:Number;

		public function get xSize():Number
		{
			return _sizeX;
		}

		public function set xSize(value:Number):void
		{
			_sizeX = value;
		}

		/**
		 */		
		private var _sizeY:Number;

		public function get ySize():Number
		{
			return _sizeY;
		}

		public function set ySize(value:Number):void
		{
			_sizeY = value;
		}

		/**
		 */		
		private var _sizeZ:Number;

		public function get zSize():Number
		{
			return _sizeZ;
		}

		public function set zSize(value:Number):void
		{
			_sizeZ = value;
		}

		/**
		 */		
		private var _frontSurface:SurfaceVOBase;

		public function get frontSideSurface():SurfaceVOBase
		{
			return _frontSurface;
		}

		public function set frontSideSurface(value:SurfaceVOBase):void
		{
			_frontSurface = value;
		}
		
		private var _backSideSurface:SurfaceVOBase;

		public function get backSideSurface():SurfaceVOBase
		{
			return _backSideSurface;
		}

		public function set backSideSurface(value:SurfaceVOBase):void
		{
			_backSideSurface = value;
		}
		
		private var _leftSideSurface:SurfaceVOBase;

		public function get leftSideSurface():SurfaceVOBase
		{
			return _leftSideSurface;
		}

		public function set leftSideSurface(value:SurfaceVOBase):void
		{
			_leftSideSurface = value;
		}

		/**
		 */		
		private var _rightSideSurface:SurfaceVOBase;

		public function get rightSideSurface():SurfaceVOBase
		{
			return _rightSideSurface;
		}

		public function set rightSideSurface(value:SurfaceVOBase):void
		{
			_rightSideSurface = value;
		}

		/**
		 */		
		private var _topSizeSurface:SurfaceVOBase;

		public function get topSideSurface():SurfaceVOBase
		{
			return _topSizeSurface;
		}

		public function set topSideSurface(value:SurfaceVOBase):void
		{
			_topSizeSurface = value;
		}
		
		private var _bottomSideSurface:SurfaceVOBase

		public function get bottomSideSurface():SurfaceVOBase
		{
			return _bottomSideSurface;
		}

		public function set bottomSideSurface(value:SurfaceVOBase):void
		{
			_bottomSideSurface = value;
		}

			
	}
}