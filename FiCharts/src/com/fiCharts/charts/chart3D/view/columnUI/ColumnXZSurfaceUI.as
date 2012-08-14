package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.charts.chart3D.model.vo.cube.XYSurfaceVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.XZSurfaceVO;
	
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Transform;
	
	public class ColumnXZSurfaceUI extends ColumnSurfaceUIBase
	{
		public function ColumnXZSurfaceUI(surfaceVO:SurfaceVOBase)
		{
			super(surfaceVO);
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			var matrix:Matrix = new Matrix();
			matrix.c = - Math.tan(45 * Math.PI / 180);
			
			var transform:Transform = new Transform(surfaceUI);
			transform.matrix = matrix;
			surfaceUI.transform = transform;
			
			this.cacheAsBitmap = true;
		}
		
		/**
		 */		
		private function get topSurfaceVO():XZSurfaceVO
		{
			return this.surfaceVO as XZSurfaceVO;
		}
		
		/**
		 */		
		override public function renderWidthHeightPercent(value:Number):void
		{
			this.y = Math.round(surfaceVO.location2D.y * value);
		}
	}
}