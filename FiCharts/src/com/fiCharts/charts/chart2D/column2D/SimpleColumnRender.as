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
			if (series.ifSizeChanged || series.ifDataChanged)
			{
				series.applyDataFeature();
				series.ifSizeChanged = series.ifDataChanged = false;
			}
			else
			{
				series.clearCanvas();
				
				var dataItem:ColumnDataPoint;
				
				var px:Number = 0;
				var py:Number = 0;
				var w:Number = 0;
				var h:Number = 0;
				
				//柱体的间距, 防止柱子连到一起不好看
				var gutter:Number = 1;
				
				StyleManager.setShapeStyle(series.currState, series.canvas.graphics, series);
				for (var i:uint = series.dataOffsetter.minIndex; i <= series.dataOffsetter.maxIndex; i ++)
				{
					dataItem = series.dataItemVOsForRender[i] as ColumnDataPoint;
					
					//给个间距好看一点
					gutter = series.horizontalAxis.unitSize * 0.05;
					if (gutter > 5)
						gutter = 5;
					else if (gutter < 1)
						gutter = 1;
					
					w = series.horizontalAxis.unitSize - gutter;
					
					
					if (w > series.maxItemSize)
						w = series.maxItemSize;
					
					h = series.baseLine - dataItem.y;
					
					px = dataItem.x - w / 2;
					py = - h;
					
					series.currState.tx = px;
					series.currState.ty = py;
					
					series.currState.width = w
					series.currState.height = h;
					
					series.canvas.graphics.drawRoundRect(px, py, w, h, series.currState.radius, series.currState.radius);
				}
				
				series.canvas.graphics.endFill();
			}
			
		}
	}
}