package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.shape.Decorate;
	import com.fiCharts.utils.XMLConfigKit.shape.IShape;
	import com.fiCharts.utils.XMLConfigKit.shape.IShapeGroup;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFreshElement;
	
	import flash.display.Sprite;
	
	/**
	 * 数据节点的样式， 数据节点显示方式有多种形状，也可能由多个形状构成一个节点
	 */	
	public class DataRender implements IFreshElement, IShapeGroup
	{
		public function DataRender()
		{
			super();
			
			_decorate = new Decorate(this);
		}
		
		/**
		 */			
		private var _decorate:Decorate;

		/**
		 */
		public function get decorate():Decorate
		{
			return _decorate;
		}

		/**
		 * @private
		 */
		public function set decorate(value:Decorate):void
		{
			_decorate = value;
		}

		/**
		 */		
		public function fresh():void
		{
			_circle = _rect = _diamond = null;
			_decorate.fresh();
			
			shapes.length = 0;
		}
		
		/**
		 * 因数据节点构成存在多元化，每次重新设置样式时需重置整个对象
		 */		
		public function set style(value:String):void
		{
			if(_style != value)
			{
				_style = value;
				
				fresh();
				
				var xml:Object = XMLVOMapper.getStyleXMLBy_ID(_style);
				
				if (xml)
					XMLVOMapper.fuck(xml, this);
			}
			
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
		private var _enable:Boolean = true;

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
			return _circle;
		}

		/**
		 */		
		public function set circle(value:IShape):void
		{
			_circle = value;
			
			shapes.push(value);
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
			
			shapes.push(value);
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
			
			shapes.push(value);
		}
		
		/**
		 */		
		private var _diamond:IShape;

		/**
		 */		
		private var _shapes:Vector.<IShape> = new Vector.<IShape>;

		/**
		 */
		public function get shapes():Vector.<IShape>
		{
			return _shapes;
		}

		/**
		 * @private
		 */
		public function set shapes(value:Vector.<IShape>):void
		{
			_shapes = value;
		}


	}
}