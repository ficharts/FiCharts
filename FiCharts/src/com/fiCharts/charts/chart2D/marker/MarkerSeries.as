package com.fiCharts.charts.chart2D.marker
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.DataRenderStyle;
	import com.fiCharts.charts.chart2D.encry.SeriesBase;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;

	/**
	 */	
	public class MarkerSeries extends SeriesBase
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
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.MARKER_SERIES), this);
		}
		/**
		 */		
		override public function created():void
		{
			stateControl = new StatesControl(this);
			chartColorManager = new ChartColorManager;
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
			
			for each (var item:SeriesDataItemVO in this.dataItemVOs)
				canvas.graphics.drawCircle(item.x, item.y, 10);// TODO
		}
		
		/**
		 * 更新数据节点的布局信息；
		 */		
		override protected function layoutDataItems():void
		{   
			var item:SeriesDataItemVO;
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
		override protected function initItemRender(itemRender:ItemRenderBace, item:SeriesDataItemVO):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			(itemRender as MarkerSeriesItemRender).edges = this.markerSeriesIndex + 3;
			
			itemRender.valueLabel = valueLabel;
			this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.markerRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		private var _markerRender:DataRenderStyle

		/**
		 */
		public function get markerRender():DataRenderStyle
		{
			return _markerRender;
		}

		/**
		 * @private
		 */
		public function set markerRender(value:DataRenderStyle):void
		{
			_markerRender = value;
		}
		
		/**
		 */		
		override protected function get itemRender():ItemRenderBace
		{
			return new MarkerSeriesItemRender;
		}
		
		/**
		 */		
		private var _markerSeriesIndex:uint = 0;

		/**
		 */
		public function get markerSeriesIndex():uint
		{
			return _markerSeriesIndex;
		}

		/**
		 * @private
		 */
		public function set markerSeriesIndex(value:uint):void
		{
			_markerSeriesIndex = value;
		}

	}
}