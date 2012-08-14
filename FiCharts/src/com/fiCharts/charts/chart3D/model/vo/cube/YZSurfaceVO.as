package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 *  right side surface.
	 * 
	 * @author wallen
	 * 
	 */	
	public class YZSurfaceVO extends SurfaceVOBase
	{
		public function YZSurfaceVO()
		{
			super();
		}
		
		/**
		 */		
		override public function generateColorEffect(isUp:int) : void
		{
			colorFillVO.width = zSize / 2 * Math.cos(Math.PI / 4);
			colorFillVO.height = ySize;
			colorFillVO.tx = 0;
			colorFillVO.ty = - ySize * isUp;
			colorFillVO.fillAngle = Math.PI * 1.1 / 2;
			colorFillVO.fillColors = [StyleManager.transformColor(fillColor, 1.8, 1.8, 1.8), 
				StyleManager.transformColor(fillColor, .9, .9, .9)];
		}
		
		/**
		 */		
		private var _zSize:Number;

		public function get zSize():Number
		{
			return _zSize;
		}

		public function set zSize(value:Number):void
		{
			_zSize = value;
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