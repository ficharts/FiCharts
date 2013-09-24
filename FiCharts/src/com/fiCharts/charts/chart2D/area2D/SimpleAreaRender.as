package com.fiCharts.charts.chart2D.area2D
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class SimpleAreaRender implements ISeriesRenderPattern
	{
		public function SimpleAreaRender(series:AreaSeries2D)
		{
			this.series = series;
			
			series.stateControl = new StatesControl(series, series.states);
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
			render();	
		}
		
		/**
		 */		
		public function render():void
		{
			if (series.ifSizeChanged || series.ifDataChanged)
			{
				series.applyDataFeature();
				
				series.states.width = series.seriesWidth;
				series.states.height = series.seriesHeight;
				
				series.ifSizeChanged = series.ifDataChanged = false;
			}
			else
			{
				series.clearCanvas();
				StyleManager.setFillStyle(series.canvas.graphics, series.currState, series);
				StyleManager.setLineStyle(series.canvas.graphics, series.currState.getBorder, series.currState, series);
				
				series.renderSimleLine(series.canvas.graphics, 
					series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex);
				
				//绘制闭合区域以便填充
				var startPoint:SeriesDataPoint = series.dataItemVOsForRender[series.dataOffsetter.minIndex] as SeriesDataPoint;
				var endPoint:SeriesDataPoint = series.dataItemVOsForRender[series.dataOffsetter.maxIndex] as SeriesDataPoint;
				
				series.canvas.graphics.lineStyle(0, 0, 0);
				series.canvas.graphics.lineTo(endPoint.x, - series.baseLine);
				series.canvas.graphics.lineTo(startPoint.x, - series.baseLine);
				series.canvas.graphics.lineTo(startPoint.x, startPoint.y - series.baseLine);
				series.canvas.graphics.endFill();
				
				if (series.currState.cover && series.currState.cover.border)
				{
					StyleManager.setLineStyle(series.canvas.graphics, series.currState.cover.border, series.currState, series);
					series.renderSimleLine(series.canvas.graphics, 
						series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex, series.currState.cover.offset);
				}
				
				StyleManager.setEffects(series.canvas, series.currState, series);
			}
		}
	}
}