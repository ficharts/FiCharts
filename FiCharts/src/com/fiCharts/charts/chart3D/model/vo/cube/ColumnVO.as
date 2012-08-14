package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.charts.chart3D.baseClasses.IItemRenderVO;
	import com.fiCharts.charts.common.SeriesDataItemVO;

	public class ColumnVO extends CubeVO implements IItemRenderVO
	{
		public static const COLUMN_UP:String = "columnUp";
		public static const LOLUMN_DOWN:String = "columnDown";
		
		/**
		 */		
		public function ColumnVO()
		{
			super();
		}
		
		/**
		 */		
		private var _itemVO:SeriesDataItemVO
		
		public function get itemVO():com.fiCharts.charts.common.SeriesDataItemVO
		{
			return _itemVO;
		}
		
		public function set itemVO(value:SeriesDataItemVO):void
		{
			_itemVO = value;
		}
		
		private var _direction:String;

		/**
		 */
		public function get direction():String
		{
			return _direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			_direction = value;
		}

	}
}