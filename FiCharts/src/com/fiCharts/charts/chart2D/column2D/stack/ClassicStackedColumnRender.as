package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.column2D.Column2DUI;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.common.SeriesDataPoint;
	
	public class ClassicStackedColumnRender implements ISeriesRenderPattern
	{
		public function ClassicStackedColumnRender(series:StackedColumnSeries)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:StackedColumnSeries;
		
		/**
		 */		
		public function toClassicPattern():void
		{
		}
		
		/**
		 */		
		public function toSimplePattern():void
		{
			if (series.simplePattern)
				series.curRenderPattern = series.curRenderPattern;
			else
				series.curRenderPattern = series.simplePattern = new SimpleStackedColumnRender(series);
			
			series.clearCanvas();
			series.columnUIs.length = 0;
		}
		
		/**
		 */		
		public function renderScaledData():void
		{
			
		}
		
		/**
		 */		
		public function render():void
		{
			if (series.ifDataChanged || series.ifSizeChanged)
			{
				series.applyDataFeature();
				
				if (series.ifDataChanged)
				{
					series.createItemRenders();
					series.clearCanvas();
					
					var columnItemUI:Column2DUI;
					series.columnUIs = new Vector.<Column2DUI>;
					for each (var stack:StackedSeries in series.stacks)
					{
						for each (var itemDataVO:SeriesDataPoint in stack.dataItemVOs)
						{
							if (series.ifNullData(itemDataVO))
								continue;
							
							columnItemUI = new StackedColumnUI(itemDataVO);
							columnItemUI.states = series.states;//样式统一定义
							columnItemUI.metaData = itemDataVO.metaData;
							series.columnUIs.push(columnItemUI);
							series.canvas.addChild(columnItemUI);
						}
					}
					
				}
				
				series.layoutDataItems(0, series.maxDataItemIndex);
				
				// 渲染
				series.layoutAndRenderUIs();
				series.ifSizeChanged = series.ifDataChanged = false;
				
			}
			
		}
	}
}