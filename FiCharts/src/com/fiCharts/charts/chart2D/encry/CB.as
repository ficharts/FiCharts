package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.area2D.AreaSeries2D;
	import com.fiCharts.charts.chart2D.bar.BarSeries;
	import com.fiCharts.charts.chart2D.bar.stack.StackedBarSeries;
	import com.fiCharts.charts.chart2D.bar.stack.StackedPercentBarSeries;
	import com.fiCharts.charts.chart2D.bubble.BubbleSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedColumnSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedPercentColumnSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedSeries;
	import com.fiCharts.charts.chart2D.core.Chart2DStyleTemplate;
	import com.fiCharts.charts.chart2D.core.TitleBox;
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.AxisContianer;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.backgound.ChartBGUI;
	import com.fiCharts.charts.chart2D.core.backgound.GridFieldUI;
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.PointRenderBace;
	import com.fiCharts.charts.chart2D.core.model.AxisModel;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.Series;
	import com.fiCharts.charts.chart2D.core.series.ChartCanvas;
	import com.fiCharts.charts.chart2D.line.LineSeries;
	import com.fiCharts.charts.chart2D.marker.MarkerSeries;
	import com.fiCharts.charts.common.IChart;
	import com.fiCharts.charts.legend.LegendPanel;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.ui.toolTips.ToolTipsManager;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.system.GC;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 */
	[Event(name="legendDataChanged", type = "com.fiCharts.charts.chart2D.core.events.FiChartsEvent")]
	[Event(name="ready", type = "com.fiCharts.charts.chart2D.core.events.FiChartsEvent")]
	[Event(name="itemClicked", type = "com.fiCharts.charts.chart2D.core.events.FiChartsEvent")]
	[Event(name="rendered", type = "com.fiCharts.charts.chart2D.core.events.FiChartsEvent")]
	
	/**
	 * ChartBase
	 */	
	public class CB extends Sprite implements IChart
	{
		/**
		 *  Constructor.
		 */
		public function CB()
		{
			super();
			
			// Class list.
			
			LineSeries;
			AreaSeries2D;
			MarkerSeries; 
			BubbleSeries;
			
			//ColumnSeries2D;
			StackedColumnSeries;
			StackedPercentColumnSeries;
			StackedSeries;	
			
			BarSeries;
			StackedBarSeries;
			StackedPercentBarSeries;
			
			init();
		}
		
		/**
		 */		
		public function ifDataScalable():Boolean
		{
			return chartModel.zoom.enable;
		}
		
		/**
		 */		
		public function setDataScalable(value:Boolean):void
		{
			chartModel.zoom.enable = value;
		}
		
		/**
		 * 
		 * 动态进行数据缩放的对外接口, 用于Flash/AIR等类型的项目中， web用配置文件方式处理数据缩放
		 * 
		 */		
		public function scaleData(startValue:Object, endValue:Object):void
		{
			this.currentPattern.scaleData(startValue, endValue);
		}
		
		
		
		//----------------------------------
		//
		// 用户定制的配置文件
		//
		//-----------------------------------
		
		private var _customConfig:XML;

		/**
		 */
		public function get customConfig():XML
		{
			return _customConfig;
		}

		/**
		 * @private
		 */
		public function set customConfig(value:XML):void
		{
			_customConfig = value;
		}
		
		/**
		 * 默认如果存在用户配置文件则后继的配置都要继承预先配置文件；
		 * 
		 * 也可以设置忽略预先配置文件；
		 */		
		private var _usePreConfig:Number = 1;

		/**
		 */
		public function get ifCustomConfig():Number
		{
			return _usePreConfig;
		}

		/**
		 * @private
		 */
		public function set ifCustomConfig(value:Number):void
		{
			_usePreConfig = value;
		}
		
		
		
		//---------------------------
		//
		// 数据处理
		//
		//----------------------------
		
		public function get configXML():XML
		{
			return chartProxy.configXML;
		}
		
		/**
		 * 默认配置包含完整信息，既有配置又有数据，也可以只有配置，
		 * 
		 * 数据用dataXML接口传输， 两个接口配合使用既可以实现数据分离；
		 */		
		public function set configXML(value:XML):void
		{
			chartProxy.configXML = value;
			
			this.initLegend();
			this.title.fresh();
			
			chartProxy.setChartModel(XMLVOMapper.extendFrom(
				chartProxy.currentStyleXML.copy(), configXML.copy()));
			
			if (value.hasOwnProperty('data') && value.data.children().length())
				this.dataXML = XML(value.data.toXMLString());
		}
		
		/**
		 */
		private var _dataXML:XML;

		/**
		 */
		public function set dataXML(value:XML):void
		{
			_dataXML = value;

			if (dataVOes)
			{
				dataVOes.length = 0;
				dataVOes = null;
			}
			
			ifDataChanged = true;
		}
		
		/**
		 */		
		public function get dataXML():XML
		{
			return _dataXML;
		}

		/**
		 */		
		private var ifDataChanged:Boolean = false;
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		// 	Render the chart.
		//
		//-----------------------------------------------

		/**
		 *  
		 */
		public function render():void
		{
			if (isRendering)
				return;
			
			if (configXML && (this.dataXML || dataVOes) && chartModel.series.length)
			{
				// 为避免重复渲染，这里做了严格的限制条件，
				if(this.ifSizeChanged || this.ifDataChanged 
					|| chartModel.axis.changed || chartModel.series.changed) 
				{
					isRendering = true;
					
					preConfig();
					preLayout();
					checkRender();
					
					ifSizeChanged = false;
				}
			}
		}
		
		/**
		 * 防止渲染的过程中， render函数被频繁调用导致的癫狂状况
		 */		
		private var isRendering:Boolean = false;
		
		/**
		 * 
		 * 坐标轴，标题，图例渲染后才有尺寸，图表外围的间距才能确定下来，从而图表区域才能确定
		 * 
		 * 所以要先渲染这些元素，直到周围间距被调节的合适了才正式渲染序列，进行位置摆放和后继的工作
		 * 
		 */		
		private function checkRender():void
		{
			this.vAxisLabelOffset = this.hAxisLabelOffset = 0;
			preRender();
			this.ifNeedRefectorLayout = false;
			
			// 这里不停的调整图表区域的尺寸，直到合适才正式
			// 渲染序列，结束图表渲染
			if(isLayoutUpdated())
			{
				checkRender();
				return;
			}
			
			coreRender();
			renderEnd();
		}
		
		/**
		 * 预渲染项，其尺寸会影响图表的尺寸布局
		 */		
		private function preRender():void
		{
			renderTitle();
			renderAxis();
			renderLegend();
		}
		
		/**
		 */		
		private function coreRender():void
		{
			renderSeries();
			renderBG();
			
			drawMask(chartMask);
			chartCanvas.drawBG(this.sizeX, this.sizeY);
			
			layoutElementsPos(); 
		}
		
		/**
		 */		
		private function renderEnd():void
		{
			this.chartModel.axis.changed = chartModel.series.changed = ifDataChanged = isRendering = false;
			
			this.currentPattern.renderEnd();
			
			GC.run();
		}
		
		/**
		 * 设置坐标轴序列关系, 定义序列，坐标轴(图例的数据)
		 */		
		private function preConfig():void
		{
			if (currentPattern == null)
				currentPattern = new ClassicPattern(this);
			
			currentPattern.initPattern();
			
			configSeriesAxis();
			configSeriesAndLegendData();
			updateAxisData();
			
			if (chartModel.axis.changed || chartModel.series.changed || ifDataChanged)
				this.currentPattern.preConfig();
		}
		
		/**
		 */
		private function renderBG():void
		{
			chartModel.chartBG.width = chartWidth;
			chartModel.chartBG.height = chartHeight;
			
			chartModel.gridField.width = sizeX;
			chartModel.gridField.height = sizeY;
			
			gridField.render(this.hAxises[0].ticks, this.vAxises[0].ticks, chartModel.gridField);
			chartBG.render(chartModel.chartBG);
		}
		
		/**
		 */		
		internal function renderVGrid():void
		{
			gridField.drawVGidLine(this.vAxises[0].ticks, chartModel.gridField);
		}

		/**
		 * 配置驱动下的Label渲染时可能 sizeX 还未被设定，所以此时不渲染标题
		 */		
		private function renderTitle():void
		{
			if (this.sizeX >= 0)
			{
				title.boxWidth = this.sizeX;
				title.render();
				title.x = this.originX;
				
				title.y = (topSpace - this.topAxisContainer.height - title.boxHeight) * .5;
			}
		}
		
		/**
		 * 
		 */		
		private function renderLegend():void
		{
			if (legendPanel && chartModel.legend.enable)
			{
				legendPanel.panelWidth = this.chartWidth - legendPanel.style.hMargin * 2;
				legendPanel.render();
			}
		}
		
		/**
		 *  Draw axisLabels.
		 */
		private function renderAxis():void
		{
			var axis:AxisBase;
			var temOffset:Number = 0;
			
			if (this.ifSizeChanged || this.chartModel.axis.changed)
			{
				for each (axis in hAxises)
				{
					axis.size = sizeX;
					axis.x = originX;
				}
				
				for each (axis in this.vAxises)
				{
					axis.size = sizeY;
					axis.y = originY;
				}
			}
			
			this.bottomAxisContainer.size = this.topAxisContainer.size = 0;
			for each (axis in hAxises)
			{
				axis.beforeRender();
				axis.renderHoriticalAxis();
				
				temOffset = axis.temUintSize;
				
				// 防止坐标轴边沿label无法完全显示，这个值会作用在左右间距上，给边缘label留够空间
				if (temOffset != hAxisLabelOffset)
					hAxisLabelOffset = temOffset;
				
				if (axis.position == 'bottom')
				{
					axis.y = originY + bottomAxisContainer.size;
					bottomAxisContainer.size += axis.height;
				}
				else
				{
					axis.y = originY - this.sizeY - topAxisContainer.size;
					topAxisContainer.size += axis.height;
				}
				
			}
			
			// 坐标轴渲染后才会具有尺寸， 所以布局会在渲染后重新调整；
			this.leftAxisContainer.size = this.rightAxisContainer.size = 0;
			for each (axis in this.vAxises)
			{
				axis.beforeRender();
				axis.renderVerticalAxis();
				
				temOffset = axis.minUintSize;
				if (temOffset != vAxisLabelOffset)
					vAxisLabelOffset = temOffset;
				
				if (axis.position == 'left')
				{
					axis.x = originX - leftAxisContainer.size;
					leftAxisContainer.size += axis.width;
				}
				else
				{
					axis.x = originX + sizeX + rightAxisContainer.size;
					rightAxisContainer.size += axis.width;
				}
			}
		}
		
		/**
		 * 坐标轴的的设定尺寸与实际尺寸穿在相对偏差 ， 因Label引起；
		 */		
		private var hAxisLabelOffset:Number = 0;
		
		/**
		 * 
		 */		
		private var vAxisLabelOffset:Number = 0;
		
		/**
		 */
		protected function renderSeries():void
		{
			var seriesItem:SB;
			var itemRender:PointRenderBace;
			
			for each (seriesItem in series)
			{
				seriesItem.seriesWidth = sizeX;
				seriesItem.seriesHeight = sizeY;
			}
			
			currentPattern.renderSeries();
			
			if (chartModel.series.changed || ifDataChanged)
			{
				this.currentPattern.getItemRenderFromSereis();
			}
			
			currentPattern.renderItemRenderAndDrawValueLabels();
		}
		

		
		//---------------------------------
		//
		// 尺寸与布局的计算
		//
		//---------------------------------
		
		/**
		 * 计算原始尺寸和位置基点
		 */		
		private function preLayout():void
		{
			leftSpace = temLeftSpace;
			rightSpace = temRightSpace;
			
			topSpace = temTopSpace;
			bottomSpace = temBottomSpace;
			
			updateXYSize();
		}
		
		/**
		 * 设置各个元素的位置
		 */
		private function layoutElementsPos():void
		{
			this.chartMask.x = chartCanvas.x = gridField.x = originX;
			this.chartMask.y = chartCanvas.y = originY; 
				
			gridField.y = topY;
			layoutLegendPanel();
		}
		
		/**
		 */		
		private function drawMask(mask:Shape):void
		{
			mask.graphics.clear();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0, 0, this.sizeX, - this.sizeY);
		}
		
		/**
		 */
		private function layoutLegendPanel():void
		{
			var bottomGutter:Number = bottomSpace;
			
			if (this.bottomAxisContainer.numChildren)
				bottomGutter = bottomSpace - bottomAxisContainer.height;
			
			if (this.legendPanel)
			{
				legendPanel.x = (this.chartWidth - legendPanel.width) / 2;
				legendPanel.y = this.chartHeight - bottomGutter / 2 - legendPanel.height / 2 //- legendPanel.style.vMargin
			}
		}
		
		/**
		 * 
		 * 只要动态计算的边距大于现有值，就采用动态边距
		 * 
		 * 最后还要根据坐标轴布局方式调节一下边距，以便坐标轴边缘
		 * 
		 * 字段能够完全显示下
		 */		
		private function isLayoutUpdated():Boolean
		{
			if (temBottomSpace > bottomSpace) 
			{
				bottomSpace = temBottomSpace;
				ifNeedRefectorLayout = true;
			}
			
			if (temTopSpace > topSpace)
			{
				topSpace = temTopSpace;
				ifNeedRefectorLayout = true;
			}
			
			if (temLeftSpace > leftSpace) 
			{
				leftSpace = temLeftSpace;
				ifNeedRefectorLayout = true;
			}
			
			if (temRightSpace > rightSpace) 
			{
				rightSpace = temRightSpace;
				ifNeedRefectorLayout = true;
			}
			
			
			// 仅左侧有坐标轴, 右侧要和谐一下间距
			if (leftAxisContainer.numChildren && !rightAxisContainer.numChildren)
			{
				if (rightSpace < hAxisLabelOffset / 2)
				{
					rightSpace = hAxisLabelOffset / 2;
					ifNeedRefectorLayout = true;
				}
			}
				
			//仅右侧有坐标轴，左侧要和谐一下间距
			if (!leftAxisContainer.numChildren && rightAxisContainer.numChildren)
			{
				if (leftSpace < hAxisLabelOffset / 2)
				{
					leftSpace = hAxisLabelOffset / 2;
					ifNeedRefectorLayout = true;
				}
			}
			
			//仅底部有坐标轴
			if (bottomAxisContainer.numChildren && !topAxisContainer.numChildren)
			{
				if(topSpace < vAxisLabelOffset / 2)
				{
					topSpace = vAxisLabelOffset / 2; 
					ifNeedRefectorLayout = true;
				}
			}
				
			//仅顶部有坐标轴
			if (!bottomAxisContainer.numChildren && topAxisContainer.numChildren)
			{
				if (bottomSpace < vAxisLabelOffset / 2)
				{
					bottomSpace = vAxisLabelOffset / 2;
					ifNeedRefectorLayout = true;
				}
			}
			
			if (ifNeedRefectorLayout)
				updateXYSize();
			
			return this.ifNeedRefectorLayout;
		}
		
		/**
		 */		
		private function updateXYSize():void
		{
			sizeX = chartWidth - this.leftSpace - this.rightSpace;
			sizeY = chartHeight - this.bottomSpace - this.topSpace;
		}
		
		/**
		 */		
		private function get temBottomSpace():Number
		{
			var result:Number = chartModel.chartBG.paddingBottom;
			result =  this.bottomAxisContainer.height + result;
			
			if (legendPanel && chartModel.legend && chartModel.legend.enable)
				result = result + this.legendPanel.height + legendPanel.style.vMargin * 2;
			
			return result;
		}
		
		/**
		 */		
		private function get temTopSpace():Number
		{
			var tem:Number = chartModel.chartBG.paddingTop + this.topAxisContainer.height + this.title.boxHeight;
			
			if (tem < chartModel.minTopPadding)
				tem = chartModel.minTopPadding;
			
			return tem;
		}
		
		/**
		 */		
		private function get temLeftSpace():Number
		{
			return leftAxisContainer.width + chartModel.chartBG.paddingLeft;
		}
		
		/**
		 */		
		private function get temRightSpace():Number
		{
			return this.rightAxisContainer.width + chartModel.chartBG.paddingRight;
		}
		
		/**
		 */		
		private var leftSpace:Number = 0;
		private var rightSpace:Number = 0;
		private var bottomSpace:Number = 0;
		private var _topSpace:Number = 0;

		/**
		 */		
		public function get topSpace():Number
		{
			return _topSpace;
		}

		public function set topSpace(value:Number):void
		{
			_topSpace = value;
		}

		
		/**
		 */
		private var sizeX:Number;
		private var sizeY:Number;
		
		/**
		 */		
		private var _chartWidth:Number = 100;
		private var _chartHeight:Number = 100;
		
		/**
		 */		
		private var ifNeedRefectorLayout:Boolean = false;
		
		/**
		 */		
		public function get originX():Number
		{
			return leftSpace;
		}
		
		public function get originY():Number
		{
			return chartHeight - bottomSpace
		}
		
		public function get topY():Number
		{
			return topSpace;
		}
		
		/**
		 */
		public function resize(w:Number, h:Number):void
		{
			chartWidth = w;
			chartHeight = h;
			
			ifSizeChanged = true;
		}
		
		/**
		 */
		public function get chartWidth():Number
		{
			return _chartWidth;
		}
		
		public function set chartWidth(value:Number):void
		{
			if (_chartWidth != value)
			{
				_chartWidth = value;
				ifSizeChanged = true;
			}
		}
		
		/**
		 * 
		 */		
		private var ifSizeChanged:Boolean = false;
		
		/**
		 */
		public function get chartHeight():Number
		{
			return _chartHeight;
		}
		
		/**
		 */		
		public function set chartHeight(value:Number):void
		{
			if (_chartHeight != value)
			{
				_chartHeight = value;
				ifSizeChanged = true;				
			}
		}
		
		
		
		
		//---------------------------------
		//
		//  创建
		//
		//---------------------------------

		
		/**
		 */		
		private function startAxisCreateHandler(value:Object):void
		{
			while (bottomAxisContainer.numChildren)
				bottomAxisContainer.removeChildAt(0);
			
			while (topAxisContainer.numChildren)
				topAxisContainer.removeChildAt(0);
			
			while (leftAxisContainer.numChildren)
				leftAxisContainer.removeChildAt(0);
			
			while (rightAxisContainer.numChildren)
				rightAxisContainer.removeChildAt(0);
		}
		
		/**
		 */		
		private function createHoriAxisBottomHandler(value:AxisBase):void
		{
			addAxis(value, bottomAxisContainer, AxisBase.HORIZONTAL_AXIS);
		}
		
		/**
		 */		
		private function createHoriAxisTopHandler(value:AxisBase):void
		{
			addAxis(value, topAxisContainer, AxisBase.HORIZONTAL_AXIS);
		}
		
		/**
		 */		
		private function createVertiAxisLeftHandler(value:AxisBase):void
		{
			addAxis(value, leftAxisContainer, AxisBase.VERTICAL_AXIX);
		}
		
		/**
		 */		
		private function createVertiAxisRightHandler(value:AxisBase):void
		{
			addAxis(value, rightAxisContainer, AxisBase.VERTICAL_AXIX);
		}
		
		/**
		 */		
		private function addAxis(axis:AxisBase, viewContainer:Sprite, direction:String):void
		{
			axis.dataFormatter = chartModel.dataFormatter;
			axis.direction = direction;
			viewContainer.addChild(axis);
		}

		/**
		 * 创建序列
		 */		
		private function createSeriesHandler(value:Vector.<SB>):void
		{
			this.chartCanvas.addSeries(value);
		}
		
		/**
		 * 当仅有一个轴时直接返回， 只有在多个轴的情况下
		 * 
		 * 才根据ID来检索；
		 */		
		private function getAxisByID(id:String, axises:Vector.<AxisBase>):AxisBase
		{
			if (axises.length == 1)
				return axises[0];
			
			for each (var aixs:AxisBase in axises)
			{
				if (aixs.id == id)
					return aixs;
			}
			
			return null;
		}
		
		/**
		 * 配置序列坐标轴;
		 */
		protected function configSeriesAxis():void
		{
			var seriesItem:SB;
			if (chartModel.axis.changed && chartModel.series.changed)
			{
				for each (seriesItem in series)
				{
					seriesItem.horizontalAxis = getAxisByID(seriesItem.xAxis, this.hAxises);
					seriesItem.verticalAxis = getAxisByID(seriesItem.yAxis, this.vAxises);
					
					if (seriesItem is BubbleSeries)
					{
						if (bubbleRadiusAxis == null)
						{
							bubbleRadiusAxis = new LinearAxis;  
							bubbleRadiusAxis.autoAdjust = false;
							bubbleRadiusAxis.dataFormatter = chartModel.dataFormatter;
						}
								
						(seriesItem as BubbleSeries).radiusAxis = this.bubbleRadiusAxis;
					}
				}
				
			}
			
			if (chartModel.axis.changed)
				this.currentPattern.configSeriesAxis(hAxises[0]);
			
		}
		
		/**
		 * 序列或者原始数据改变时更新序列数据， 更新图例数据；
		 */		
		private function configSeriesAndLegendData():void
		{
			var legends:Vector.<LegendVO> = new Vector.<LegendVO>();
			
			if (chartModel.series.changed || ifDataChanged)
			{
				if (dataVOes == null)
				{
					dataVOes = new Vector.<Object>;
					var dataVO:Object;
					for each (var item:XML in dataXML.children())
					{
						dataVO = new Object;
						XMLVOMapper.pushXMLDataToVO(item, dataVO);
						dataVOes.push(dataVO);
					}
				}
				
				for each (var seriesItem:SB in series)  
				{
					seriesItem.configed(this.chartModel.series.colorMananger);// 图表整体配置完毕， 可以开始子序列的定义了；					
					seriesItem.dataProvider = dataVOes;
					
					if (chartModel.legend.enable)
						legends = legends.concat(seriesItem.legendData);
				}
				
				if (legendPanel && chartModel.legend.enable)
					legendPanel.legendData = legends;
			}
		}
		
		/**
		 */		
		private var _dataVOes:Vector.<Object>;
		
		/**
		 */
		public function get dataVOes():Vector.<Object>
		{
			return _dataVOes;
		}
		
		/**
		 * @private
		 */
		public function set dataVOes(value:Vector.<Object>):void
		{
			_dataVOes = value;
			
			ifDataChanged = true;
		}
		
		/**
		 */		
		private function updateAxisData():void
		{
			if (chartModel.axis.changed || chartModel.series.changed || ifDataChanged)
			{
				var axis:AxisBase;
				
				// 准备更新数据
				for each (axis in this.hAxises)
					axis.redyToUpdateData();
				
				for each (axis in this.vAxises)
					axis.redyToUpdateData();
				
				if (bubbleRadiusAxis)
					bubbleRadiusAxis.redyToUpdateData();
					
				//数据更新后同步刷新坐标轴的数据；
				for each (var seriesVO:SB in series)
					seriesVO.updateAxisValueRange();
				
				// 数据更新完毕；	
				for each (axis in this.hAxises)
					axis.dataUpdated();
				
				for each (axis in this.vAxises)
					axis.dataUpdated();
				
				if (bubbleRadiusAxis)
					bubbleRadiusAxis.dataUpdated();
			}
		}

		
		//----------------------------------------
		//
		// 坐标轴及序列
		//
		//----------------------------------------
		
		/**
		 */		
		private var bubbleRadiusAxis:LinearAxis;
		
		/**
		 */
		public function get series():Vector.<SB>
		{
			return this.chartModel.series.items;
		}
		
		
		
		//---------------------------------------
		//
		// 样式配置
		//
		//---------------------------------------
		
		/**
		 * 设置和改变样式表；
		 */		
		public function setStyle(newStyle:String):void
		{
			if (chartProxy.currentStyleName == newStyle) return;
			chartProxy.setCurStyleTemplate(newStyle);
			
			if (configXML)
			{
				chartProxy.setChartModel(XMLVOMapper.extendFrom(
					chartProxy.currentStyleXML.copy(), configXML.copy()));
			}
		}
		
		/**
		 * 完全由用户自定义的样式表；
		 */		
		public function setCustomStyle(style:XML):void
		{
			chartProxy.currentStyleName = Chart2DStyleTemplate.CUSTOM;
			chartProxy.currentStyleXML = style;
			
			if (configXML)
				chartProxy.setChartModel(XMLVOMapper.extendFrom(
					chartProxy.currentStyleXML.copy(), configXML.copy()));
		}
			 
		/**
		 */		
		private function updateLegendStyleHandler(value:Object):void
		{
			if (legendPanel)
				this.legendPanel.setStyle(value as LegendStyle);
		}	
		
		/**
		 */		
		private function updateTitleStyleHandler(value:Object):void
		{
			title.updateStyle(chartModel.title, chartModel.subTitle);
			this.renderTitle();
		}
		
		
		
		//----------------------------------
		//
		// 图表状态， 经典模式和数据缩放模式控制
		//
		//----------------------------------
		
		
		/**
		 */		
		private function toZoomPatternHandler(evt:Event):void
		{
			if (this.currentPattern == null)
				currentPattern = new ZoomPattern(this);
			else
				currentPattern.toZoomPattern();
		}
		
		/**
		 */		
		private function toClassicPatternHandler(evt:Event):void
		{
			if (this.currentPattern == null)
				currentPattern = new ClassicPattern(this);
			else
				currentPattern.toClassicPattern();
		}
		
		/**
		 */		
		private function updateValueLabelHandler(evt:ItemRenderEvent):void
		{
			currentPattern.updateValueLabelHandler(evt);
		}
		
		
		
		//----------------------------------
		//
		// 初始化
		//
		//----------------------------------
		
		/**
		 */
		protected function init():void
		{
			initContainers();
			createBG();
			addChild(title);
			
			toolTipManager = new ToolTipsManager(this);
			
			chartProxy = new CP();
			initListeners();
			
			// 设置当前默认的样式配置
			chartProxy.setCurStyleTemplate();
			chartProxy.setChartModel(chartProxy.currentStyleXML);
		}
		
		/**
		 */		
		private function initLegend():void
		{
			if (legendPanel)
			{
				this.removeChild(legendPanel)
				legendPanel = null;				
			}
			
			legendPanel =  new LegendPanel();
			addChild(legendPanel);
		}
		
		/**
		 */		
		private var legendPanel:LegendPanel;
		
		/**
		 */		
		private var toolTipManager:ToolTipsManager;
		
		/**
		 */		
		private function fullScreenHandler(evt:Event):void
		{
			if (chartModel.fullScreen)
			{
				if (stage.displayState == StageDisplayState.NORMAL)
					stage.displayState = StageDisplayState.FULL_SCREEN;
				else
					stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 */		
		private function createBG():void
		{
			chartBG = new ChartBGUI();
			chartBG.doubleClickEnabled = true;
			chartBG.addEventListener(MouseEvent.DOUBLE_CLICK, fullScreenHandler, false, 0, true);
			bgContainer.addChild(chartBG);
			
			gridField = new GridFieldUI();
			bgContainer.addChild(gridField);
		}
		
		/**
		 */
		private function initContainers():void
		{
			bgContainer = new Sprite();
			addChild(bgContainer);
			
			bottomAxisContainer = new AxisContianer;
			addChild(bottomAxisContainer);
			
			topAxisContainer = new AxisContianer;
			addChild(topAxisContainer);
			
			leftAxisContainer = new AxisContianer;
			addChild(leftAxisContainer);
			
			rightAxisContainer = new AxisContianer;
			addChild(rightAxisContainer);
			
			chartCanvas = new ChartCanvas;
			chartCanvas.doubleClickEnabled = true;
			chartCanvas.addEventListener(MouseEvent.DOUBLE_CLICK, fullScreenHandler, false, 0, true);
			addChild(chartCanvas);
			
			chartMask = new Shape;
			addChild(chartMask);
			
			chartCanvas.mask = chartMask;
		}
		
		/**
		 */
		private function initListeners():void
		{
			XMLVOLib.addCreationHandler(AxisModel.START_AXIS_CREATION, startAxisCreateHandler);
			XMLVOLib.addCreationHandler(AxisModel.CREATE_LEFT_AXIS, createVertiAxisLeftHandler);
			XMLVOLib.addCreationHandler(AxisModel.CREATE_RIGHT_AXIS, createVertiAxisRightHandler);
			XMLVOLib.addCreationHandler(AxisModel.CREATE_TOP_AXIS, createHoriAxisTopHandler);
			XMLVOLib.addCreationHandler(AxisModel.CREATE_BOTTOM_AXIS, createHoriAxisBottomHandler);
			XMLVOLib.addCreationHandler(Series.CHART2D_SERIES_CREATED, createSeriesHandler);
			
			XMLVOLib.addCreationHandler(Chart2DModel.UPDATE_TITLE_STYLE, updateTitleStyleHandler);
			XMLVOLib.addCreationHandler(Chart2DModel.UPDATE_LEGEND_STYLE, updateLegendStyleHandler);
			
			XMLVOLib.addCreationHandler(CB.TO_CLASSIC_PATTERN, toClassicPatternHandler);
			XMLVOLib.addCreationHandler(CB.TO_ZOOM_PATTERN, toZoomPatternHandler);
			
			this.addEventListener(ItemRenderEvent.UPDATE_VALUE_LABEL, updateValueLabelHandler, false, 0, true);
		}
		
		/**
		 * @return 
		 */		
		internal function get hAxises():Vector.<AxisBase>
		{
			return this.chartModel.axis.horizontalAxis;
		}
		
		/**
		 */		
		internal function get vAxises():Vector.<AxisBase>
		{
			return this.chartModel.axis.verticalAxis;
		}
		
		/**
		 */		
		internal function get chartModel():Chart2DModel
		{
			return chartProxy.chartModel;
		}
		
		/**
		 */
		protected var chartProxy:CP;
		
		/**  
		 * 网格/序列背景
		 */
		internal var gridField:GridFieldUI;
		
		/**
		 * 图表背景 
		 */		
		protected var chartBG:ChartBGUI;
		
		/**
		 * 标题
		 */
		private var title:TitleBox = new TitleBox;
		
		/**
		 * 容器
		 */
		private var bottomAxisContainer:AxisContianer;
		private var topAxisContainer:AxisContianer;
		private var leftAxisContainer:AxisContianer;
		private var rightAxisContainer:AxisContianer;
		
		/**
		 */		
		private var bgContainer:Sprite;
		internal var chartCanvas:ChartCanvas;
		internal var chartMask:Shape;
		
		/**
		 * 
		 */		
		internal function set currentPattern(value:IChartPattern):void
		{
			_currentPatern = value;
		}
		
		/**
		 */		
		internal function get currentPattern():IChartPattern
		{
			return _currentPatern;
		}
		
		/**
		 */		
		private var _currentPatern:IChartPattern;
		
		/**
		 */		
		internal var classicPattern:IChartPattern;
		internal var zoomPattern:IChartPattern;
		
		/**
		 */		
		public static const TO_CLASSIC_PATTERN:String = 'toClassicState';
		public static const TO_ZOOM_PATTERN:String = 'toZoomState';
		
	}
}