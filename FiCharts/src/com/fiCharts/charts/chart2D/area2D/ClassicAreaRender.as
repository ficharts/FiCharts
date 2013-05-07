package com.fiCharts.charts.chart2D.area2D
{
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.chart2D.line.IClassicPartRender;
	import com.fiCharts.charts.chart2D.line.PartLineUI;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	
	/**
	 */	
	public class ClassicAreaRender implements ISeriesRenderPattern, IClassicPartRender
	{
		public function ClassicAreaRender(series:AreaSeries2D)
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
		}
		
		/**
		 */		
		public function toSimplePattern():void
		{
			if (series.simplePattern)
			{
				series.curRenderPattern = series.simplePattern;
			}
			else
			{
				series.curRenderPattern = new SimpleAreaRender(series);
			}
			
			series.clearCanvas();
			series.partUIs.length = 0;
			series.partUIs = null;
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
				
				//创建新数据点
				if (series.ifDataChanged)
				{
					series.initData();
					series.createItemRenders();
					series.clearCanvas();
					
					var linePartUI:PartAreaUI;
					series.partUIs = new Vector.<PartLineUI>;
					for each (var itemDataVO:SeriesDataPoint in series.dataItemVOs)
					{
						linePartUI = new PartAreaUI(itemDataVO);
						linePartUI.partUIRender = this;
						linePartUI.states = series.states;
						linePartUI.metaData = itemDataVO.metaData;
						series.canvas.addChild(linePartUI);
						series.partUIs.push(linePartUI);
					}
				}
				
				//更新尺寸信息
				series.layoutDataItems(0, series.maxDataItemIndex);
				
				// 渲染
				series.renderPartUIs();
				series.ifSizeChanged = series.ifDataChanged = false;
			}
		}
		
		/**
		 */		
		public function renderPartUI(canvas:Shape, style:Style, metaData:Object, renderIndex:uint):void
		{
			var startIndex:uint, endIndex:uint;
			
			startIndex = series.dataOffsetter.offsetMin(renderIndex, 0);
			endIndex = series.dataOffsetter.offsetMax(renderIndex, series.maxDataItemIndex);
			
			canvas.graphics.clear();
			StyleManager.setFillStyle(canvas.graphics, style, metaData);
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, metaData);
			series.renderPartLine(canvas, 0, renderIndex);
			
			// 绘制闭合线，以形成曲面
			var startPoint:SeriesDataPoint = series.dataItemVOs[startIndex] as SeriesDataPoint;
			var endPoint:SeriesDataPoint = series.dataItemVOs[endIndex] as SeriesDataPoint;
			
			canvas.graphics.lineStyle(0, 0, 0);
			canvas.graphics.lineTo(endPoint.x, 0);
			canvas.graphics.lineTo(startPoint.x, 0);
			canvas.graphics.lineTo(startPoint.x, startPoint.y - series.baseLine);
			canvas.graphics.endFill();
			
			if (style.cover && style.cover.border)
			{
				StyleManager.setLineStyle(canvas.graphics, style.cover.border, style, metaData);
				series.renderPartLine(canvas, style.cover.offset, renderIndex);
			}
			
			StyleManager.setEffects(canvas, style, metaData);
		}
	}
}