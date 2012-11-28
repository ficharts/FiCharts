package com.fiCharts.charts.chart2D.core.series
{
	/**
	 *
	 * 控制序列中数据范围的偏移量
	 *  
	 * @author wallen
	 * 
	 */	
	public class DataIndexOffseter
	{
		public function DataIndexOffseter()
		{
		}
		
		/**
		 */		
		public function get length():uint
		{
			return this.maxIndex - this.minIndex + 1;
		}
		
		/**
		 *
		 * 根据数值范围得出其在总数据中的位置范围；
		 *  
		 * @param start
		 * @param end
		 * @param datafullRange
		 * 
		 */		
		public function getDataIndexRange(start:Number, end:Number, datafullRange:Array):void
		{
			
			var len:uint = datafullRange.length - 1;
			
			if (len <= 0)
			{
				trace(this + "数组无内容")
				return;
			}
			
			for (var i:uint = 0; i <= len; i ++)
			{
				if (datafullRange[i] <= start)
				{
					minIndex = i;
				}
				else if (datafullRange[i] >= end)
				{
					maxIndex = i;
					break;
				}
				else
				{
					continue;
				}
			}
		}
		
		/**
		 * 
		 */		
		public function offsetMin(index:uint, min:uint):uint
		{
			return ((index - dataIndexOffset) >= min ?  (index - dataIndexOffset) : min);
		}
		
		public function offsetMax(index:uint, max:uint):uint
		{
			return ((index + dataIndexOffset) <= max ? (index + dataIndexOffset) : max);
		}
		
		/**
		 * 在范围内偏移
		 */		
		public function offSet(min:uint, max:uint):void
		{
			minIndex = offsetMin(minIndex, min);
			maxIndex = offsetMax(maxIndex, max);
		}
		
		/**
		 */		
		public var maxIndex:uint = 0;
		
		/**
		 */		
		public var minIndex:uint = 0;
		
		/**
		 *  数据缩放时其实节点的位置偏移量，特别是趋势图和区域图需要临近几个节点才能渲染
		 * 
		 *  所以必须多取几个数据节点；
		 */		
		public var dataIndexOffset:uint = 1;
	}
}