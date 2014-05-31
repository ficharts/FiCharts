package com.fiCharts.charts.chart2D.bar
{
	import com.fiCharts.charts.chart2D.column2D.Column2DUI;
	import com.fiCharts.charts.chart2D.column2D.ColumnDataPoint;
	import com.fiCharts.charts.chart2D.column2D.ColumnSeries2D;
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	/**
	 */	
	public class BarSeries extends ColumnSeries2D
	{
		public function BarSeries()
		{
			super();
			
			this.value = 'xValue';
		}
		
		/**
		 */		
		override protected function preInitData():void
		{
			dataProvider.reverse();
			
			super.preInitData();
			//
			//dataItemVOs.reverse();
			//sourceDataItems.reverse();
		}
		
		/**
		 */		
		override protected function getClassicPattern():ISeriesRenderPattern
		{
			return new ClassicBarRender(this)
		}
		
		/**
		 */		
		override protected function getSimplePattern():ISeriesRenderPattern
		{
			return new SimpleBarRender(this);
		}
		
		/**
		 */		
		override protected function get type():String
		{
			return "bar";
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.xLabel;
			itemRender.value = value;
			
				if (this.labelDisplay == LabelStyle.INNER)
					itemRender.valueLabel = this.innerValueLabel;
				else
					itemRender.valueLabel = valueLabel;
				
				this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			initTipString(item, itemRender.xTipLabel, 
				itemRender.yTipLabel,itemRender.zTipLabel,itemRender.isHorizontal);
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		override public function configed(colorMananger:ChartColors):void
		{
			if (this.labelDisplay == LabelStyle.NORMAL && horizontalAxis is LinearAxis)
				(horizontalAxis as LinearAxis).ifExpend = true;
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*= null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.BAR_SERIES, Model.SYSTEM), this);
		}
		
		/**
		 */		
		override public function setPercent(value:Number):void
		{
			canvas.scaleX = value;
		}
		
		/**
		 * 更新数据节点的布局信息�
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			adjustColumnWidth();
			
			var item:SeriesDataPoint;
			for (var i:uint = startIndex; i <= endIndex; i += step)
			{
				item = dataItemVOsForRender[i];
					
				item.x = this.horizontalAxis.valueToX(item.xVerifyValue, i);
				item.y = verticalAxis.valueToY(item.yVerifyValue) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint)// 
				
				item.dataItemX = item.x;
				item.dataItemY = item.y + partColumnWidth / 2;
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
		override public function layoutAndRenderUIs():void
		{
			for each (var columnUI:Column2DUI in this.columnUIs)
			{
				columnUI.x = 0;
				columnUI.y = columnUI.dataItem.y;
				(columnUI.dataItem as ColumnDataPoint).width = columnUI.columnWidth = columnUI.dataItem.x - baseLine;;
				columnUI.columnHeight = partColumnWidth;
				columnUI.render();
			}
		}
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			var render:BarPointRender = new BarPointRender(false);
			
			return render;
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