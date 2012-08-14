package com.fiCharts.charts.chart2D.pie.series
{
	import com.fiCharts.charts.chart2D.core.series.SeriesItemUIBase;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	import flash.geom.Point;
	
	/**
	 */	
	public class PartPieUI extends SeriesItemUIBase
	{
		public function PartPieUI(dataItem:SeriesDataItemVO)
		{
			super(dataItem);
		}
		
		/**
		 */		
		public function get angleRadRange():Number
		{
			return pieDataItem.endRad - pieDataItem.startRad;
		}
		
		/**
		 */		
		public function get pieDataItem():PieDataItem
		{
			return dataItem as PieDataItem;
		}
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.beginFill(pieDataItem.color);
			this.graphics.moveTo(0, 0);
			
			for each (var point:Point in arcPoints)
			{
				this.graphics.lineTo(point.x, point.y);
			}
			
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
		}
		
		/**
		 */		
		private var _arcPoints:Vector.<Point>

		/**
		 */
		public function get arcPoints():Vector.<Point>
		{
			return _arcPoints;
		}

		/**
		 * @private
		 */
		public function set arcPoints(value:Vector.<Point>):void
		{
			_arcPoints = value;
		}

	}
}