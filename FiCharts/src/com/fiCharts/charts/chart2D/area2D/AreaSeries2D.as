package com.fiCharts.charts.chart2D.area2D
{
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.chart2D.line.LineSeries;
	import com.fiCharts.charts.chart2D.line.PartLineUI;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;

	/**
	 * 
	 * 区域图序列
	 * 
	 */	
	public class AreaSeries2D extends LineSeries implements IDirectionSeries
	{
		/**
		 */		
		public function AreaSeries2D()
		{
			super();
		}
		
		/**
		 */		
		override protected function getClassicPattern():ISeriesRenderPattern
		{
			return new ClassicAreaRender(this);
		}
		
		/**
		 */		
		override protected function getSimplePattern():ISeriesRenderPattern
		{
			return new SimpleAreaRender(this);
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.AREA_SERIES), this);
		}
		
		/**
		 * Render line.
		 */
		override protected function draw():void
		{
		}
		
		/**
		 * 
		 * @param startIndex
		 * @param endIndex
		 * 
		 */		
		protected function renderWholeLine(startIndex:uint, endIndex:uint):void
		{
			canvas.graphics.clear();
			
			StyleManager.setFillStyle(canvas.graphics, style, this);
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, this);
			this.renderSimleLine(canvas.graphics, startIndex, endIndex, 0);
			
			
			//绘制闭合区域以便填充
			canvas.graphics.lineStyle(0, 0, 0);
			canvas.graphics.lineTo((dataItemVOs[endIndex] as SeriesDataItemVO).x, 0);
			canvas.graphics.lineTo((dataItemVOs[startIndex] as SeriesDataItemVO).x, 0);
			canvas.graphics.lineTo((dataItemVOs[startIndex] as SeriesDataItemVO).x, 
				(dataItemVOs[startIndex] as SeriesDataItemVO).y - this.baseLine);
			
			canvas.graphics.endFill();
		}
		
	}
}