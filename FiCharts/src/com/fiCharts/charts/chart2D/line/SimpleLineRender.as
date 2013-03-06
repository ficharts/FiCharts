package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class SimpleLineRender implements ISeriesRenderPattern
	{
		public function SimpleLineRender(series:LineSeries)
		{
			this.series = series;
			
			//series.stateControl = new StatesControl(series);
			//series.stateControl.setDefault();
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
			render();
		}
		
		/**
		 */		
		public function render():void
		{
			if (series.ifSizeChanged || series.ifDataChanged)
			{
				series.applyDataFeature();
				
				//series.states.width = series.seriesWidth;
				//series.states.height = series.seriesHeight;
				
				series.ifSizeChanged = series.ifDataChanged = false;
			}
			else
			{
				series.clearCanvas();
				
				/*StyleManager.setLineStyle(series.canvas.graphics, series.style.getBorder, series.style, series);
				
				series.renderSimleLine(series.canvas.graphics, 
					series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex);
				
				if (series.style.cover && series.style.cover.border)
				{
					StyleManager.setLineStyle(series.canvas.graphics, series.style.cover.border, series.style, series);
					series.renderSimleLine(series.canvas.graphics, 
					series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex, series.style.cover.offset);
				}
				
				StyleManager.setEffects(series.canvas, series.style, series);*/
			}
		}
	}
}