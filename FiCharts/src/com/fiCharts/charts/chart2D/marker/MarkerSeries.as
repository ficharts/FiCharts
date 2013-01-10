package com.fiCharts.charts.chart2D.marker
{
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class MarkerSeries extends SB
	{
		/**
		 * 散点图序列
		 */
		public function MarkerSeries()
		{
			super();
		}
		
		/**
		 */		
		override protected function get type():String
		{
			return "marker";
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.MARKER_SERIES, Model.SYSTEM), this);
		}
		/**
		 */		
		override public function created():void
		{
			chartColorManager = new ChartColors;
		}
		
		/**
		 */		
		override public function setPercent(value:Number):void
		{
			canvas.alpha = value;
		}
		
		/**
		 * Render PlotChart.
		 */
		override protected function renderChart():void
		{
			this.canvas.graphics.clear();	
			canvas.graphics.beginFill(0, 0);
			
			for each (var item:SeriesDataPoint in this.dataItemVOs)
				canvas.graphics.drawCircle(item.x, item.y, 10);// TODO
		}
		
		/**
		 * 更新数据节点的布局信息；
		 */		
		override protected function layoutDataItems():void
		{   
			var item:SeriesDataPoint;
			for (var i:uint = 0; i <= this.itemRenderMaxIndex; i ++)
			{	
				item = dataItemVOs[i];
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xValue);
				item.dataItemY = (verticalAxis.valueToY(item.yValue));
				item.offset = this.baseLine;
				item.y = item.dataItemY - this.baseLine;
			}
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = valueLabel;
			this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}

	}
}