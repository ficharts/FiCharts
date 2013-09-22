package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;

	/**
	 * 
	 * 数据缩放模式下跟随鼠标和数据点移动的
     * 
	 * 数据线
	 * 
	 */	
	public class DataLine
	{
		/**
		 */		
		public function DataLine()
		{
		}
		
		/**
		 */		
		private var _enable:Object = true;

		public function get enable():Object
		{
			return _enable;
		}

		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
		}

		/**
		 */		
		public var border:BorderLine;
	}
}