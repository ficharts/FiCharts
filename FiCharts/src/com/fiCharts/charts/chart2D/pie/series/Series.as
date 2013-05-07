package com.fiCharts.charts.chart2D.pie.series
{
	import com.fiCharts.utils.XMLConfigKit.IEditableObject;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	
	/**
	 */	
	public class Series implements IEditableObject
	{
		/**
		 */		
		public static const PIE_SERIES_CREATED:String = 'pieSeriesCreated';
		
		/**
		 */		
		public function Series()
		{
		}
		
		/**
		 */
		public function get pie():PieSeries
		{
			return _pie;
		}

		/**
		 */		
		public function set pie(value:PieSeries):void
		{
			_pie = value;
			
			_items[0] = value;
		}
		
		/**
		 */		
		public function ifHasPie():Boolean
		{
			if (_pie)
				return true;
			
			return false;
		}
		
		/**
		 */		
		private var _pie:PieSeries;

		/**
		 */		
		public function beforeUpdateProperties(xml:*=null):void
		{
			_items = new Vector.<PieSeries>;
			_items.length = 1;
		}
		
		/**
		 * 序列总数
		 */		
		public function get length():uint
		{
			return items.length;
		}
		
		/**
		 */		
		private var _items:Vector.<PieSeries>;
		
		/**
		 */
		public function get items():Vector.<PieSeries>
		{
			return _items;
		}
		
		/**
		 */		
		public function created():void
		{
			XMLVOLib.dispatchCreation(Series.PIE_SERIES_CREATED, items);
		}
	}
}