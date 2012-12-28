package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.shape.IShape;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	/**
	 * 数据节点的样式， 数据节点显示方式有多种形状，也可能由多个形状构成一个节点
	 */	
	public class DataRender 
	{
		public function DataRender()
		{
			super();
		}
		
		/**
		 */		
		public function set style(value:String):void
		{
			_style = value;
			
			var xml:Object = XMLVOMapper.getStyleXMLBy_ID(_style);
			XMLVOMapper.fuck(xml, this);
		}
		
		/**
		 */		
		public function get style():String
		{
			return _style;
		}
		
		/**
		 */		
		private var _style:String;
		
		
		/**
		 */		
		private var _enable:Boolean

		/**
		 */
		public function get enable():Object
		{
			return _enable;
		}

		/**
		 * @private
		 */
		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		public function render(canvas:Sprite, metadata:Object, radius:Number = NaN):void
		{
			for each (var shape:IShape in shapes)
			{
				if (isNaN(radius) == false)
					shape.style.radius = radius;
					
				shape.render(canvas, metadata);
			}
		}
		
		/**
		 */		
		public function toNormal():void
		{
			for each (var shape:IShape in shapes)
				shape.style = shape.states.getNormal;
		}
		
		/**
		 */		
		public function toHover():void
		{
			for each (var shape:IShape in shapes)
				shape.style = shape.states.getHover;
		}
		
		/**
		 */		
		public function toDown():void
		{
			for each (var shape:IShape in shapes)
			shape.style = shape.states.getDown;
		}
		
		/**
		 */		
		public function get circle():IShape
		{
			return null;
		}

		/**
		 */		
		public function set circle(value:IShape):void
		{
			shapes.push(value);
		}
		
		/**
		 */		
		private var shapes:Vector.<IShape> = new Vector.<IShape>;
		
		

	}
}