package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	public class TickMarkStyle extends BorderLine
	{
		public function TickMarkStyle()
		{
			super();
		}
		
		/**
		 * 是否显示坐标刻度
		 */		
		private var _enable:Object = true;

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
		private var _size:uint = 5;

		/**
		 * 刻度的长度 
		 */
		public function get size():uint
		{
			return _size;
		}

		/**
		 * @private
		 */
		public function set size(value:uint):void
		{
			_size = value;
		}

	}
}