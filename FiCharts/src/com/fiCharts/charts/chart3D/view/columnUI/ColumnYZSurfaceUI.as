package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.charts.chart3D.model.vo.cube.YZSurfaceVO;
	
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	public class ColumnYZSurfaceUI extends ColumnSurfaceUIBase
	{
		public function ColumnYZSurfaceUI(surfaceVO:SurfaceVOBase)
		{
			super(surfaceVO);
		}
		
		override public function render():void
		{
			super.render();
			
			var matrix:Matrix = new Matrix();
			matrix.b = - Math.tan(45 * Math.PI / 180);
			
			var transform:Transform = new Transform(surfaceUI);
			transform.matrix = matrix;
			surfaceUI.transform = transform;
		}
		
		/**
		 */		
		protected function get sideSurfaceVO():YZSurfaceVO
		{
			return this.surfaceVO as YZSurfaceVO;
		}
		
		/**
		 */		
		override public function renderWidthHeightPercent(value:Number):void
		{
			surfaceUI.height = Math.round(sideSurfaceVO.ySize * value) + 
				sideSurfaceVO.zSize * Math.sin(Math.PI / 4) * value;
				
		}
	}
}