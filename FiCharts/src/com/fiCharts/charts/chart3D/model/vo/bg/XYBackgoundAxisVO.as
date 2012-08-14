package com.fiCharts.charts.chart3D.model.vo.bg
{
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;

	public class XYBackgoundAxisVO extends XYSurfaceVO
	{
		public function XYBackgoundAxisVO()
		{
			super();
		}
		
		/**
		 */		
		private var _linePositions:Vector.<Number>;

		public function get linePositions():Vector.<Number>
		{
			return _linePositions;
		}

		public function set linePositions(value:Vector.<Number>):void
		{
			_linePositions = value;
		}

	}
}