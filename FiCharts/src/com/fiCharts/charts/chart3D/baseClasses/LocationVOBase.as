package com.fiCharts.charts.chart3D.baseClasses
{
	import com.fiCharts.utils.graphic.Point2D;
	import com.fiCharts.utils.graphic.Point3D;

	/**
	 * This object is in 3D space, and has 3D location with 2D location. 
	 * The 2D location is transformed from 3D location.
	 * @author wallen
	 */	
	public class LocationVOBase
	{
		public function LocationVOBase()
		{
		}
		
		/**
		 */		
		private var _location3D:Point3D = new Point3D();
		
		public function get location3D():Point3D
		{
			return _location3D;
		}
		
		public function set location3D(value:Point3D):void
		{
			_location3D = value;
		}
		
		/**
		 */		
		private var _location2D:Point2D;		
		
		public function get location2D():Point2D
		{
			return _location2D;
		}
		
		public function set location2D(value:Point2D):void
		{
			_location2D = value;
		}
	}
}