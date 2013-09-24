package com.fiCharts.charts.chart2D.core.events
{
	import flash.events.Event;
	
	/**
	 */	
	public class DataResizeEvent extends Event
	{
		/**
		 * 数据滚动时需隐藏tips 
		 */		
		public static const HIDE_DATA_RENDER:String = "hideTips";
		
		/**
		 * 是否显示数据节点，只有当鼠标位于图表绘制区域时，数据节点才会被显示出来，
		 * 
		 * 否则只是更新节点数据
		 */		
		public static const IF_SHOW_DATA_RENDER:String = "hideTips";
		
		/**
		 * 根据数据计算出toolips节点 
		 */		
		public static const UPDATE_TIPS_BY_DATA:String = "updateTooltipsByData"
			
		/**
		 * 根据节点位置计算出tooltips节点
		 */			
		public static const UPDATE_TIPS_BY_INDEX:String = "updateTipsByIndex";
		
		/**
		 *  根据数据位置缩放图表，用于均匀分部的字符型数据节点
		 */		
		public static const GET_SERIES_DATA_INDEX_BY_INDEXS:String = "getSeriesDataIndexByIndexs";
		
		/**
		 * 根据数据大小范围划定序列数据节点的位置范围，为序列和坐标轴（Y轴）渲染做好准备
		 */		
		public static const GET_SERIES_DATA_INDEX_RANGE_BY_DATA:String = "getSeriesDataIndexRangeByData";
		
		/**
		 * 渲染数据缩放了的序列 
		 */		
		public static const RENDER_DATA_RESIZED_SERIES:String = "renderDataResizedSeries";
		
		/**
		 * 渲染坐标轴
		 */			
		public static const UPDATE_Y_AXIS_DATA_RANGE:String = "updateYAxisDataRange";
		
		/**
		 *  坐标轴是滚动的基准，驱动背景网格和序列截图的位置移动
		 */		
		public static const RATE_SERIES_DATA_ITEMS:String = "rateSeriesDataItems";
			
			
			
		/**
		 */			
		public function DataResizeEvent(type:String, start:Number = 0, end:Number = 0, step:uint = 1)
		{
			super(type, true);
			
			this.start = start;
			this.end = end;
			this.step = step;
		}
		
		/**
		 * field=坐标轴时，为节点x轴的坐标值
		 */		
		public var label:String;
		
		/**
		 * 线性轴中表示坐标轴鼠标位置的值
		 */		
		public var data:Number = 0;
		
		/**
		 */		
		public var step:uint = 0;
		
		/**
		 */		
		public var start:Number = 0;
		
		/**
		 */		
		public var end:Number = 0;
		
	}
}