package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;
	
	import flash.display.Sprite;
	
	public class ColumnXYSurfaceUI extends ColumnSurfaceUIBase
	{
		public function ColumnXYSurfaceUI(surfaceVO:SurfaceVOBase)
		{
			super(surfaceVO);
		}
		
		/**
		 */		
		protected function get frontSurfaceVO():XYSurfaceVO
		{
			return this.surfaceVO as XYSurfaceVO;
		}
		 
		/**
		 */		
		override public function renderWidthHeightPercent(value:Number):void
		{
			this.height = Math.round(frontSurfaceVO.ySize * value);
		}
	}
}