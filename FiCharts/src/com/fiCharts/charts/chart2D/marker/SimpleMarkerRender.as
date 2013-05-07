package com.fiCharts.charts.chart2D.marker
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class SimpleMarkerRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function SimpleMarkerRender(marker:MarkerSeries)
		{
			this.marker = marker;
			marker.stateControl = new StatesControl(marker, marker.states);
		}
		
		/**
		 */		
		private var marker:MarkerSeries;
		
		/**
		 */		
		public function toClassicPattern():void
		{ 
			if (marker.classicPattern)
				marker.curRenderPattern = marker.classicPattern;
			else
				marker.classicPattern = marker.curRenderPattern = new ClassicMarkerRender(marker);
			
			marker.clearCanvas();
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
			//marker.layoutDataItems(marker.dataOffsetter.minIndex, marker.dataOffsetter.maxIndex);
			render();
		}
		
		/**
		 */		
		public function render():void
		{
			if (marker.ifSizeChanged || marker.ifDataChanged)
			{
				marker.applyDataFeature();
				marker.ifSizeChanged = marker.ifDataChanged = false;
			}
			else
			{
				marker.clearCanvas();
				
				for (var i:uint = marker.dataOffsetter.minIndex; i < marker.dataOffsetter.maxIndex; i ++)
				{
					//marker.dataRender.render(marker.canvas, marker.dataItemVOs[i]);
				}
				
			}
		}
	}
}