package com.fiCharts.charts.chart2D.area2D
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class SimpleAreaRender implements ISeriesRenderPattern
	{
		public function SimpleAreaRender(series:AreaSeries2D)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:AreaSeries2D;
		
		/**
		 */		
		public function toClassicPattern():void
		{
			if(series.classicPattern)
			{
				series.curRenderPattern = series.classicPattern;
			}
			else
			{
				series.curRenderPattern = new ClassicAreaRender(series);
			}
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
				
			series.clearCanvas();
			StyleManager.setFillStyle(series.canvas.graphics, series.style, series);
			StyleManager.setLineStyle(series.canvas.graphics, series.style.getBorder, series.style, series);
			
			series.renderSimleLine(series.canvas.graphics, 
				series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex);
			
			//绘制闭合区域以便填充
			var startPoint:SeriesDataItemVO = series.dataItemVOs[series.dataOffsetter.minIndex] as SeriesDataItemVO;
			var endPoint:SeriesDataItemVO = series.dataItemVOs[series.dataOffsetter.maxIndex] as SeriesDataItemVO;
			
			series.canvas.graphics.lineStyle(0, 0, 0);
			series.canvas.graphics.lineTo(endPoint.x, 0);
			series.canvas.graphics.lineTo(startPoint.x, 0);
			series.canvas.graphics.lineTo(startPoint.x, startPoint.y - series.baseLine);
			series.canvas.graphics.endFill();
		}
		
		/**
		 */		
		public function render():void
		{
			if (series.ifSizeChanged || series.ifDataChanged)
			{
				series.applyDataFeature();
				series.style = series.states.getNormal;
				
				series.states.tx = series.seriesWidth;
				series.states.width = series.seriesWidth;
				
				series.ifSizeChanged = series.ifDataChanged = false;
			}
		}
	}
}