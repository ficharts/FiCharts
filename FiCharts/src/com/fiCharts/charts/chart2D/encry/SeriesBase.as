package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.DataRenderStyle;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.core.series.SeriesDirectionControl;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.charts.legend.view.LegendEvent;
	import com.fiCharts.ui.toolTips.TooltipStyle;
	import com.fiCharts.utils.XMLConfigKit.IEditableObject;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;

	/**
	 * SeriesBase
	 */	
	public class SeriesBase extends Sprite implements IDirectionSeries, IEditableObject, IStyleStatesUI
	{

		/**
		 */		
		public function SeriesBase()
		{
			super();
			
			addChild(canvas);
		}
		
		/**
		 */		
		public function render():void
		{
			
		}
		
		public function normalHandler():void
		{
			
		}
		
		public function hoverHandler():void
		{
			
		}
		
		public function downHandler():void
		{
			
		}
		
		/**
		 */		
		private var _style:Style;

		/**
		 */
		public function get style():Style
		{
			return _style;
		}

		/**
		 * @private
		 */
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _states:States;

		/**
		 */
		public function get states():States
		{
			return _states;
		}

		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = XMLVOMapper.getInstanceFromLib(value) as States;
		}
		
		/**
		 */		
		protected var stateControl:StatesControl;
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE), this);
		}
		
		/**
		 */		
		public function created():void
		{
			chartColorManager = new ChartColorManager;
		}
		
		/**
		 * 序列被创建并配置完毕后回调方法, 此方法在数据设置之前调用；
		 */		
		public function configed(colorMananger:ChartColorManager):void
		{
			if (this.labelDisplay == LabelStyle.NORMAL && verticalAxis is LinearAxis)
				(verticalAxis as LinearAxis).ifExpend = true;
		}
		
		/**
		 */		
		public function set labelDisplay(value:String):void
		{
			_labelDisplay = value;
		}
		
		/**
		 */		
		public function get labelDisplay():String
		{
			return _labelDisplay;
		}
		
		/**
		 */		
		private var _labelDisplay:String = LabelStyle.NORMAL;
		
		/**
		 * 绘制图表的画布或者存放图表元素的容器;
		 */		
		protected var canvas:Sprite = new Sprite;

		
		//---------------------------------------------
		//
		// 数值分布特征
		//
		//---------------------------------------------
		
		protected function applyDataFeature():void
		{
			this.directionControl.dataFeature = this.verticalAxis.getSeriesDataFeature(
				this.verticalValues.concat());
			directionControl.checkDirection(this);
			
			this.canvas.y = baseLine;
		}
		
		/**
		 */		
		public function upBaseLine():void
		{
			if ((verticalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = verticalAxis.valueToY(0);
			else
				directionControl.baseLine = verticalAxis.valueToY(directionControl.dataFeature.minValue);
		}
		
		/**
		 */		
		public function centerBaseLine():void
		{
			directionControl.baseLine = verticalAxis.valueToY(0);
		}
		
		/**
		 */		
		public function downBaseLine():void
		{
			if ((verticalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = verticalAxis.valueToY(0);
			else
				directionControl.baseLine = verticalAxis.valueToY(directionControl.dataFeature.maxValue);
		}
		
		/**
		 */		
		protected function get baseLine():Number
		{
			return directionControl.baseLine;
		}
		
		/**
		 */		
		protected var directionControl:SeriesDirectionControl = new SeriesDirectionControl();
		 
		/**
		 */		
		public function get controlAxis():AxisBase
		{
			return this.verticalAxis;
		}

		
		//-------------------------------------------
		//
		// 图表渲染
		//
		//--------------------------------------------
		
		/**
		 * 创建渲染节点并渲染图表序列；
		 * 
		 *  创建渲染节点  > 布局数据节点  > 渲染图表  > 渲染 渲染节点
		 */
		public function renderSeries():void
		{
			if (ifDataChanged)
				createItemRenders();
			
			if (ifDataChanged || ifSizeChanged)
			{
				this.applyDataFeature();
				layoutDataItems();
				renderChart();
			}
		}

		/**
		 */
		protected var ifDataChanged:Boolean = false;
		
		/**
		 */		
		protected var ifSizeChanged:Boolean = false;

		/**
		 * Render chart content.
		 */
		protected function renderChart():void
		{
			// To override.
		}
		
		/**
		 *  动画渲染时传入动画进度百分比， 各序列执行自己的动画方式；
		 */		
		public function setPercent(value:Number):void
		{
			
		}
		
		

		
		//-------------------------------------
		//
		// 序列的属性定义
		//
		//-------------------------------------
		
		/**
		 */		
		private var _tooltip:TooltipStyle;

		/**
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
			_tooltip = value;
		}

		
		
		//--------------------------------------
		//
		// 序列的渲染节点
		//
		//--------------------------------------

		/**
		 */
		private var _itemRenders:Array;

		public function get itemRenders():Array
		{
			return _itemRenders;
		}

		public function set itemRenders(value:Array):void
		{
			_itemRenders = value;
		}

		/**
		 * 创建渲染节点并初始化其属性；
		 * 
		 * 渲染节点的颜色默认为数据节点的颜色，其他属性均继承于序列的渲染器配置属性；
		 */
		protected function createItemRenders():void
		{
			itemRenders = [];
			for each (var item:SeriesDataItemVO in dataItemVOs)
				initItemRender(itemRender, item);
		}
		
		/**
		 * 构造节点渲染器
		 */		
		protected function get itemRender():ItemRenderBace
		{
			return null;
		}
		
		/**
		 */		
		protected function initItemRender(itemRender:ItemRenderBace, item:SeriesDataItemVO):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = valueLabel;
			updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		protected function updateLabelDisplay(item:ItemRenderBace):void
		{
			item.valueLabel.layout = this.labelDisplay;
			
			if (labelDisplay == LabelStyle.NONE)
				item.valueLabel.enable = false;
			else
				item.valueLabel.enable = true;
			
			if (label)
				item.valueLabel.text.value = label;
		}
		
		/**
		 */		
		public function set label(value:String):void
		{
			_label = value;
		}
		
		/**
		 */		
		private var _label:String;
		
		/**
		 */		
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * 更新数据节点的布局信息；
		 */		
		protected function layoutDataItems():void
		{
			for each (var item:SeriesDataItemVO in dataItemVOs)
			{
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xValue);
				item.dataItemY = item.y = (verticalAxis.valueToY(item.yValue));
			}
		}
		
		/**
		 * 默认为系统统一配置，如果颜色没有配置则采用节点颜色，序列可以单独定义
		 * 
		 * 渲染节点的显示与尺寸；
		 */		
		private var _dataRender:DataRenderStyle;

		/**
		 */
		public function get dataRender():DataRenderStyle
		{
			return _dataRender;
		}

		/**
		 * @private
		 */
		public function set dataRender(value:DataRenderStyle):void
		{
			_dataRender = value;
		}
		
		
		
		
		//-----------------------------------------------------
		//
		// 坐标轴数据
		//
		//-----------------------------------------------------

		/**
		 */		
		public function updateAxisValueRange():void
		{
			horizontalAxis.pushValues(horizontalValues.concat());
			verticalAxis.pushValues(verticalValues.concat());
		}
		
		/**
		 */		
		private var _horizontalValues:Vector.<Object>;

		public function get horizontalValues():Vector.<Object>
		{
			return _horizontalValues;
		}

		public function set horizontalValues(value:Vector.<Object>):void
		{
			_horizontalValues = value;
		}

		/**
		 */		
		private var _verticalValues:Vector.<Object>;

		public function get verticalValues():Vector.<Object>
		{
			return _verticalValues;
		}

		public function set verticalValues(value:Vector.<Object>):void
		{
			_verticalValues = value;
		}

		
		
		
		
		///--------------------------------------------
		//
		//  图表属性
		//
		//--------------------------------------------
		
		/**
		 */		
		private var _seriesWidth:Number;
		
		public function get seriesWidth():Number
		{
			return _seriesWidth;
		}
		
		public function set seriesWidth(v:Number):void
		{
			if (_seriesWidth != v)
			{
				_seriesWidth = v;
				ifSizeChanged = true;
			}
		}
		
		/**
		 */
		private var _seriesHeight:Number;
		
		public function get seriesHeight():Number
		{
			return _seriesHeight;
		}
		
		public function set seriesHeight(v:Number):void
		{
			if (_seriesHeight != v)
			{
				_seriesHeight = v;
				ifSizeChanged = true;
			}
		}
		
		/**
		 * Container chart draw object.
		 */
		protected var seriesChartContainer:Sprite;
		
		/**
		 */		
		private var _horizontalAxis:AxisBase;

		public function get horizontalAxis():AxisBase
		{
			return _horizontalAxis;
		}

		/**
		 *  individual aixs.
		 */
		public function set horizontalAxis(v:AxisBase):void
		{
			_horizontalAxis = v;
			_horizontalAxis.direction = AxisBase.HORIZONTAL_AXIS;
			_horizontalAxis.metaData = this;
		}

		/**
		 */
		private var _verticalAxis:AxisBase;

		public function get verticalAxis():AxisBase
		{
			return _verticalAxis;
		}

		public function set verticalAxis(v:AxisBase):void
		{
			_verticalAxis = v;
			_verticalAxis.direction = AxisBase.VERTICAL_AXIX;
			_verticalAxis.metaData = this;
		}
		
		/**
		 * 横轴ID 
		 */		
		private var _hAixs:String;

		/**
		 */
		public function get xAxis():String
		{
			return _hAixs;
		}

		/**
		 * @private
		 */
		public function set xAxis(value:String):void
		{
			_hAixs = value;
		}
		
		/**
		 * 纵轴ID 
		 */		
		private var _vAxis:String;

		public function get yAxis():String
		{
			return _vAxis;
		}

		public function set yAxis(value:String):void
		{
			_vAxis = value;
		}
		
		/**
		 */
		private var _dataProvider:XML;

		public function get dataProvider():XML
		{
			return _dataProvider;
		}

		/**
		 *  Individual data.
		 */
		public function set dataProvider(value:XML):void
		{
			if (value != _dataProvider)
			{
				_dataProvider = value;
				initData();
				ifDataChanged = true;
			}
		}
		
		/**
		 *  创建节点和坐标轴的数据
		 */
		protected function initData():void
		{
			var seriesDataItem:SeriesDataItemVO
			dataItemVOs = new Vector.<SeriesDataItemVO>
			horizontalValues = new Vector.<Object>;
			verticalValues = new Vector.<Object>;
			
			for each (var item:XML in dataProvider.children())
			{
				seriesDataItem = this.seriesDataItem;
				
				seriesDataItem.metaData = new Object;
				XMLVOMapper.pushXMLDataToVO(item, seriesDataItem.metaData);//将XML转化为对象
				
				seriesDataItem.xValue = seriesDataItem.metaData[xField]; // xValue.
				seriesDataItem.yValue = seriesDataItem.metaData[yField]; // yValue.
				
				seriesDataItem.xLabel = horizontalAxis.getXLabel(seriesDataItem.xValue);
				seriesDataItem.yLabel = verticalAxis.getYLabel(seriesDataItem.yValue);
				seriesDataItem.xDisplayName = horizontalAxis.displayName;
				seriesDataItem.yDisplayName = verticalAxis.displayName;
				
				setItemColor(seriesDataItem.metaData, seriesDataItem);
				seriesDataItem.seriesName = seriesName;
				
				XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
					['xValue', 'yValue', 'xLabel', 'yLabel', 'xDisplayName', 'yDisplayName', 'seriesName', 'color']);
				
				horizontalValues.push(seriesDataItem.xValue);
				verticalValues.push(seriesDataItem.yValue);
				dataItemVOs.push(seriesDataItem);
			}
		}
		
		/**
		 * 构建数据节点VO
		 */		
		protected function get seriesDataItem():SeriesDataItemVO
		{
			return new SeriesDataItemVO();
		}
		
		/**
		 */		
		public function get legendData():Vector.<LegendVO>
		{
			var legendVOes:Vector.<LegendVO> = new Vector.<LegendVO>;
			var legendVO:LegendVO;
			
			if (this.seriesCount > 1)
			{
				legendVO = new LegendVO();
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, seriesLegendOverHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, seriesLegendOutHandler, false, 0, true);
				
				legendVO.addEventListener(LegendEvent.HIDE_LEGEND, seriesHideLegendHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.SHOW_LEGEND, seriesShowLegendHandler, false, 0, true);
				
				legendVO.metaData = this;
				legendVOes.reverse();
				legendVOes.push(legendVO);
			}
			else
			{
				for each(var item:SeriesDataItemVO in dataItemVOs)	
				{
					legendVO = new LegendVO();
					legendVO.metaData = item; // 用于精确控制节点的状态
					legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, itemRenderOverHandler, false, 0, true);
					legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, itemRenderOutHandler, false, 0, true);
					legendVO.addEventListener(LegendEvent.HIDE_LEGEND, itemRenderHideHandler, false, 0, true);
					legendVO.addEventListener(LegendEvent.SHOW_LEGEND, itemRenderShowHandler, false, 0, true);
					legendVOes.push(legendVO);
				}
			}
			
			return legendVOes;
		}
		
		
		//----------------------------------------------------
		//
		// 图例控制，  序列控制；
		//
		//----------------------------------------------------
		
		public function seriesHideLegendHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataItemVO in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_HIDE));
				
			if (stateControl)		
				this.stateControl.toHide();
			
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
		
		/**
		 */		
		public function seriesShowLegendHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataItemVO in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_SHOW));
				
			if (stateControl)		
				this.stateControl.toShow();
			
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
		
		/**
		 */		
		public function seriesLegendOverHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataItemVO in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OVER));
			
			if (stateControl)
				this.stateControl.toHover();
		}
		
		/**
		 */		
		public function seriesLegendOutHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataItemVO in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OUT));
				
			if (stateControl)	
				this.stateControl.toNormal();
		}
		
		
		
		
		
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
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
		
		private function itemRenderShowHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_SHOW));
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
											   
		/**
		 */		
		private var overFilter:Array;
		
		
		
		
		
		
		//-----------------------------------------------------
		//
		// 颜色控制
		//
		//-----------------------------------------------------
		
		/**
		 */		
		protected function setItemColor(sourceDataItem:Object, seriesDataItem:SeriesDataItemVO):void
		{
			if (sourceDataItem[colorField])// Special color of item. 
				seriesDataItem.color = StyleManager.getUintColor(sourceDataItem[colorField]);
			else if (singleColor || this.seriesCount > 1)
				seriesDataItem.color = uint(color);// The whole series color.
			else
				seriesDataItem.color = chartColorManager.chartColor;
		}
		
		/**
		 */		
		protected var chartColorManager:ChartColorManager;
		
		/**
		 * 单序列时，柱体是否采用同一种颜色； 
		 */		
		private var _singleColor:Object = true;
		
		public function get singleColor():Object
		{
			return _singleColor;
		}
		
		public function set singleColor(value:Object):void
		{
			_singleColor = XMLVOMapper.boolean(value);
		}
		
		/**
		 * Series items of this series.
		 */
		private var _dataItemVOs:Vector.<SeriesDataItemVO>;

		public function get dataItemVOs():Vector.<SeriesDataItemVO>
		{
			return _dataItemVOs;
		}

		public function set dataItemVOs(v:Vector.<SeriesDataItemVO>):void
		{
			_dataItemVOs = v;
		}

		/**
		 *
		 */
		private var _xField:String;

		public function get xField():String
		{
			return _xField;
		}

		public function set xField(v:String):void
		{
			_xField = v;
		}

		/**
		 */
		private var _yField:String

		public function get yField():String
		{
			return _yField;
		}

		public function set yField(v:String):void
		{
			_yField = v;
		}
		
		/**
		 *  数值显示的字段名称, xLabel, yLabel, zLabel(气泡图会用到),  percentLabel(百分比堆积图);
		 * 
		 *  默认此样式定义的是 ‘外数值标签’ 样式， 对应的还有 ‘内数值标签’;
		 */		
		private var _valueLabel:LabelStyle// = '${yLabel}';
		
		/**
		 * 数值显示 
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
			if (value)
				_valueLabel = value;
		}
		
		/**
		 * 内部数值标签， 柱状图, 堆积图， 气泡图会用到；
		 * 
		 * 趋势图仅 外部数值标签 可以起效； 柱状图通过layout参数设置启用那种；
		 * 
		 * 堆积图默认两种都启用； 气泡图仅启用内数值标签；
		 */		
		protected var _innerValueLabel:LabelStyle;

		/**
		 */
		public function get innerValueLabel():LabelStyle
		{
			return _innerValueLabel;
		}

		/**
		 * @private
		 */
		public function set innerValueLabel(value:LabelStyle):void
		{
			_innerValueLabel = value;
		}
		
		/**
		 * 用于 toolTip 的取值方向判断， 正 或者 负;
		 */		
		protected var value:String = 'yValue';
		
		/**
		 */		
		private var _colorField:String;

		public function get colorField():String
		{
			return _colorField;
		}

		public function set colorField(value:String):void
		{
			_colorField = value;
		}

		/**
		 */
		private var _color:Object;

		public function get color():Object
		{
			return _color;
		}

		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}

		/**
		 */
		private var _seriesName:String = "";

		public function get seriesName():String
		{
			return _seriesName;
		}

		public function set seriesName(value:String):void
		{
			_seriesName = value;
		}

		/**
		 * the count of series in the chart
		 */
		private var _seriesCount:uint = 0;

		public function get seriesCount():uint
		{
			return _seriesCount;
		}

		public function set seriesCount(value:uint):void
		{
			_seriesCount = value;
		}

		/**
		 * index of item
		 */
		protected var _itemIndex:uint;

		public function get seriesIndex():uint
		{
			return _itemIndex;
		}

		public function set seriesIndex(value:uint):void
		{
			_itemIndex = value;
		}

		/**
		 * series type
		 */
		private var _seriesType:String = "";

		public function get seriesType():String
		{
			return _seriesType;
		}

		public function set seriesType(value:String):void
		{
			_seriesType = value;
		}
		
		/**
		 *  特效标识(默认特效打开)
		 **/
		protected var _animation:Object;
		
		/**
		 */		
		public function get animation():Object
		{
			return _animation;
		}
		
		/**
		 */		
		public function set animation(value:Object):void
		{
			_animation = Object;
		}
	}
}