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
		public static const SERIES_CREATED:String = 'seriesCreated';
		
		/**
		 */		
		public function Series()
		{
		}
		
		/**
		 */
		public function get pie():PieSeries
		{
			return null;
		}

		public function set pie(value:PieSeries):void
		{
			_items.push(value);
		}

		/**
		 */		
		public function beforeUpdateProperties(xml:*=null):void
		{
			_items = new Vector.<PieSeries>;
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
			XMLVOLib.dispatchCreation(Series.SERIES_CREATED, items);
		}
	}
}