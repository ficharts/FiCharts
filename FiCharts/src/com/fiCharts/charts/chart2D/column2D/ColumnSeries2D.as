package com.fiCharts.charts.chart2D.column2D
{
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.encry.SeriesBase;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;

	/**
	 */
	public class ColumnSeries2D extends SeriesBase implements IDirectionSeries
	{
		/**
		 */
		public function ColumnSeries2D()
		{
			super();
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:ItemRenderBace, item:SeriesDataItemVO):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
				// labelDisplay 决定数值显示方式：隐藏，倾斜，90度，内部， 外部。
				if (this.labelDisplay == LabelStyle.INNER)
					itemRender.valueLabel = this.innerValueLabel;
				else
					itemRender.valueLabel = valueLabel;
				
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
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.COLUMN_SERIES), this);
		}
		
		/**
		 */		
		override public function setPercent(value:Number):void
		{
			canvas.scaleY = value;
		}
		
		/**
		 */		
		override public function configed(colorMananger:ChartColorManager):void
		{
			if (this.labelDisplay == LabelStyle.NORMAL && verticalAxis is LinearAxis)
				(verticalAxis as LinearAxis).ifExpend = true;
		}
		
		/**
		 * @private
		 */
		override public function set innerValueLabel(value:LabelStyle):void
		{
			_innerValueLabel = value;
			
			// 此标签决定了柱体数值标签的布局方式， 是在外部还是内部；
			_innerValueLabel.layout = LabelStyle.INNER; 
		}

		
		
		//----------------------------------------
		//
		// 渲染
		//
		//----------------------------------------
		
		/**
		 * 更新数据节点的布局信息；
		 */		
		override protected function layoutDataItems():void
		{
			adjustColumnWidth();
			
			for each (var item:SeriesDataItemVO in dataItemVOs)
			{
				item.x = horizontalAxis.valueToX(item.xValue) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) + partColumnWidth / 2;
				
				item.y = (verticalAxis.valueToY(item.yValue));
				
				item.dataItemX = item.x;
				item.dataItemY = item.y;
			}
		}
		
		/**
		 * 渲染区域
		 */
		override protected function renderChart():void
		{
			if (ifDataChanged)
			{
				while (canvas.numChildren)
					canvas.removeChildAt(0);
				
				var columnItemUI:Column2DUI;
				columnUIs = new Vector.<Column2DUI>;
				for each (var itemDataVO:SeriesDataItemVO in dataItemVOs)
				{
					//draw column or bar
					columnItemUI = getSeriesItemUI(itemDataVO);
					columnItemUI.states = this.states;
					columnItemUI.metaData = itemDataVO.metaData;
					
					canvas.addChild(columnItemUI);
					columnUIs.push(columnItemUI);
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
		protected function getSeriesItemUI(dataItem:SeriesDataItemVO):Column2DUI
		{
			return new Column2DUI(dataItem);
		}
		
		/**
		 */		
		override protected function get itemRender():ItemRenderBace
		{
			var render:ColumnItemRender = new ColumnItemRender(false);
			
			return render;
		}
		
		/**
		 */		
		override protected function get seriesDataItem():SeriesDataItemVO
		{
			return new ColumnDataItem
		}
		
		/**
		 */		
		protected function layoutColumnUIs():void
		{
			for each (var columnUI:Column2DUI in this.columnUIs)
			{
				columnUI.x = columnUI.dataItem.x - this.partColumnWidth / 2;
				columnUI.y = 0;
				setColumnUISize(columnUI);
				columnUI.render();
			}
		}
		
		/**
		 */		
		protected function setColumnUISize(columnUI:Column2DUI):void
		{
			(columnUI.dataItem as ColumnDataItem).width = 
				columnUI.columnWidth = partColumnWidth;
			
			(columnUI.dataItem as ColumnDataItem).height = 
				columnUI.columnHeight = columnUI.dataItem.y - baseLine;
		}
		
		/**
		 */		
		protected var columnUIs:Vector.<Column2DUI>;
		
		
		
		
		//----------------------------------------
		//
		// 柱体的宽度计算
		//
		//----------------------------------------
		
		
		/**
		 * 根据最大允许的单个柱体宽度调整柱体群宽度和单个柱体实际宽度；
		 */		
		protected function adjustColumnWidth():void
		{
			var temColumnGroupWidth:Number = horizontalAxis.unitSize - columnGroupOuterSpaceUint * 2;
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
		 */		
		protected function get partColumnWidth():Number
		{
			return _partColumnWidth;
		}
		
		protected var _partColumnWidth:Number;
		
		/**
		 * 出去两边空隙后得到的柱体群总宽度；
		 */		
		protected function get columnGoupWidth():Number
		{
			return _columnGoupWidth;
		}
		
		/**
		 */		
		protected var _columnGoupWidth:Number;
		
		/**
		 * 最大单个柱子宽度，哪怕是仅有一个柱子，但此柱子不能太宽/Bar不能太高 ；
		 */		
		private var _maxColumnWidth:Number = 100;

		public function get maxItemSize():Number
		{
			return _maxColumnWidth;
		}

		public function set maxItemSize(value:Number):void
		{
			_maxColumnWidth = value;
		}

		/**
		 * 单元柱体群内部总间隙;
		 */		
		protected function get columnGroupInnerSpace():Number
		{
			return columnGroupInnerSpaceUint * (columnSeriesAmount - 1);
		}
		
		/**
		 * 柱体群内部的单元间隙，个数为群柱体个数 - 1；
		 */		
		protected function get columnGroupInnerSpaceUint():Number
		{
			return horizontalAxis.unitSize * .05;
		}
		
		/**
		 * 柱体群外单元空隙，每个柱体群有两个此间隙；
		 */
		public function get columnGroupOuterSpaceUint():Number
		{
			return horizontalAxis.unitSize * .1;
		}

		/**
		 * 图表中柱状图序列总数； 
		 */		
		private var _columnSeriesAmount:uint = 0;

		public function get columnSeriesAmount():uint
		{
			return _columnSeriesAmount;
		}

		public function set columnSeriesAmount(value:uint):void
		{
			_columnSeriesAmount = value;
		}
		
		/**
		 */		
		private var _columnSeriesIndex:uint;

		/**
		 */
		public function get columnSeriesIndex():uint
		{
			return _columnSeriesIndex;
		}

		/**
		 * @private
		 */
		public function set columnSeriesIndex(value:uint):void
		{
			_columnSeriesIndex = value;
		}

		
	}
}