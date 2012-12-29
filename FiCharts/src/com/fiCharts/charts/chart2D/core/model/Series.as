package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.charts.chart2D.column2D.ColumnSeries2D;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.chart2D.marker.MarkerSeries;
	import com.fiCharts.charts.common.ChartColorManager;
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
		public function get line():SB
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set line(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get area():SB
		{
			return null;
		}

		public function set area(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get bar():SB
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set bar(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get stackedBar():SB
		{
			return null;
		}

		public function set stackedBar(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get stackedPercentBar():SB
		{
			return null;
		}

		public function set stackedPercentBar(value:SB):void
		{
			_items.push(value);
		}

		/**
		 */		
		public function get column():SB
		{
			return null;
		}
		
		/**
		 */		
		public function set column(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */		
		public function get stackedColumn():SB
		{
			return null;
		}

		public function set stackedColumn(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */		
		public function get stackedPercentColumn():SB
		{
			return null;
		}

		public function set stackedPercentColumn(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 * 
		 */
		public function get bubble():SB
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set bubble(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get marker():SB
		{
			return null;
		}

		public function set marker(value:SB):void
		{
			_items.push(value);
		}

		/**
		 */		
		private var _items:Vector.<SB>;

		/**
		 */
		public function get items():Vector.<SB>
		{
			return _items;
		}
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			_items = new Vector.<SB>;
		}
		
		/**
		 * 在数据映射结束之后调用， 此时可以通知外部此对象已被创建；
		 */		
		public function propertiesUpdated(xml:* = null):void
		{
			
		}
		
		/**
		 * 对象已经被创建并且成为了父层的一个子对象 
		 */		
		public function created():void
		{
			items.reverse();
			
			var length:uint = _items.length;
			var index:uint = 0;
			var columnSereisIndex:uint = 0;
			var columnSeriesAmount:uint = 0;
			
			colorMananger = new ChartColorManager();
			for (var i:int = 0; i < length; i ++)
			{
				_items[i].seriesIndex = index;
				_items[i].seriesCount = length;
				
				// 按照序列的顺序指定序列颜色
				if (!_items[i].color)
					_items[i].color = colorMananger.chartColor.toString(16);
				
				if (_items[i] is ColumnSeries2D)
					columnSeriesAmount += 1;
				
				index ++;
			}
			
			for each (var series:SB in _items)
			{
				if (series is ColumnSeries2D)
				{
					(series as ColumnSeries2D).columnSeriesAmount = columnSeriesAmount;
					(series as ColumnSeries2D).columnSeriesIndex = columnSereisIndex;
					
					columnSereisIndex ++;
				}
			}
			
			changed = true;
			XMLVOLib.dispatchCreation(Series.SERIES_CREATED, items);
		}
		
		/**
		 * 图表的颜色生成管理， 按顺序生成不同的颜色；
		 */		
		public var colorMananger:ChartColorManager;
		
		/**
		 */		
		public var changed:Boolean = false;
		
		/**
		 * 序列总数
		 */		
		public function get length():uint
		{
			return items.length;
		}
	}
}