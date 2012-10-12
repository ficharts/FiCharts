package com.fiCharts.charts.chart2D.column2D
{
	import com.fiCharts.charts.chart2D.core.columnRender.ColumnRender;
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.series.SeriesItemUIBase;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.GradientColorStyle;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * @author wallen
	 */	
	public class Column2DUI extends SeriesItemUIBase 
	{
		public function Column2DUI(dataItem:SeriesDataItemVO)
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
		private var columnRender:ColumnRender;
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.clear();
			
			style.tx = 0;
			style.width = this.columnWidth;
			
			style.ty = columnHeight;
			style.height = - columnHeight;
				
			StyleManager.drawRect(this, style, metaData);
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