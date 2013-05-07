package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.SeriesDataPoint;
	
	/**
	 * 
	 * @author wallen
	 * 
	 */	
	public class StackedSeries extends SB
	{
		public function StackedSeries()
		{
			super();
		}
		
		/**
		 * 不添加数据缩放事件监听， 所有处理都在主堆积序列中完成， 这里仅处理数据的初始�
		 */
		override public function set horizontalAxis(v:AxisBase):void
		{
			_horizontalAxis = v;
			_horizontalAxis.direction = AxisBase.HORIZONTAL_AXIS;
			_horizontalAxis.metaData = this;
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			
		}
		
		/**
		 */		
		override protected function get seriesDataItem():SeriesDataPoint
		{
			return new StackedSeriesDataPoint();
		}	
		
	}
}