package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.shape.IShape;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	/**
	 * 数据节点的样式， 数据节点显示方式有多种形状，也可能由多个形状构成一个节点
	 */	
	public class DataRenderStyle extends Style
	{
		public function DataRenderStyle()
		{
			super();
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
		public var shapes:Vector.<IShape> = new Vector.<IShape>;
		
		/**
		 */		
		private var _states:States;

		/**
		 */
		public function get states():States
		{
			return _states;
		}

		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = value;
		}

	}
}