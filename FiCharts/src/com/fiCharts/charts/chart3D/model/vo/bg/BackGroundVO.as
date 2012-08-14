package com.fiCharts.charts.chart3D.model.vo.bg
{
	import com.fiCharts.charts.chart3D.baseClasses.LocationVOBase;
	import com.fiCharts.charts.chart3D.model.vo.cube.CubeVO;
	
	public class BackGroundVO extends LocationVOBase
	{
		public function BackGroundVO()
		{
			super();
		}
		
		/**
		 */		
		private var _bottomCube:CubeVO = new CubeVO();

		public function get bottomCube():CubeVO
		{
			return _bottomCube;
		}

		public function set bottomCube(value:CubeVO):void
		{
			_bottomCube = value;
		}
		
		/**
		 */		
		private var _backCube:CubeVO = new CubeVO();

		public function get backCube():CubeVO
		{
			return _backCube;
		}

		public function set backCube(value:CubeVO):void
		{
			_backCube = value;
		}
	}
}