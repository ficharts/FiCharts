package com.fiCharts.charts.chart2D.bubble
{
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.DataRenderStyle;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.SeriesDataItemVO;
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
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.BUBBLE_SERIES), this);
		}
		
		/**
		 */		
		override public function created():void
		{
			//stateContorl = new StatesControl(this);
			chartColorManager = new ChartColorManager
		}
		
		/**
		 */		
		override protected function layoutDataItems():void
		{
			var item:SeriesDataItemVO;
			for (var i:uint = 0; i <= this.itemRenderMaxIndex; i ++)
			{
				item = dataItemVOs[i];
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xValue);
				item.dataItemY =  (verticalAxis.valueToY(item.yValue));
				item.y = item.dataItemY - this.baseLine;
					
				if (ifDataChanged)
				{
					(item as BubbleDataItem).percent = this.radiusAxis.valueToZ(item.zValue)					
					item.z = minRadius + (item as BubbleDataItem).percent * (this.maxRadius - this.minRadius)
				}
			}
		}
		
		/**
		 * 绘制占位符， 鼠标移动到节点上方时保证可以触发事件;
		 */		
		override protected function renderChart():void
		{
			this.canvas.graphics.clear();	
			canvas.graphics.beginFill(0, 0);
			
			for each (var item:SeriesDataItemVO in this.dataItemVOs)
				canvas.graphics.drawCircle(item.x, item.y, item.z);
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
			
			itemRender.dataRender = this.bubbleRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		private var _bubbleRender:DataRenderStyle;

		/**
		 */
		public function get bubbleRender():DataRenderStyle
		{
			return _bubbleRender;
		}

		/**
		 * @private
		 */
		public function set bubbleRender(value:DataRenderStyle):void
		{
			_bubbleRender = value;
		}

		
		/**
		 */		
		override protected function get itemRender():ItemRenderBace
		{
			return new BubbleItemRender;
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
		override protected function initData():void
		{
			var seriesDataItem:SeriesDataItemVO;
			
			dataItemVOs = new Vector.<SeriesDataItemVO>
			horizontalValues = new Vector.<Object>;
			verticalValues = new Vector.<Object>;
			radiusValues = new Vector.<Object>;
			
			for each (var item:XML in dataProvider.children())
			{
				seriesDataItem = new BubbleDataItem();
				
				seriesDataItem.metaData = new Object();
				XMLVOMapper.pushXMLDataToVO(item, seriesDataItem.metaData);//将XML转化为对象
				
				seriesDataItem.xValue = seriesDataItem.metaData[xField]; // xValue.
				seriesDataItem.yValue = seriesDataItem.metaData[yField]; // yValue.
				seriesDataItem.zValue = seriesDataItem.metaData[radiusField];
				
				seriesDataItem.xLabel = horizontalAxis.getXLabel(seriesDataItem.xValue);
				seriesDataItem.yLabel = verticalAxis.getYLabel(seriesDataItem.yValue);
				seriesDataItem.zLabel = this.radiusAxis.getZLabel(seriesDataItem.zValue);
				
				seriesDataItem.xDisplayName = horizontalAxis.displayName;
				seriesDataItem.yDisplayName = verticalAxis.displayName;
				seriesDataItem.zDisplayName = this.zDisplayName;
				
				setItemColor(seriesDataItem.metaData, seriesDataItem);
				seriesDataItem.seriesName = seriesName;
				
				horizontalValues.push(seriesDataItem.xValue);
				verticalValues.push(seriesDataItem.yValue);
				radiusValues.push(seriesDataItem.zValue);
				
				XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
					['zValue', 'zLabel', 'zDisplayName',
					 'xValue', 'xLabel', 'xDisplayName',
					 'yValue', 'yLabel', 'yDisplayName',
					 'seriesName', 'color']);
				
				dataItemVOs.push(seriesDataItem);
			}
			
			itemRenderMaxIndex = dataItemVOs.length - 1;
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