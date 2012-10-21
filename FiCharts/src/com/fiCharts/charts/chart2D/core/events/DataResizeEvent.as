package com.fiCharts.charts.chart2D.core.events
{
	import flash.events.Event;
	
	public class DataResizeEvent extends Event
	{
		/**
		 *  根据数据位置缩放图表，用于均匀分部的字符型数据节点
		 */		
		public static const RESIZE_BY_INDEX:String = "resizeByIndex";
		
		/**
		 * 根据数据大小范围缩放图表， 用于数字类型的数据节点；
		 */		
		public static const RESIZE_BY_RANGE:String = "resizeByRange";
		
		/**
		 * 渲染数据范围内的数值标签
		 */		
		public static const RENDER_SIZED_VALUE_LABELS:String = 'renderSizedValueLabels';
			
			
		/**
		 */			
		public function DataResizeEvent(type:String, start:Number = 0, end:Number = 0)
		{
			super(type, false);
			
			this.start = start;
			this.end = end;
		}
		
		/**
		 */		
		public var start:Number = 0;
		
		/**
		 */		
		public var end:Number = 0;
		
		/**
		 */		
		public var sizedItemRenders:Array;
	}
}