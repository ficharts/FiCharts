package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class SimpleLineRender implements ISeriesRenderPattern
	{
		public function SimpleLineRender(series:LineSeries)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:LineSeries;
		
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
				series.curRenderPattern = new ClassicLineRender(series);
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
			
			StyleManager.setLineStyle(series.canvas.graphics, series.style.getBorder, series.style, series);
			
			series.renderSimleLine(series.canvas.graphics, 
				series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex);
			
			
			/*if (series.style.cover && series.style.cover.border)
			{
				StyleManager.setLineStyle(series.canvas.graphics, series.style.cover.border, series.style, series);
				series.renderSimleLine(series.canvas.graphics, 
					series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex, series.style.cover.offset);
			}
		
			StyleManager.setEffects(series.canvas, series.style, series);*/
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