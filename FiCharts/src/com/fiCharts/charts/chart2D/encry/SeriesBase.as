package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.DataRenderStyle;
	import com.fiCharts.charts.chart2D.core.series.DataIndexOffseter;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.chart2D.core.series.SeriesDirectionControl;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.charts.legend.view.LegendEvent;
	import com.fiCharts.ui.toolTips.ToolTipHolder;
	import com.fiCharts.ui.toolTips.TooltipDataItem;
	import com.fiCharts.ui.toolTips.TooltipStyle;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.IEditableObject;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 序列的基类
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
		
		
		
		//--------------------------------------------------------------------------
		//
		//  
		// 渲染模式的状态控制，有经典模式和数据缩放两种模式， 每种序列需重写自己的一对渲染
		// 
		// 模式；
		//
		//---------------------------------------------------------------------------
		
		
		/**
		 */		
		public function toClassicPattern():void
		{
			if (curRenderPattern)
				curRenderPattern.toClassicPattern();
			else
				curRenderPattern = getClassicPattern();
			
			if (simpleDataRender && simpleDataRender.parent)
			{
				this.removeChild(simpleDataRender)
				simpleDataRender = null;
			}
			
			if (tipItem)
			{
				tipItem.distory();
				tipItem = null;
			}
		}
		
		/**
		 */		
		public function toSimplePattern():void
		{
			if (curRenderPattern)
				curRenderPattern.toSimplePattern();
			else
				curRenderPattern = getSimplePattern();
			
			if (simpleDataRender == null)
			{
				simpleDataRender = new Shape;
				simpleDataRender.graphics.clear();
				
				var style:Style = dataRender.states.normal as Style;
				StyleManager.drawCircle(simpleDataRender, style, this);
				this.addChild(simpleDataRender);
			}
			
			if (tipItem == null)
			{
				tipItem = new TooltipDataItem;
				tipItem.style = this.tooltip;
			}
		}
		
		/**
		 */		
		protected function getClassicPattern():ISeriesRenderPattern
		{
			return null;
		}
		
		/**
		 */		
		protected function getSimplePattern():ISeriesRenderPattern
		{
			return null;
		}
		
		/**
		 */		
		public var curRenderPattern:ISeriesRenderPattern;
		public var classicPattern:ISeriesRenderPattern;
		public var simplePattern:ISeriesRenderPattern;
		
		
		
		
		//--------------------------------------------------------
		//
		//
		// 数据缩放下的信息提示控制
		//
		//
		//-------------------------------------------------------
		
		/**
		 */		
		private function hideTips(evt:DataResizeEvent):void
		{
			simpleDataRender.visible = false;
		}
		
		/**
		 */		
		private function updateTipByData(evt:DataResizeEvent):void
		{
			var i:uint;
			var curData:Number = 0;
			var minDis:Number = evt.end - evt.start;
			var index:int = - 1; 
			
			for (i = dataOffsetter.minIndex; i <= dataOffsetter.maxIndex; i ++)
			{
				curData = horValues[i];
				
				if (curData > evt.start && curData < evt.end)
				{
					if (Math.abs(evt.data - curData) < minDis)
					{
						minDis = Math.abs(evt.data - curData);
						index = i;
					}
				}
			}
			
			if (index >= 0)
			{
				var item:SeriesDataItemVO = this.dataItemVOs[index];
				simpleDataRender.x = item.x;
				simpleDataRender.y = item.y;
				
				if (simpleDataRender.visible == false)
					simpleDataRender.visible = true;
				
				tipItem.metaData = item.metaData;
			}
		}
		
		/**
		 */		
		private var simpleDataRender:Shape;
		
		/**
		 * 数据缩放时的信息提示数据节点， 每个序列仅有一个节点
		 */		
		public var tipItem:TooltipDataItem;
		
		
		//---------------------------------------------------------------------
		//
		//  数据缩放控制， 序列数据缩放因数据类型而不同， 反映到不同类型的坐标轴上
		//
		// 一种是按照节点位置，一种是按照数据范围
		//
		//----------------------------------------------------------------------
		
		/**
		 */		
		protected function dataResizedByIndex(evt:DataResizeEvent):void
		{
			evt.stopPropagation();
			
			dataOffsetter.minIndex = evt.start;
			dataOffsetter.maxIndex = evt.end;
			dataOffsetter.offSet(0, maxDataItemIndex);
			
			scrollYValues = this.verValues.slice(dataOffsetter.minIndex, dataOffsetter.maxIndex + 1);
		}
		
		/**
		 * 
		 * 前后各多延伸一个节点
		 * 
		 */		
		protected function dataResizedByRange(evt:DataResizeEvent):void
		{
			evt.stopPropagation();
			
			dataOffsetter.minIndex = 0;
			dataOffsetter.maxIndex = maxDataItemIndex;
			
			dataOffsetter.getDataIndexRange(evt.start, evt.end, horValues);
			dataOffsetter.offSet(0, maxDataItemIndex);
			
			scrollYValues = this.verValues.slice(dataOffsetter.minIndex, dataOffsetter.maxIndex + 1);
		}
		
		/**
		 * 用于为动态渲染的Y轴提供数据
		 */		
		public var scrollYValues:Vector.<Object>;
		
		/**
		 * 这些值是数据筛分时构建， 用来辅助划定数值序号范围；
		 */		
		private var horValues:Array = [];
		
		/**
		 * 这些值是数据筛分时构建， 用来辅助刷新Y轴数据
		 */		
		private var verValues:Vector.<Object> = new Vector.<Object>;
		
		/**
		 */		
		private function renderScaledData(evt:DataResizeEvent):void
		{
			this.curRenderPattern.renderScaledData();
		}
		
		/**
		 */		
		public var dataOffsetter:DataIndexOffseter = new DataIndexOffseter;
		
		/**
		 *  创建渲染节点并渲染图表序列；
		 * 
		 *  创建渲染节点  > 布局数据节点  > 渲染图表  > 渲染 渲染节点
		 */		
		public function render():void
		{
			this.curRenderPattern.render();
		}
		
		/**
		 * 图表图形绘制
		 */
		protected function draw():void
		{
			// To override.
		}
		
		/**
		 */		
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
		public var canvas:Sprite = new Sprite;

		
		//---------------------------------------------
		//
		// 数值分布特征
		//
		//---------------------------------------------
		
		public function applyDataFeature():void
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
		public function get baseLine():Number
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

		/**
		 */ 
		public var ifDataChanged:Boolean = false;
		
		/**
		 */		
		public var ifSizeChanged:Boolean = false;

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
		public function createItemRenders():void
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
			
			initTipString(item, getXTip(item), 
				getYTip(item), getZTip(item), itemRender.isHorizontal);
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 * 给数据节点的元数据设置tooltip字段值
		 */		
		protected function initTipString(itemVO:SeriesDataItemVO, 
									   xTipLabel:String, yTipLabel:String, zTipLabel:String,
									   isHorizontal:Boolean = false):void
		{
			var fullTip:String;
			var xTip:String = xTipLabel;
			var yTip:String = yTipLabel;
			var zTip:String = zTipLabel;
			
			if (itemVO.xDisplayName && itemVO.xDisplayName != '')
				xTip = itemVO.xDisplayName + ':' + xTip;
			
			if (itemVO.yDisplayName && itemVO.yDisplayName != '')
				yTip = itemVO.yDisplayName + ':' + yTip;
			
			if (isHorizontal)
				fullTip = yTip + '<br>' + xTip + zTip;
			else
				fullTip = xTip + '<br>' + yTip + zTip;
			
			if (itemVO.seriesName && itemVO.seriesName != '')
				fullTip = itemVO.seriesName + '<br>' + fullTip;
			
			itemVO.metaData.tooltip = fullTip;
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
		public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			var item:SeriesDataItemVO;
			var i:uint = 0;
			for (i = startIndex; i <= endIndex; i +=step)
			{
				item = dataItemVOs[i];
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xVerifyValue, i);
				item.dataItemY = item.y = (verticalAxis.valueToY(item.yVerifyValue));
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
		 * 仅为数据缩放/滚动过程中的Y轴动态更新提供数据
		 */		
		public function updateYAxisValueForScroll():void
		{
			verticalAxis.pushYData(scrollYValues);
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
		protected var _horizontalAxis:AxisBase;

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
			
			_horizontalAxis.addEventListener(DataResizeEvent.RATE_SERIES_DATA_ITEMS, rateDataItems, false, 0, true);
			
			_horizontalAxis.addEventListener(DataResizeEvent.GET_SERIES_DATA_INDEX_BY_INDEXS, dataResizedByIndex, false, 0, true);
			_horizontalAxis.addEventListener(DataResizeEvent.GET_SERIES_DATA_INDEX_RANGE_BY_DATA, dataResizedByRange, false, 0, true);
			
			_horizontalAxis.addEventListener(DataResizeEvent.RENDER_SERIES, renderScaledData, false, 0, true);
			
			_horizontalAxis.addEventListener(DataResizeEvent.UPDATE_TOOLTIPS_BY_DATA, updateTipByData, false, 0, true);
			_horizontalAxis.addEventListener(DataResizeEvent.HIDE_TIPS, hideTips, false, 0, true);
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
		
		
		
		
		
		
		
		//------------------------------------------------------------------
		//
		//
		// 序列数据的处理
		//
		//
		//-----------------------------------------------------------------
		
		/**
		 */
		private var _dataProvider:Vector.<Object>;

		public function get dataProvider():Vector.<Object>
		{
			return _dataProvider;
		}

		/**
		 *  Individual data.
		 */
		public function set dataProvider(value:Vector.<Object>):void
		{
			if (value != _dataProvider)
			{
				_dataProvider = value;
				preInitData();
				ifDataChanged = true;
			}
		}
		
		/**
		 *  初始化坐标轴数据, 预初始化节点数据， 
		 * 
		 *  节点数据的完全初始化需等到正式渲染序列之前
		 * 
		 *  因为大数据下， 序列的渲染都是采集部分数据动态渲染，
		 * 
		 *  不能所有数据节点一次全部创建并渲染, 太耗性能
		 */
		protected function preInitData():void
		{
			PerformaceTest.start("预构建数据节点");
			
			var seriesDataItem:SeriesDataItemVO;
			var item:Object;
			var i:uint = 0;
			
			dataItemVOs = new Vector.<SeriesDataItemVO>
			horizontalValues = new Vector.<Object>;
			verticalValues = new Vector.<Object>;
			sourceDataItems = new Vector.<SeriesDataItemVO>;
			
			for each (item in dataProvider)
			{
				seriesDataItem = this.seriesDataItem;
				
				seriesDataItem.xValue = item[xField]; // xValue.
				seriesDataItem.yValue = item[yField]; // yValue.
				setItemColor(item, seriesDataItem);
				
				seriesDataItem.xVerifyValue = this.horizontalAxis.getVerifyData(seriesDataItem.xValue);
				seriesDataItem.yVerifyValue = this.verticalAxis.getVerifyData(seriesDataItem.yValue);
				
				horizontalValues[i] = seriesDataItem.xVerifyValue;
				verticalValues[i] = seriesDataItem.yVerifyValue;
				dataItemVOs[i] = sourceDataItems[i] = seriesDataItem;
				
				i ++;
			}
			
			updateMaxIndex();
			
			PerformaceTest.end("预构建数据节点");
		}
		
		/**
		 */		
		public function initData():void
		{
			var seriesDataItem:SeriesDataItemVO;
			for each (seriesDataItem in dataItemVOs)
				initDataItem(seriesDataItem);
		}
		
		/**
		 * 
		 * 从原始数据节点中筛分一部分用于渲染， 如果节点
		 * 
		 * 未被完全初始化，就完成其初始化
		 * 
		 */		
		private function rateDataItems(evt:DataResizeEvent):void
		{
			PerformaceTest.start("构建数据节点");
			
			this.dataItemVOs.length = this.horValues.length = verValues.length = 0;
			
			var sourceDataLen:uint = this.sourceDataItems.length;
			var i:uint, j:uint = 0;
			var dataItem:SeriesDataItemVO;
			
			for (i = 0; i < sourceDataLen; i += evt.step)
			{
				if (i + evt.step >= sourceDataLen)
					dataItem = dataItemVOs[j] = sourceDataItems[sourceDataLen - 1];
				else
					dataItem = dataItemVOs[j] = sourceDataItems[i];
				
				if (dataItem.metaData == null)
					initDataItem(dataItem);
				
				horValues[j] = this.horizontalValues[i];
				verValues[j] = this.verticalValues[i];
				
				j ++;
			}
			
			updateMaxIndex();
			
			PerformaceTest.end("构建数据节点");
		}
		
		/**
		 */		
		protected function initDataItem(seriesDataItem:SeriesDataItemVO):void
		{
			seriesDataItem.metaData = {};
			
			seriesDataItem.xLabel = horizontalAxis.getXLabel(seriesDataItem.xVerifyValue);
			seriesDataItem.yLabel = verticalAxis.getYLabel(seriesDataItem.yVerifyValue);
			
			seriesDataItem.xDisplayName = horizontalAxis.displayName;
			seriesDataItem.yDisplayName = verticalAxis.displayName;
			
			seriesDataItem.seriesName = seriesName;
			
			XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
				['xValue', 'yValue', 'xLabel', 'yLabel', 'xDisplayName', 'yDisplayName', 'seriesName', 'color']);
			
			this.initTipString(seriesDataItem, getXTip(seriesDataItem), getYTip(seriesDataItem),
				getZTip(seriesDataItem), false); 
		}
		
		/**
		 */		
		protected function getXTip(item:SeriesDataItemVO):String
		{
			return item.xLabel;
		}
		
		/**
		 */		
		protected function getYTip(item:SeriesDataItemVO):String
		{
			return item.yLabel;
		}
		
		/**
		 */		
		protected function getZTip(item:SeriesDataItemVO):String
		{
			return "";
		}
		
		/**
		 */		
		protected function updateMaxIndex():void
		{
			dataOffsetter.maxIndex = maxDataItemIndex = dataItemVOs.length - 1;
		}
		
		/**
		 */		
		protected var sourceDataItems:Vector.<SeriesDataItemVO>;
		
		/**
		 * 把节点总数存下来，后继节点渲染会频繁用于计算；
		 */		
		public var maxDataItemIndex:uint = 0;
		
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