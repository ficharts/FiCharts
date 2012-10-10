package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceUIBase;
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	
	import flash.display.Sprite;
	
	public class ColumnSurfaceUIBase extends SurfaceUIBase
	{
		public function ColumnSurfaceUIBase(surfaceVO:SurfaceVOBase)
		{
			super(surfaceVO);
		}
		
		/**
		 *
		 * 根据柱子的高度对柱面的尺寸和高度作出调整；
		 *  
		 * @param value
		 * 
		 */		
		public function renderWidthHeightPercent(value:Number):void
		{
			
		}
		
		/**
		 */		
		protected var shadow:Sprite;
	}
}