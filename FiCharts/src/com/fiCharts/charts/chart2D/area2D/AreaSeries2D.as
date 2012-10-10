package com.fiCharts.charts.chart2D.area2D
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.line.LineSeries;
	import com.fiCharts.charts.chart2D.line.PartLineUI;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
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
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.AREA_SERIES), this);
		}
		
		/**
		 * Render line.
		 */
		override protected function renderChart():void
		{
			if (ifDataChanged)
			{
				while (canvas.numChildren)
					canvas.removeChildAt(0);
				
				var areaUI:PartLineUI;
				partUIs = new Vector.<PartLineUI>;
				for each (var itemDataVO:SeriesDataItemVO in dataItemVOs)
				{
					areaUI = new PartAreaUI(itemDataVO);
					areaUI.partUIRender = this;
					areaUI.states = this.states;
					areaUI.metaData = itemDataVO.metaData;
					canvas.addChild(areaUI);
					partUIs.push(areaUI);
				}
			}
				
			if (this.ifSizeChanged || this.ifDataChanged)
			{
				renderPartUIs();
				ifSizeChanged = ifDataChanged = false;
			}
		}
		
		/**
		 */		
		override public function render():void
		{
			
		}
		
		/**
		 */		
		override public function renderPartUI(canvas:Shape, style:Style, metaData:Object):void
		{
			canvas.graphics.clear();
			
			StyleManager.setFillStyle(canvas.graphics, style, metaData);
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, metaData);
			
			renderLine(canvas);
			
			//绘制闭合区域以便填充
			canvas.graphics.lineStyle(0, 0, 0);
			canvas.graphics.lineTo((dataItemVOs[dataItemVOs.length - 1] as SeriesDataItemVO).x, 0);
			canvas.graphics.lineTo((dataItemVOs[0] as SeriesDataItemVO).x, 0);
			canvas.graphics.lineTo((dataItemVOs[0] as SeriesDataItemVO).x, 
				(dataItemVOs[0] as SeriesDataItemVO).y - this.baseLine);
			
			canvas.graphics.endFill();
			
			if (style.cover && style.cover.border)
			{
				StyleManager.setLineStyle(canvas.graphics, style.cover.border, style, metaData);
				renderLine(canvas, style.cover.offset);
			}
			
			StyleManager.setEffects(canvas, style, metaData);
		}

	}
}