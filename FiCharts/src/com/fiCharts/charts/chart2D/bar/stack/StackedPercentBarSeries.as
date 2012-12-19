package com.fiCharts.charts.chart2D.bar.stack
{
	import com.fiCharts.charts.chart2D.column2D.stack.StackedSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedSeriesDataItem;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.encry.CP;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;

	public class StackedPercentBarSeries extends StackedBarSeries
	{
		public function StackedPercentBarSeries()
		{
			super();
			
			//this.valueLabel = '${zLabel}';
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:ItemRenderBace, item:SeriesDataItemVO):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.zLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = this.innerValueLabel;
			this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.STACKED_BAR_SERIES), this);
			
			this.stacks = new Vector.<StackedSeries>;
		}
		
		/**
		 */		
		override public function configed(colorMananger:ChartColorManager):void
		{
			super.configed(colorMananger);
			
			(this.horizontalAxis as LinearAxis).ifExpend = false;
			(this.horizontalAxis as LinearAxis).maximum = 100;
			
			//设置Y轴和数值标签的单位设置
			verticalAxis.dataFormatter.xSuffix = '%';
			verticalAxis.dataFormatter.zSuffix = '%';
		}
		
		/**
		 */		
		override protected function get itemRender():ItemRenderBace
		{
			return new StackedPercentBarItemRender(false);
		}
		
		/**
		 */			
		override protected function initData():void
		{
			var xValue:Number, yValue:Object, positiveValue:Number, fullValue:Number, percent:Number;
			var length:uint = dataProvider.children().length();
			var stack:StackedSeries;
			var seriesDataItem:StackedSeriesDataItem;
			
			dataItemVOs = new Vector.<SeriesDataItemVO>
			horizontalValues = new Vector.<Object>;
			verticalValues = new Vector.<Object>;
			fullDataItems = new Vector.<SeriesDataItemVO>;
			
			// 将子序列的数据节点合并到一起；
			for each (stack in stacks)
			{
				stack.dataProvider = this.dataProvider;
				dataItemVOs = dataItemVOs.concat(stack.dataItemVOs);
			}
			
			// 将子序列的数值叠加， 因坐标轴的数值显示的是总量；
			for (var i:uint = 0; i < length; i++)
			{
				fullValue = 0;
				for each (stack in stacks) // 求和
				{
					seriesDataItem = stack.dataItemVOs[i] as StackedSeriesDataItem;
					xValue = Number(seriesDataItem.xValue);
					yValue = seriesDataItem.yValue;
					fullValue += xValue;
				}
				
				positiveValue = percent = 0;
				for each (stack in stacks)
				{
					seriesDataItem = stack.dataItemVOs[i] as StackedSeriesDataItem;
					
					xValue = Number(seriesDataItem.xValue);
					seriesDataItem.startValue = positiveValue / fullValue * 100;
					positiveValue += xValue;
					seriesDataItem.endValue = positiveValue / fullValue * 100;
					percent = seriesDataItem.endValue - seriesDataItem.startValue;
						
					seriesDataItem.zValue = percent;
					seriesDataItem.zLabel = this.horizontalAxis.getZLabel(percent);
					seriesDataItem.zDisplayName = this.zDisplayName;
					
					XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
						['startValue', 'endValue', 'zValue', 'zLabel', 'zDisplayName', 'color']);
				}
				
				verticalValues.push(yValue);
				horizontalValues.push(positiveValue / fullValue * 100);
			}
		}
		
		/**
		 */		
		private var _percentLabel:String
		
		/**
		 * 百分比数值之前的标签; 在  toolTip 中会用到;
		 */
		public function get zDisplayName():String
		{
			return _percentLabel;
		}
		
		/**
		 * @private
		 */
		public function set zDisplayName(value:String):void
		{
			_percentLabel = value;
		}
	}
}