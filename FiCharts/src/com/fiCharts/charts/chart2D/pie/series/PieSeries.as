package com.fiCharts.charts.chart2D.pie.series
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.pie.PieChartModel;
	import com.fiCharts.charts.chart2D.pie.PieDataFormatter;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.charts.legend.view.LegendEvent;
	import com.fiCharts.charts.toolTips.TooltipStyle;
	import com.fiCharts.utils.MathUtil;
	import com.fiCharts.utils.XMLConfigKit.IEditableObject;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;

	/**
	 */	
	public class PieSeries extends Sprite implements IEditableObject, IStyleElement
	{
		public function PieSeries()
		{
		}
		
		/**
		 */		
		public function render():void
		{
			var partUI:PartPieUI;
			if (this.ifDataChanged)
			{
				while (this.numChildren)
					this.removeChildAt(0);
				
				var dataItem:PieDataItem;
				partUIs = new Vector.<PartPieUI>;
				
				for each (dataItem in this.dataItemVOs)
				{
					partUI = new PartPieUI(dataItem);
					partUI.states = this.states;
					partUI.labelStyle = this.valueLabel;
					partUI.tooltipStyle = this.tooltip;
					partUI.init();
					partUIs.push(partUI);
					addChild(partUI);
				}
			}
			
			if (ifSizeChanged || ifDataChanged)
			{
				for each(partUI in this.partUIs)
				{
					partUI.radius = this.radius;
					partUI.rads = new Vector.<Number>;
					
					var partRad:Number = precisionRad;
					var rad:Number = 0;
					var segment:uint = Math.ceil(partUI.angleRadRange / partRad);
					
					for (var i:uint = 0; i < segment; i ++)
					{
						if (i == segment - 1) // Last point.
						{
							rad = partUI.pieDataItem.endRad;
						}
						else
						{
							rad = partUI.pieDataItem.startRad + partRad * i;
						}
						
						partUI.rads.push(rad);
					}
					
					partUI.render();
					
					this.ifDataChanged = this.ifSizeChanged = false;
				}
				
			}
			
		}
		
		/**
		 */		
		private var _valueLabel:LabelStyle;

		/**
		 * 数值标签的样式 
		 */
		public function get valueLabel():LabelStyle
		{
			return _valueLabel;
		}

		/**
		 * @private
		 */
		public function set valueLabel(value:LabelStyle):void
		{
			_valueLabel = value;
		}

		/**
		 */		
		private var _tooltip:TooltipStyle;

		/**
		 * 信息提示的样式
		 */
		public function get tooltip():TooltipStyle
		{
			return _tooltip;
		}

		/**
		 * @private
		 */
		public function set tooltip(value:TooltipStyle):void
		{
			_tooltip = XMLVOMapper.updateObject(value, _tooltip, Model.TOOLTIP) as TooltipStyle;
		}

		/**
		 */		
		private function angleToRad(value:Number):Number
		{
			return value * Math.PI / 180;
		}
		
		/**
		 * @return 
		 */		
		private function get precisionRad():Number
		{
			return precisionLength / this.radius;
		}
		
		/**
		 * 弧线的等分距离，决定了弧线的光滑度，
		 */		
		private var precisionLength:uint = 1;
		
		/**
		 */		
		private var partUIs:Vector.<PartPieUI>;
		
		/**
		 */		
		private var _radius:Number = 0;

		/**
		 * 饼图的半径自适应窗口尺寸
		 */
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			if (value != _radius && value > 0)
			{
				_radius = value;
				ifSizeChanged = true;
			}
		}

		/**
		 */		
		private var ifSizeChanged:Boolean = false;
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(PieChartModel.PIE_SERIES_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(PieChartModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
		}
		
		/**
		 */		
		public function created():void
		{
			chartColorManager = new ChartColors;
		}
		
		/**
		 */		
		public function configed():void
		{
		}
		
		
		
		//-------------------------------------
		//
		// 图表颜色
		//
		//-------------------------------------
		
		/**
		 */		
		private var _color:Object

		public function get color():Object
		{
			return _color;
		}

		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);;
		}
		
		/**
		 */		
		protected var chartColorManager:ChartColors;
		
		
		
		
		
		//------------------------------------------
		//
		// 图例控制， 仅对渲染节点
		//
		//------------------------------------------
		
		private function itemRenderOverHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OVER));
		}
		
		private function itemRenderOutHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OUT));
		}
		
		private function itemRenderHideHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_HIDE));
		}
		
		private function itemRenderShowHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_SHOW));
		}
		
		
		
		
		//---------------------------------------------------
		//
		// 数据字段的初始化
		//
		//---------------------------------------------------
		
		/**
		 */		
		public function initData(value:XML):void
		{
			var seriesDataItem:PieDataItem;
			var dataSum:Number = 0;
			var startRad:Number = 0;
			var partRad:Number = 0;
			dataItemVOs = new Vector.<PieDataItem>;
			
			for each (var item:XML in value.children())
			{
				seriesDataItem = new PieDataItem;
				
				seriesDataItem.metaData = new Object;
				XMLVOMapper.pushXMLDataToVO(item, seriesDataItem.metaData);//将XML转化为对象
				
				seriesDataItem.label = seriesDataItem.metaData[this.labelField]; 
				seriesDataItem.value = seriesDataItem.metaData[this.valueField]; 
				
				seriesDataItem.xLabel = dataFormatter.formatLabel(seriesDataItem.label);
				seriesDataItem.yLabel = dataFormatter.formatValue(seriesDataItem.value);
				
				if (color)
					seriesDataItem.color = uint(color);
				else
					seriesDataItem.color = chartColorManager.chartColor;
				
				XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
					['label', 'value', 'xLabel', 'yLabel', 'color']);
				
				dataSum += Number(seriesDataItem.value);
				dataItemVOs.push(seriesDataItem);
			}
			
			startRad = this.angleToRad(startAngle);
			 
			for each (seriesDataItem in dataItemVOs)
			{
				seriesDataItem.zValue = Number(seriesDataItem.value) / dataSum * 100;
				seriesDataItem.zLabel = MathUtil.round(Number(seriesDataItem.zValue), 2) + '%';
				
				seriesDataItem.startRad = startRad;
				partRad = Number(seriesDataItem.zValue) / 100 * Math.PI * 2;
				seriesDataItem.endRad = startRad + partRad;
				startRad += partRad;
					
				XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, ['zValue', 'zLabel']);
				
				// 默认数值标签的元数据内容
				seriesDataItem.metaData.valueLabel = seriesDataItem.xLabel;
				
				// 默认tooltip
				seriesDataItem.metaData.tooltip = seriesDataItem.yLabel + "," + seriesDataItem.zLabel;
			}
			
			ifDataChanged = true;
		}
		
		/**
		 */		
		private var ifDataChanged:Boolean = false;
		
		/**
		 */		
		private var _startAngle:Number = 0

		public function get startAngle():Number
		{
			return _startAngle;
		}

		public function set startAngle(value:Number):void
		{
			_startAngle = value;
		}
		
		/**
		 */		
		private var dataItemVOs:Vector.<PieDataItem>;
		
		/**
		 */		
		public function get legendData():Vector.<LegendVO>
		{
			var legendVOes:Vector.<LegendVO> = new Vector.<LegendVO>;
			var legendVO:LegendVO;
			
			for each(var item:SeriesDataPoint in dataItemVOs)	
			{
				legendVO = new LegendVO();
				legendVO.metaData = item; // 用于精确控制节点的状态
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, itemRenderOverHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, itemRenderOutHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.HIDE_LEGEND, itemRenderHideHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.SHOW_LEGEND, itemRenderShowHandler, false, 0, true);
				legendVOes.push(legendVO);
			}
			
			return legendVOes;
		}
		
		/**
		 */		
		private var _labelField:String;

		/**
		 */
		public function get labelField():String
		{
			return _labelField;
		}

		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		/**
		 */		
		private var _valueField:String;

		public function get valueField():String
		{
			return _valueField;
		}

		public function set valueField(value:String):void
		{
			_valueField = value;
		}
		
		/**
		 */		
		private var _dataFormatter:PieDataFormatter;

		/**
		 */
		public function get dataFormatter():PieDataFormatter
		{
			return _dataFormatter;
		}

		/**
		 * @private
		 */
		public function set dataFormatter(value:PieDataFormatter):void
		{
			_dataFormatter = value;
		}
		
		
		
		
		//------------------------------------------------
		//
		//
		//  样式状态控制
		//
		//
		//------------------------------------------------
		
		/**
		 */		
		public function normalHandler():void
		{
			
		}
		
		/**
		 */		
		public function hoverHandler():void
		{
			
		}
		
		/**
		 */		
		public function downHandler():void
		{
			
		}
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = XMLVOMapper.updateObject(value, _states, "states") as States;;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		protected var _style:String;
		
		/**
		 */
		public function get style():String
		{
			return _style;
		}
		
		/**
		 *  style 采取的是继承模式，更新原有样式
		 */
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, "pie");
		}
		
		/**
		 * 
		 * 以id方式定义style和states时，刷新整个states样式
		 * 
		 */		
		public function fresh():void
		{
			_states = new States;
		}
		
	}
}