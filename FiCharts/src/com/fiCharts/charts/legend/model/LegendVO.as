package com.fiCharts.charts.legend.model
{
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	
	import flash.events.EventDispatcher;

	/**
	 */	
	public class LegendVO extends EventDispatcher
	{
		public function LegendVO()
		{
		}
		
		/**
		 * 原数据 
		 */		
		private var _mataData:EventDispatcher;

		public function get metaData():EventDispatcher
		{
			return _mataData;
		}

		public function set metaData(value:EventDispatcher):void
		{
			_mataData = value;
		}
		
		/**
		 */		
		private var _iconRender:DataRender;

		/**
		 */
		public function get iconRender():DataRender
		{
			return _iconRender;
		}

		/**
		 * @private
		 */
		public function set iconRender(value:DataRender):void
		{
			_iconRender = value;
		}
		
	}
}