package com.fiCharts.charts.chart2D.bubble
{
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	/**
	 */	
	public class BubbleSeries extends SB
	{
		public function BubbleSeries()
		{
			super();
		}
		
		/**
		 */		
		override protected function getClassicPattern():ISeriesRenderPattern
		{
			return new ClassicBubbleRender(this);	
		}
		
		/**
		 */		
		override protected function getSimplePattern():ISeriesRenderPattern
		{
			return new SimpleBubbleRender(this);
		}
		
		/**
		 */		
		override protected function get type():String
		{
			return "bubble";
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.BUBBLE_SERIES, Model.SYSTEM), this);
		}
		
		/**
		 */		
		override public function created():void
		{
			chartColorManager = new ChartColors
		}
		
		/**
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			var item:SeriesDataPoint;
			for (var i:uint = startIndex; i <= endIndex; i += step)
			{
				item = dataItemVOs[i];
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xVerifyValue, i);
				item.dataItemY =  (verticalAxis.valueToY(item.yVerifyValue));
				item.y = item.dataItemY - this.baseLine;
					
				if (ifDataChanged)
				{
					(item as BubbleDataPoint).percent = this.radiusAxis.valueToZ(item.zValue)					
					item.z = minRadius + (item as BubbleDataPoint).percent * (this.maxRadius - this.minRadius)
				}
			}
		}
		
		/**
		 * 绘制占位符， 鼠标移动到节点上方时保证可以触发事件;
		 */		
		override protected function draw():void
		{
			this.canvas.graphics.clear();	
			canvas.graphics.beginFill(0, 0);
			
			for each (var item:SeriesDataPoint in this.dataItemVOs)
				canvas.graphics.drawCircle(item.x, item.y, item.z);
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.zLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = this.innerValueLabel;
			this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			initTipString(item, itemRender.xTipLabel, 
				itemRender.yTipLabel,getZTip(item),itemRender.isHorizontal);
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new BubblePointRender;
		}
		
		/**
		 */		
		private var _radiusAxis:LinearAxis;

		public function get radiusAxis():LinearAxis
		{
			return _radiusAxis;
		}

		public function set radiusAxis(value:LinearAxis):void
		{
			_radiusAxis = value;
		}

		/**
		 */		
		private var _radiusField:String;

		public function get radiusField():String
		{
			return _radiusField;
		}

		public function set radiusField(value:String):void
		{
			_radiusField = value;
		}
		
		/**
		 */		
		public function get bubbleField():String
		{
			return _radiusField;
		}
		
		public function set bubbleField(value:String):void
		{
			_radiusField = value;
		}
		
		/**
		 */		
		public function get zField():String
		{
			return _radiusField;
		}
		
		/**
		 */		
		public function set zField(value:String):void
		{
			_radiusField = value;
		}

		/**
		 */		
		private var _maxRadius:uint = 50;

		/**
		 */
		public function get maxRadius():uint
		{
			return _maxRadius;
		}

		/**
		 * @private
		 */
		public function set maxRadius(value:uint):void
		{
			_maxRadius = value;
		}

		/**
		 */		
		private var _minRadius:uint = 5;

		public function get minRadius():uint
		{
			return _minRadius;
		}

		public function set minRadius(value:uint):void
		{
			_minRadius = value;
		}
		
		/**
		 */		
		override public function updateAxisValueRange():void
		{
			super.updateAxisValueRange();
			radiusAxis.pushValues(radiusValues.concat());
		}
		
		/**
		 */		
		override protected function preInitData():void
		{
			var seriesDataItem:SeriesDataPoint;
			
			dataItemVOs.length = 0;
			horizontalValues.length = 0;
			verticalValues.length = 0;
			radiusValues = new Vector.<Object>;
			
			var precision:uint = 0;
			var temYPrecision:uint = 0;
			var temZPrecision:uint = 0;
			
			for each (var item:Object in dataProvider)
			{
				seriesDataItem = new BubbleDataPoint();
				
				seriesDataItem.metaData = item;
				
				seriesDataItem.xValue = seriesDataItem.metaData[xField]; // xValue.
				seriesDataItem.yValue = seriesDataItem.metaData[yField]; // yValue.
				seriesDataItem.zValue = seriesDataItem.metaData[radiusField];
				
				seriesDataItem.xVerifyValue = this.horizontalAxis.getVerifyData(seriesDataItem.xValue);
				seriesDataItem.yVerifyValue = this.verticalAxis.getVerifyData(seriesDataItem.yValue);
				
				setItemColor(seriesDataItem.metaData, seriesDataItem);
				seriesDataItem.seriesName = seriesName;
				
				horizontalValues.push(seriesDataItem.xValue);
				verticalValues.push(seriesDataItem.yValue);
				radiusValues.push(seriesDataItem.zValue);
				
				dataItemVOs.push(seriesDataItem);
				
				temYPrecision = RexUtil.checkPrecision(seriesDataItem.yValue.toString())
				temZPrecision = RexUtil.checkPrecision(seriesDataItem.zValue.toString())	
					
				if (temYPrecision > precision)
					precision = temYPrecision;
				
				if (temZPrecision > precision)
					precision = temZPrecision;
			}
			
			if (precision > verticalAxis.dataFormatter.precision)				
				verticalAxis.dataFormatter.precision = precision;
			
			for each (seriesDataItem in dataItemVOs)
			{
				seriesDataItem.xLabel = horizontalAxis.getXLabel(seriesDataItem.xVerifyValue);
				seriesDataItem.yLabel = verticalAxis.getYLabel(seriesDataItem.yVerifyValue);
				seriesDataItem.zLabel = this.radiusAxis.getZLabel(seriesDataItem.zValue);
				
				seriesDataItem.xDisplayName = horizontalAxis.displayName;
				seriesDataItem.yDisplayName = verticalAxis.displayName;
				seriesDataItem.zDisplayName = this.zDisplayName;
				
				XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
					['zValue', 'zLabel', 'zDisplayName',
						'xValue', 'xLabel', 'xDisplayName',
						'yValue', 'yLabel', 'yDisplayName',
						'seriesName', 'color']);
			}
			
			dataOffsetter.maxIndex = maxDataItemIndex = dataItemVOs.length - 1;
		}
		
		/**
		 */		
		override protected function getZTip(itemVO:SeriesDataPoint):String
		{
			var bubbleTip:String;
			bubbleTip = itemVO.zLabel;
			
			if (itemVO.zDisplayName)
				bubbleTip = itemVO.zDisplayName + ':' + bubbleTip;
			
			return '<br>' + bubbleTip;
		}
		
		/**
		 */		
		private var _radiusValues:Vector.<Object>

		/**
		 */
		public function get radiusValues():Vector.<Object>
		{
			return _radiusValues;
		}

		/**
		 * @private
		 */
		public function set radiusValues(value:Vector.<Object>):void
		{
			_radiusValues = value;
		}
		
		/**
		 */		
		private var _bubbleLabel:String;

		/**
		 */
		public function get zDisplayName():String
		{
			return _bubbleLabel;
		}

		/**
		 * @private
		 */
		public function set zDisplayName(value:String):void
		{
			_bubbleLabel = value;
		}
		
	}
}