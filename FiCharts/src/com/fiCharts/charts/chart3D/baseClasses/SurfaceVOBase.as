package com.fiCharts.charts.chart3D.baseClasses
{
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.Point2D;
	import com.fiCharts.utils.graphic.Point3D;

	/**
	 * @author wallen.
	 */	
	public class SurfaceVOBase extends LocationVOBase
	{
		public function SurfaceVOBase()
		{
		}
		
		/**
		 */		
		private var _fillColor:uint;

		public function get fillColor():uint
		{
			return _fillColor;
		}

		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		/**
		 */		
		private var _colorFillVO:GradientColorStyle = new GradientColorStyle();;

		public function get colorFillVO():GradientColorStyle
		{
			return _colorFillVO;
		}

		public function set colorFillVO(value:GradientColorStyle):void
		{
			_colorFillVO = value;
		}

		/**
		 */		
		public function generateColorEffect(isUp:int):void
		{
			
		}

		/**
		 */		
		private var _path3D:Vector.<Point3D> = new Vector.<Point3D>();

		public function get path3D():Vector.<Point3D>
		{
			return _path3D;
		}

		public function set path3D(value:Vector.<Point3D>):void
		{
			_path3D = value;
		}
		
		/**
		 */		
		private var _path2D:Vector.<Point2D> = new Vector.<Point2D>();

		public function get path2D():Vector.<Point2D>
		{
			return _path2D;
		}

		public function set path2D(value:Vector.<Point2D>):void
		{
			_path2D = value;
		}
		
		private var _lineColor:uint;
		
		public function get lineColor():uint
		{
			return _lineColor;
		}
		
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}
		
		
		private var _lineThikness:Number;
		
		public function get lineThikness():Number
		{
			return _lineThikness;
		}
		
		public function set lineThikness(value:Number):void
		{
			_lineThikness = value;
		}
	}
}