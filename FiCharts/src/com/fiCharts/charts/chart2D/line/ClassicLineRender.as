package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	
	/**
	 */	
	public class ClassicLineRender implements ISeriesRenderPattern, IClassicPartRender
	{
		public function ClassicLineRender(series:LineSeries)
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
		}
		
		/**
		 * 经典模式切换到简单模式，移除不必要的对象； 
		 */		
		public function toSimplePattern():void
		{
			if (series.simplePattern)
			{
				series.curRenderPattern = series.simplePattern;
			}
			else
			{
				series.curRenderPattern = new SimpleLineRender(series);
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
					
					var linePartUI:PartLineUI;
					series.partUIs = new Vector.<PartLineUI>;
					for each (var itemDataVO:SeriesDataPoint in series.dataItemVOs)
					{
						linePartUI = new PartLineUI(itemDataVO);
						linePartUI.partUIRender = this;
						linePartUI.states = series.states;
						linePartUI.metaData = itemDataVO.metaData;
						series.canvas.addChild(linePartUI);
						series.partUIs.push(linePartUI);
					}
					
				}
				
				//更新尺寸信息
				series.layoutDataItems(0, series.maxDataItemIndex);
				series.states.tx = series.seriesWidth;
				series.states.width = series.seriesWidth;
				
				// 渲染
				series.renderPartUIs();
				series.ifSizeChanged = series.ifDataChanged = false;
			}
		}
		
		/**
		 * 每个节点渲染的是包括自身在内的临近几个节点
		 */		
		public function renderPartUI(canvas:Shape, style:Style, metaData:Object, renderIndex:uint):void
		{
			canvas.graphics.clear();
			
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, metaData);
			series.renderPartLine(canvas, 0, renderIndex);
			
			if (style.cover && style.cover.border)
			{
				StyleManager.setLineStyle(canvas.graphics, style.cover.border, style, metaData);
				series.renderPartLine(canvas, style.cover.offset, renderIndex);
			}
			
			StyleManager.setEffects(canvas, style, metaData);
		}
		
	}
}