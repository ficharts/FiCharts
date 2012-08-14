package com.fiCharts.charts.chart3D.model.vo.bg
{
	import com.fiCharts.charts.chart3D.model.vo.cube.YZSurfaceVO;

	public class YZBackgroundAixsVO extends YZSurfaceVO
	{
		public function YZBackgroundAixsVO()
		{
		}
		
		private var _outterPositions:Vector.<Number>;

		/**
		 */
		public function get linePositions():Vector.<Number>
		{
			return _outterPositions;
		}

		/**
		 * @private
		 */
		public function set linePositions(value:Vector.<Number>):void
		{
			_outterPositions = value;
		}

		private var _offSet:Number;

		/**
		 *  尺寸偏移量
		 */
		public function get offSet():Number
		{
			return _offSet;
		}

		/**
		 * @private
		 */
		public function set offSet(value:Number):void
		{
			_offSet = value;
		}


	}
}