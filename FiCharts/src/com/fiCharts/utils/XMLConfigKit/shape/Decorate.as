package com.fiCharts.utils.XMLConfigKit.shape
{
	public class Decorate
	{
		/**
		 */		
		public function Decorate(shapeGroup:IShapeGroup)
		{
			this.shapeGroup = shapeGroup;
		}
		
		/**
		 */		
		public function fresh():void
		{
			_circle = _rect = _diamond = null;
		}
		
		/**
		 */		
		private var shapeGroup:IShapeGroup;
		
		/**
		 */		
		public function get circle():IShape
		{
			return _circle;
		}
		
		/**
		 */		
		public function set circle(value:IShape):void
		{
			_circle = value;
			
			shapeGroup.shapes.push(value);
		}
		
		/**
		 */		
		private var _circle:IShape;
		
		/**
		 */
		public function get rect():IShape
		{
			return _rect;
		}
		
		/**
		 */		
		public function set rect(value:IShape):void
		{
			_rect = value;
			
			shapeGroup.shapes.push(value);
		}
		
		/**
		 */		
		private var _rect:IShape;
		
		/**
		 */
		public function get diamond():IShape
		{
			return _diamond;
		}
		
		/**
		 */		
		public function set diamond(value:IShape):void
		{
			_diamond = value;
			
			shapeGroup.shapes.push(value);
		}
		
		/**
		 */		
		private var _diamond:IShape;
		
	}
}