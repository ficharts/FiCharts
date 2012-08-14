package com.fiCharts.charts.chart3D.model.vo.cube
{
	import com.fiCharts.charts.chart3D.baseClasses.SurfaceVOBase;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 *  Top surface
	 * 
	 * @author wallen
	 * 
	 */	
	public class XZSurfaceVO extends SurfaceVOBase
	{
		public function XZSurfaceVO()
		{
			super();
		}
		
		/**
		 */		
		override public function generateColorEffect(isUp:int) : void
		{
			colorFillVO.width = xSize;
			colorFillVO.height = zSize / 1.8 * Math.cos(Math.PI / 4);
			colorFillVO.tx = 0;
			colorFillVO.ty = - zSize * Math.cos(Math.PI / 4) / 2;
			colorFillVO.fillAngle = Math.PI * 5 / 8 * isUp;
			colorFillVO.fillColors = [StyleManager.transformColor(fillColor, 1.7, 1.7, 1.7), fillColor];
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
		private var _zSize:Number;

		public function get zSize():Number
		{
			return _zSize;
		}

		public function set zSize(value:Number):void
		{
			_zSize = value;
		}

	}
}