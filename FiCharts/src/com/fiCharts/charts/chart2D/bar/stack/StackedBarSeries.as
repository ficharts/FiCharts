package com.fiCharts.charts.chart2D.bar.stack
{
	import com.fiCharts.charts.chart2D.bar.BarItemUI;
	import com.fiCharts.charts.chart2D.column2D.Column2DUI;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedColumnSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedSeriesDataPoint;
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	/**
	 */	
	public class StackedBarSeries extends StackedColumnSeries
	{
		public function StackedBarSeries()
		{
			super();
			
			this.value = 'xValue';
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			if (ifNullData(item))
				return;
			
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.xLabel;
			itemRender.value = value;
			
			// 整体数值样式与独立数值样式有分别
			if (itemRender is StackedBarCombilePointRender)
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
			
			initTipString(item, itemRender.xTipLabel, 
				itemRender.yTipLabel,itemRender.zTipLabel,itemRender.isHorizontal);
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.STACKED_BAR_SERIES, Model.SYSTEM), this);
			
			this.stacks = new Vector.<StackedSeries>;
		}
		
		/**
		 */		
		override protected function get type():String
		{
			return "stackedBar";
		}
		
		/**
		 */		
		override public function setPercent(value:Number):void
		{
			canvas.scaleX = value;
		}
		
		/**
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			adjustColumnWidth();
			
			var item:SeriesDataPoint;
			for each (item in dataItemVOs)
			{
				item.x = this.horizontalAxis.valueToX((item as StackedSeriesDataPoint).startValue, NaN) - baseLine;
				item.dataItemX = horizontalAxis.valueToX((item as StackedSeriesDataPoint).endValue, NaN);
				
				// 数据节点的坐标系与渲染节点不同， 两者相�值为 baseLine
				item.y = verticalAxis.valueToY(item.yValue) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) //;
					
				item.dataItemY = item.y + partColumnWidth / 2;
				item.offset = baseLine;
			}
			
			for each (item in this.fullDataItems)
			{
				item.dataItemX = horizontalAxis.valueToX(item.xValue, NaN);
					
				item.dataItemY = verticalAxis.valueToY(item.yValue) - columnGoupWidth / 2 +
				this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) + partColumnWidth / 2;
			}
		}
		
		/**
		 */		
		override protected function layoutColumnUIs():void
		{
			for each (var columnUI:Column2DUI in this.columnUIs)
			{
				columnUI.x = horizontalAxis.valueToX((columnUI.dataItem as StackedSeriesDataPoint).startValue, NaN) - baseLine;
				columnUI.y = columnUI.dataItem.y; //+ partColumnWidth / 2;
				
				(columnUI.dataItem as StackedSeriesDataPoint).width = 
				columnUI.columnWidth = horizontalAxis.valueToX((columnUI.dataItem as StackedSeriesDataPoint).endValue, NaN) -
					horizontalAxis.valueToX((columnUI.dataItem as StackedSeriesDataPoint).startValue, NaN);
				
				columnUI.columnHeight = partColumnWidth;
				columnUI.render();
			}
		}
		
		/**
		 */		
		override protected function getSeriesItemUI(dataItem:SeriesDataPoint):Column2DUI
		{
			return new BarItemUI(dataItem);
		}
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new StackedBarPointRender(false);
		}
		
		/**
		 */		 	
		override protected function get combileItemRender():PointRenderBace
		{
			return new StackedBarCombilePointRender;
		}
		
		/**
		 */		
		override protected function preInitData():void
		{
			var xValue:Number, yValue:Object, positiveValue:Number, negativeValue:Number;
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
					xValue = Number(stack.dataItemVOs[i].xValue);
					yValue = stack.dataItemVOs[i].yValue;
					stackedSeriesDataItem = (stack.dataItemVOs[i] as StackedSeriesDataPoint);
					
					if (xValue >= 0)
					{
						stackedSeriesDataItem.startValue = Number(positiveValue);
						positiveValue += xValue;
						stackedSeriesDataItem.endValue = Number(positiveValue);
					}
					else 
					{
						stackedSeriesDataItem.startValue = Number(negativeValue);
						negativeValue += xValue;
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
					combleSeriesDataItem.metaData = new Object;
					
					combleSeriesDataItem.xValue = ((positiveValue + negativeValue) >= 0) ? positiveValue : negativeValue;
					combleSeriesDataItem.yValue = yValue;
					
					combleSeriesDataItem.xLabel = horizontalAxis.getXLabel(positiveValue + negativeValue);
					combleSeriesDataItem.yLabel = verticalAxis.getYLabel(combleSeriesDataItem.xValue);
					
					combleSeriesDataItem.color = uint(this.color);
					combleSeriesDataItem.seriesName = this.seriesName;
					
					combleSeriesDataItem.xDisplayName = horizontalAxis.displayName;
					combleSeriesDataItem.yDisplayName = verticalAxis.displayName;
					
					XMLVOMapper.pushAttributesToObject(combleSeriesDataItem, combleSeriesDataItem.metaData, 
						['xValue', 'yValue', 'xLabel', 'yLabel', 'xDisplayName', 'yDisplayName', 'seriesName', 'color']);
					
					fullDataItems.push(combleSeriesDataItem); 
				}
				
				verticalValues.push(yValue);
				horizontalValues.push(positiveValue);
				horizontalValues.push(negativeValue);
			}
		}
		
		/**
		 */		
		override public function configed(colorMananger:ChartColors):void
		{
			for each (var series:StackedSeries in this.stacks)
			{
				if (!series.color)// 如果未指�序列颜色则采用自动分配颜�
					series.color = colorMananger.chartColor.toString(16);
				
				series.horizontalAxis = this.horizontalAxis;
				series.verticalAxis = this.verticalAxis;
			}
			
			stacks.reverse();
			
			// 如果显示数值则坐标轴多延伸一个单元格�
			if (this.labelDisplay != LabelStyle.NONE && horizontalAxis is LinearAxis)
				(horizontalAxis as LinearAxis).ifExpend = true;
		}
		
		
		//---------------------------------------------
		//
		// 数值分布特�
		//
		//---------------------------------------------
		
		override public function applyDataFeature():void
		{
			this.directionControl.dataFeature = this.horizontalAxis.getSeriesDataFeature(
				this.horizontalValues.concat());
			
			directionControl.checkDirection(this);
			
			this.canvas.x = baseLine;
		}
		
		/**
		 */		
		override public function upBaseLine():void
		{
			if ((horizontalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = horizontalAxis.valueToX(0, NaN);
			else
				directionControl.baseLine = horizontalAxis.valueToX(directionControl.dataFeature.minValue, NaN);
		}
		
		/**
		 */		
		override public function centerBaseLine():void
		{
			directionControl.baseLine = horizontalAxis.valueToX(0, NaN);
		}
		
		/**
		 */		
		override public function downBaseLine():void
		{
			if ((horizontalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = horizontalAxis.valueToX(0, NaN);
			else
				directionControl.baseLine = horizontalAxis.valueToX(directionControl.dataFeature.maxValue, NaN);
		}
		
		/**
		 */		
		override public function get controlAxis():AxisBase
		{
			return this.horizontalAxis;
		}
		
		
		
		//-------------------------------------------------------
		//
		// 尺寸调整
		//
		//-------------------------------------------------------
		
		/**
		 * 根据最大允许的单个柱体宽度调整柱体群宽度和单个柱体实际宽度�
		 */		
		override protected function adjustColumnWidth():void
		{
			var temColumnGroupWidth:Number = verticalAxis.unitSize - columnGroupOuterSpaceUint * 2;
			var temColumnWidth:Number = (temColumnGroupWidth - columnGroupInnerSpace) / columnSeriesAmount;
			
			if (temColumnWidth <= maxItemSize)
			{
				_partColumnWidth = temColumnWidth;
				_columnGoupWidth = temColumnGroupWidth;
			}
			else
			{
				_partColumnWidth = maxItemSize;
				_columnGoupWidth = _partColumnWidth * columnSeriesAmount + columnGroupInnerSpace;
			}
		}
		
		/**
		 * 柱体群内部的单元间隙，个数为群柱体个�- 1�
		 */		
		override protected function get columnGroupInnerSpaceUint():Number
		{
			return  verticalAxis.unitSize * .05;
		}
		
		/**
		 * 柱体群外单元空隙，每个柱体群有两个此间隙�
		 */
		override public function get columnGroupOuterSpaceUint():Number
		{
			return verticalAxis.unitSize * .1;
		}
	}
}