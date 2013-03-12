package com.fiCharts.charts.chart2D.column2D
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class SimpleColumnRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function SimpleColumnRender(series:ColumnSeries2D)
		{
			this.series = series;
			series.stateControl = new StatesControl(series, series.states);
			series.stateControl.enable = false;// 防止鼠标感应带来的重绘，重绘很耗性能
		}
		
		/**
		 */		
		private var series:ColumnSeries2D;
		
		/**
		 */		
		public function toClassicPattern():void
		{
			if (series.classicPattern)
				series.curRenderPattern = series.classicPattern;
			else
				series.curRenderPattern = series.classicPattern = new ClassicColumnRender(series);
			
			series.clearCanvas();
			
		}
		
		/**
		 */		
		public function toSimplePattern():void
		{
		}
		
		/**
		 */		
		public function renderScaledData():void
		{
			series.layoutDataItems(series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex);
			render();
		}
		
		/**
		 */		
		public function render():void
		{
			series.clearCanvas();
			series.applyDataFeature();
			
			var dataItem:ColumnDataPoint;
			
			var px:Number = 0;
			var py:Number = 0;
			var w:Number = 0;
			var h:Number = 0;
			
			for (var i:uint = series.dataOffsetter.minIndex; i <= series.dataOffsetter.maxIndex; i ++)
			{
				dataItem = series.dataItemVOs[i] as ColumnDataPoint;
				
				dataItem.width = series.horizontalAxis.unitSize;
				px = dataItem.x - dataItem.width / 2;
				
				dataItem.height = dataItem.y - series.baseLine;
				
				series.currState.tx = px;
				series.currState.width = dataItem.width;
				
				series.currState.ty = dataItem.y - series.baseLine;
				series.currState.height = - dataItem.height;
				
				StyleManager.drawRect(series.canvas, series.currState, dataItem);
				
			}
		}
	}
}