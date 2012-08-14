package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 * Front side surface.
	 * 
	 * @author wallen
	 * 
	 */	
	public class XYSurfaceVO extends SurfaceVOBase
	{
		public function XYSurfaceVO()
		{
			super();
		}
		
		/**
		 */		
		override public function generateColorEffect(isUp:int) : void
		{
			colorFillVO.width = xSize;
			colorFillVO.height = ySize;
			colorFillVO.tx = 0;
			
			if (isUp == 1)
				colorFillVO.ty = - ySize;
			else
				colorFillVO.ty = 0;
			
			colorFillVO.fillAngle = Math.PI * 1 / 2;
			
			colorFillVO.fillColors = [StyleManager.transformColor(fillColor, 1.4, 1.4, 1.4), 
				StyleManager.transformColor(fillColor, .9, .9, .9)];
		}
		
		/**
		 */		
		private var _xSize:Number;

		public function get xSize():Number
		{
			return _xSize;
		}

		public function set xSize(value:Number):void
		{
			_xSize = value;
		}

		/**
		 */		
		private var _ySize:Number;

		public function get ySize():Number
		{
			return _ySize;
		}

		public function set ySize(value:Number):void
		{
			_ySize = value;
		}

	}
}