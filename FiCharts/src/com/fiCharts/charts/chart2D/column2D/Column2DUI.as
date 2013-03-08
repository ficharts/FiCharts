package com.fiCharts.charts.chart2D.column2D
{
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.series.SeriesItemUIBase;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 * @author wallen
	 */	
	public class Column2DUI extends SeriesItemUIBase 
	{
		public function Column2DUI(dataItem:SeriesDataPoint)
		{
			super(dataItem);
		}
		
		/**
		 */		
		override public function downHandler():void
		{
			this.y = 1;
			
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_CLICKED);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		override public function hoverHandler():void
		{
			super.hoverHandler();
			
			y = 0;
		}
		
		/**
		 */		
		override public function normalHandler():void
		{
			super.normalHandler();
			
			y = 0;
		}
		
		/**
		 */		
		public function resize():void
		{
			this.width = columnWidth;
			this.height = Math.abs(columnHeight);
		}
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.clear();
			
			currState.tx = 0;
			currState.width = this.columnWidth;
			
			currState.ty = columnHeight;
			currState.height = - columnHeight;
				
			StyleManager.drawRect(this, currState, metaData);
		}
		
		/**
		 */		
		private var _columnWidth:int;

		/**
		 */
		public function get columnWidth():int
		{
			return _columnWidth;
		}

		/**
		 * @private
		 */
		public function set columnWidth(value:int):void
		{
			_columnWidth = value;
		}
		
		private var _columnHeight:int;

		/**
		 */
		public function get columnHeight():int
		{
			return _columnHeight;
		}

		/**
		 * @private
		 */
		public function set columnHeight(value:int):void
		{
			_columnHeight = value;
		}

	}
}