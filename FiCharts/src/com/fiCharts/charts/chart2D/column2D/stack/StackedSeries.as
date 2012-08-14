package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.encry.SeriesBase;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	/**
	 * 
	 * @author wallen
	 * 
	 */	
	public class StackedSeries extends SeriesBase
	{
		public function StackedSeries()
		{
			super();
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			
		}
		
		/**
		 */		
		override protected function get seriesDataItem():SeriesDataItemVO
		{
			return new StackedSeriesDataItem();
		}	
		
	}
}