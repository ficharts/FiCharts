package com.fiCharts.charts.chart2D.column2D.stack
{
	import com.fiCharts.charts.chart2D.column2D.Column2DUI;
	import com.fiCharts.charts.chart2D.column2D.ColumnSeries2D;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.charts.legend.view.LegendEvent;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	/**
	 * 堆积序列群组类；
	 * 
	 * 堆积序列的子序列是个仅拥有数据的空壳，样式定义，样式渲染全部�code>StackedColumnSeries</code>中进行， 
	 * 
	 */	
	public class StackedColumnSeries extends ColumnSeries2D
	{
		public function StackedColumnSeries()
		{
			super();
		}
		
		/**
		 */		
		override protected function get type():String
		{
			return "stackedColumn";
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.STACKED_COLUMN_SERIES, Model.SYSTEM), this);
			
			this.stacks = new Vector.<StackedSeries>;
		}
		
		/**
		 */		
		override protected function draw():void
		{
			if (ifDataChanged)
			{
				while (canvas.numChildren)
					canvas.removeChildAt(0);
				
				var columnItemUI:Column2DUI;
				columnUIs = new Vector.<Column2DUI>;
				for each (var stack:StackedSeries in stacks)
				{
					for each (var itemDataVO:SeriesDataPoint in stack.dataItemVOs)
					{
						if (ifNullData(itemDataVO))
							continue;
						
						columnItemUI = getSeriesItemUI(itemDataVO);
						columnItemUI.states = this.states;//样式统一定义
						columnItemUI.metaData = itemDataVO.metaData;
						columnUIs.push(columnItemUI);
						canvas.addChild(columnItemUI);
					}
				}
			}
			
			if (this.ifSizeChanged || this.ifDataChanged)
			{
				layoutColumnUIs();
				ifDataChanged = ifSizeChanged = false;
			}
		}
		
		/**
		 */		
		override protected function layoutColumnUIs():void
		{
			var index:uint;
			for each (var columnUI:Column2DUI in this.columnUIs)
			{
				columnUI.x = columnUI.dataItem.x - partColumnWidth / 2;
				columnUI.y = columnUI.dataItem.y//verticalAxis.valueToY((columnUI.dataItem as StackedSeriesDataItem).startValue) - baseLine;
				setColumnUISize(columnUI);
				columnUI.render();
			}
		}
		
		/**
		 */		
		override protected function setColumnUISize(columnUI:Column2DUI):void
		{
			(columnUI.dataItem as StackedSeriesDataPoint).width = columnUI.columnWidth = partColumnWidth;
			(columnUI.dataItem as StackedSeriesDataPoint).height = columnUI.columnHeight = 
			
				verticalAxis.valueToY((columnUI.dataItem as StackedSeriesDataPoint).endValue) -
				verticalAxis.valueToY((columnUI.dataItem as StackedSeriesDataPoint).startValue);
		}
		
		/**
		 */		
		override protected function getSeriesItemUI(dataItem:SeriesDataPoint):Column2DUI
		{
			return new StackedColumnUI(dataItem);
		}
		
		/**
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			adjustColumnWidth();
			
			var item:SeriesDataPoint;
			var i:int;
			
			for (i = startIndex; i <= endIndex; i += step)
			{
				item = dataItemVOs[i];
				
				item.x = horizontalAxis.valueToX(item.xValue, i) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) + partColumnWidth / 2;
				item.dataItemX = item.x;
				
				// 数据节点的坐标系与渲染节点不同， 两者相�值为 baseLine
				item.y = verticalAxis.valueToY((item as StackedSeriesDataPoint).startValue) - baseLine;
				item.dataItemY = verticalAxis.valueToY((item as StackedSeriesDataPoint).endValue);
				item.offset = baseLine;
			}
			
			if(fullDataItems == null) return;//百分百堆积图没有总数据节�
			
			for (i = startIndex; i <= endIndex; i += step)
			{
				item = fullDataItems[i];
				
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xValue, i) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) + partColumnWidth / 2;
				
				item.y = item.dataItemY = verticalAxis.valueToY(item.yValue);
			}
		}
		
		/**
		 * 创建汇总数据节点的渲染器， 这里创建的渲染器只是用于汇总数据的显示�
		 */		
		override public function createItemRenders():void
		{
			super.createItemRenders();
			
			for each (var item:SeriesDataPoint in fullDataItems)
				initItemRender(combileItemRender, item);
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			if (ifNullData(item))
				return;
			
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			// 整体数值样式与独立数值样式有分别
			if (itemRender is StackedColumnCombiePointRender)
			{
				itemRender.valueLabel = this.valueLabel;
				this.updateLabelDisplay(itemRender);
			}
			else
			{
				itemRender.valueLabel = this.innerValueLabel;
				this.updateLabelDisplay(itemRender);
			}
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		protected function get combileItemRender():PointRenderBace
		{
			return new StackedColumnCombiePointRender;
		}
		
		/**
		 * 序列数据�坐标轴数据的创建
		 * 
		 * 这里把原始的数据节点与计算得出的汇总数据节点分离；
		 */		
		override protected function preInitData():void
		{
			var xValue:Object, yValue:Number, positiveValue:Number, negativeValue:Number;
			var length:uint = dataProvider.length;
			var stack:StackedSeries;
			var combleSeriesDataItem:SeriesDataPoint;
			var stackedSeriesDataItem:StackedSeriesDataPoint;
			
			dataItemVOs = new Vector.<SeriesDataPoint>
			horizontalValues = new Vector.<Object>;
			verticalValues = new Vector.<Object>;
			fullDataItems = new Vector.<SeriesDataPoint>;
			
			
			// 将子序列的数据节点合并到一起；
			for each (stack in stacks)
			{
				stack.dataProvider = this.dataProvider;
				dataItemVOs = dataItemVOs.concat(stack.dataItemVOs);
			}
			
			// 将子序列的数值叠加， 因坐标轴的数值显示的是总量�
			for (var i:uint = 0; i < length; i++)
			{
				positiveValue = negativeValue = 0;
				for each (stack in stacks)
				{
					stackedSeriesDataItem = (stack.dataItemVOs[i] as StackedSeriesDataPoint);
					stackedSeriesDataItem.index = i;
					
					xValue = stackedSeriesDataItem.xValue;
					yValue = Number(stackedSeriesDataItem.yValue);
					
					if (yValue >= 0)
					{
						stackedSeriesDataItem.startValue = Number(positiveValue);
						positiveValue += yValue;
						stackedSeriesDataItem.endValue = Number(positiveValue);
					}
					else
					{
						stackedSeriesDataItem.startValue = Number(negativeValue);
						negativeValue += yValue;
						stackedSeriesDataItem.endValue = Number(negativeValue);
					}
					
					XMLVOMapper.pushAttributesToObject(stackedSeriesDataItem, stackedSeriesDataItem.metaData, 
						['startValue', 'endValue']);
				}
				
				// 将所有堆积值求和， 数值标签取求和值， 标签的位置取决于最值， 
				// 求和为正取最大值， 求和为负则取最小值；
				if (this.valueLabel.enable)
				{
					combleSeriesDataItem = new SeriesDataPoint();
					combleSeriesDataItem.index = i;
					combleSeriesDataItem.metaData = new Object;
					
					combleSeriesDataItem.xValue = xValue;
					combleSeriesDataItem.yValue = ((positiveValue + negativeValue) >= 0) ? positiveValue : negativeValue;
					
					combleSeriesDataItem.xLabel = horizontalAxis.getXLabel(combleSeriesDataItem.xValue);
					combleSeriesDataItem.yLabel = verticalAxis.getYLabel(positiveValue + negativeValue);
					
					combleSeriesDataItem.color = uint(this.color);
					combleSeriesDataItem.seriesName = this.seriesName;
					
					combleSeriesDataItem.xDisplayName = horizontalAxis.displayName;
					combleSeriesDataItem.yDisplayName = verticalAxis.displayName;
					
					XMLVOMapper.pushAttributesToObject(combleSeriesDataItem, combleSeriesDataItem.metaData, 
						['xValue', 'yValue', 'xLabel', 'yLabel', 'xDisplayName', 'yDisplayName', 'seriesName', 'color']);
					
					fullDataItems.push(combleSeriesDataItem); 
				}
				
				horizontalValues.push(xValue);
				verticalValues.push(positiveValue);
				verticalValues.push(negativeValue);
			}
			
			dataOffsetter.maxIndex = maxDataItemIndex = length - 1;
		}
		
		/**
		 */		
		override public function get legendData():Vector.<LegendVO>
		{
			var legendVOes:Vector.<LegendVO> = new Vector.<LegendVO>;
			var legendVO:LegendVO;
			
			for each(var item:StackedSeries in stacks)
			{
				legendVO = new LegendVO();
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, item.seriesLegendOverHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, item.seriesLegendOutHandler, false, 0, true);
				
				legendVO.addEventListener(LegendEvent.HIDE_LEGEND, item.seriesHideLegendHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.SHOW_LEGEND, item.seriesShowLegendHandler, false, 0, true);
				
				legendVO.metaData = item;
				legendVOes.push(legendVO);
			}
				
			return legendVOes;
		}
		
		/**
		 */		
		override public function initSeriesName(index:uint):uint
		{
			var seriesIndex:uint = index;
			
			for each(var item:SB in stacks)
				seriesIndex = item.initSeriesName(seriesIndex)
				
			return seriesIndex;
		}
		
		/**
		 * 
		 */
		public function get stack():StackedSeries
		{
			return null;
		}

		public function set stack(value:StackedSeries):void
		{
			stacks.push(value);
		}

		/**
		 * 堆积序列的创建与配置
		 */		
		override public function configed(colorMananger:ChartColors):void
		{
			if (this.labelDisplay != LabelStyle.NONE && verticalAxis is LinearAxis)
				(verticalAxis as LinearAxis).ifExpend = true;
			
			for each (var series:StackedSeries in this.stacks)
			{
				if (!series.color)// 如果未指�序列颜色则采用自动分配颜�
					series.color = colorMananger.chartColor.toString(16);
				
				series.horizontalAxis = this.horizontalAxis;
				series.verticalAxis = this.verticalAxis;
			}
			
			//stacks.reverse();
		}
		
		/**
		 */		
		protected var fullDataItems:Vector.<SeriesDataPoint>;
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new StackedColumnPointRender(false);
		}
		
		/**
		 */		
		protected var stacks:Vector.<StackedSeries>; 
		
	}
}