package com.fiCharts.charts.chart3D.model
{
	import com.fiCharts.charts.chart3D.ManagerFor3D;
	import com.fiCharts.charts.chart3D.baseClasses.IItemRenderVO;
	import com.fiCharts.charts.chart3D.baseClasses.IMultiSeriesRegister;
	import com.fiCharts.charts.chart3D.baseClasses.ISeries;
	import com.fiCharts.charts.chart3D.event.Chart3DEvent;
	import com.fiCharts.charts.chart3D.model.vo.axis.AxisBaseVO;
	import com.fiCharts.charts.chart3D.model.vo.axis.FieldAxisVO;
	import com.fiCharts.charts.chart3D.model.vo.axis.LinearAxisVO;
	import com.fiCharts.charts.chart3D.model.vo.bg.BackGroundVO;
	import com.fiCharts.charts.chart3D.model.vo.bg.XYBackgoundAxisVO;
	import com.fiCharts.charts.chart3D.model.vo.bg.YZBackgroundAixsVO;
	import com.fiCharts.charts.chart3D.model.vo.series.ColumnSeriesVO;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.events.EventDispatcher;

	/**
	 */	
	public class Chart3DProxy extends EventDispatcher implements IMultiSeriesRegister
	{
		/**
		 */		
		public function Chart3DProxy()
		{
			FieldAxisVO;
			LinearAxisVO;
			ColumnSeriesVO;
		}
		
		//------------------------------------------
		//
		// 数据标识；
		//
		//-------------------------------------------
		
		
		/**
		 */
		public function get ifAxisVOChanged():Boolean
		{
			return _ifAxisVOChanged;
		}
		
		/**
		 * @private
		 */
		public function set ifAxisVOChanged(value:Boolean):void
		{
			_ifAxisVOChanged = value;
		}
		
		private var _ifAxisVOChanged:Boolean = false;
		
		
		private var _ifTitleChanged:Boolean = false;

		public function get ifTitleChanged():Boolean
		{
			return _ifTitleChanged;
		}

		public function set ifTitleChanged(value:Boolean):void
		{
			_ifTitleChanged = value;
		}
		
		/**
		 * 总体标识图表的配置定义是否发生改变；
		 */		
		private var ifConfigChanged:Boolean = false;
		
		/**
		 */		
		private var ifDataChanged:Boolean = false;
		
		/**
		 */		
		private var ifSeriesVOChanged:Boolean = false;
		
		private var _ifColumnRendersChanged:Boolean = false;

		public function get ifColumnRendersChanged():Boolean
		{
			return _ifColumnRendersChanged;
		}

		public function set ifColumnRendersChanged(value:Boolean):void
		{
			_ifColumnRendersChanged = value;
		}
		
		
		
		
		
		//-------------------------------------------
		//
		// 配置及数据；
		//
		//-------------------------------------------
		
		/**
		 */		
		private var _configVO:Chart3DConfig;
		
		public function get configVO():Chart3DConfig
		{
			return _configVO;
		}
		
		public function set configVO(value:Chart3DConfig):void
		{
			_configVO = value;
		}
		
		/**
		 */		
		private var _configXML:XML;

		public function get configXML():XML
		{
			return _configXML;
		}

		/**
		 * 配置文件改变时，配置VO重新创建，需要同步更新所有配置.
		 */		
		public function set configXML(value:XML):void
		{
			if (_configXML != value)
			{
				/*if (_configXML)
					System.disposeXML(_configXML);*/
						
				_configXML = value;
				ifConfigChanged = true;
				
				this.configVO = new Chart3DConfig;
				if (_configXML != defaultConfigXML)
				{
					applyConfig(defaultConfigXML);
					ifConfigChanged = true;
				}
				
				applyConfig(_configXML);
				
				this.dispatchEvent(new Chart3DEvent(Chart3DEvent.CONFIG_CHANGED));
			}
		}
		
		private var _dataFormatter:ChartDataFormatter = new ChartDataFormatter();

		/**
		 */
		public function get dataFormatter():ChartDataFormatter
		{
			return _dataFormatter;
		}

		/**
		 * @private
		 */
		public function set dataFormatter(value:ChartDataFormatter):void
		{
			_dataFormatter = value;
		}

		
		/**
		 */		
		private var _dataProvider:Vector.<Object>;
		
		public function get dataProvider():Vector.<Object>
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Vector.<Object>):void
		{
			if(_dataProvider != value)
			{
				_dataProvider = value;
				ifDataChanged = true;
			}
		}
		
		
		
		
		//------------------------------------------------------------
		//
		// 序列的创建；
		//
		//------------------------------------------------------------
		
		/**
		 */		
		private function createSeries(seriesXML:XMLList):void
		{
			var series:ISeries;
			columnSeries = new Vector.<ISeries>();
			for each (var item:XML in seriesXML.children())
			{
				if (!item.hasOwnProperty("@verticalAxisID"))
					item.@axisID = "left";
				
				series = ClassUtil.getObjectByClassPath(seriesCreationXML[item.name()].@classPath) as ISeries;
				XMLVOMapper.transformNodeAttributes(item.attributes(), series, item.name().toString());
				series.zSize = this.innerSizeZ;
				addSeriesVO(series);
			}
			
			ifSeriesVOChanged = true;
		}
		
		/**
		 */		
		public function get columnSeriesAmount():int
		{
			return columnSeries.length;
		}
		
		/**
		 * @param series
		 */		
		public function addSeriesVO(value:ISeries):void
		{
			value.register(this, value);
		}
		
		/**
		 */		
		public function removeSeriesVO(value:ISeries):void
		{
			value.unRegister(this, value);
		}
		
		/**
		 */		
		public function addColumnSeries(series:ISeries):void
		{
			columnSeries.push(series);
		}
		
		public function removeColumnSeries(series:ISeries):void
		{
			columnSeries.splice(columnSeries.indexOf(series), 1);
		}
		
		/**
		 */		
		private var columnSeries:Vector.<ISeries> = new Vector.<ISeries>();
		
		
		/**
		 */		
		private var _series:Vector.<ISeries> = new Vector.<ISeries>();
		
		public function get series():Vector.<ISeries> 
		{
			return _series;
		}
		
		public function set series(value:Vector.<ISeries>):void
		{
			_series = value;
		}
		
		
		
		//----------------------------------------------------------
		//
		// 坐标轴的创建及配置；
		//
		//----------------------------------------------------------
		
		
		/**
		 * Convert xml to axis.
		 */		
		private function createAxis(configXML:XML):void
		{
			verticalAxisLeft = verticalAxisRight = null;
			 
			var axisConfigXML:XMLList;
			if (configXML.hasOwnProperty("axis")) 
				axisConfigXML = configXML.axis;
			else
				axisConfigXML = defaultConfigXML.axis;// default axis config.
			
			//Default horizontal axis type, if user did not set.
			if (!XML(axisConfigXML.horizontal).hasOwnProperty("type"))
				axisConfigXML.horizontal.@type = "field";
			
			
			// Defualt vertical axis type, if user did not set.
			if (!XML(axisConfigXML.horizontal).hasOwnProperty("labelLayout"))
				axisConfigXML.horizontal.@labelLayout = "wrap";
			
			horizontalAxis = getAxis(axisConfigXML.horizontal);
			horizontalAxis.labelOffSet = configVO.bgCubeThikness;
			
			if (axisConfigXML.vertical.length() == 1)
			{
				// Defualt vertical axis type, if user did not set.
				if (!XML(axisConfigXML.vertical).hasOwnProperty("type"))
					axisConfigXML.vertical.@type = "linear";
				
				if (!XML(axisConfigXML.vertical).hasOwnProperty("id"))
					axisConfigXML.vertical.@id = "left";
				
				verticalAxisLeft = getAxis(axisConfigXML.vertical);
			}
			else
			{
				// Defualt vertical axis type, if user did not set.
				if (!XML(axisConfigXML.vertical[0]).hasOwnProperty("type"))
					axisConfigXML.vertical[0].@type = "linear";
				
				if (!XML(axisConfigXML.vertical[0]).hasOwnProperty("id"))
					axisConfigXML.vertical[0].@id = "left";
				
				if (!XML(axisConfigXML.vertical[1]).hasOwnProperty("type"))
					axisConfigXML.vertical[1].@type = "linear";
				
				if (!XML(axisConfigXML.vertical[1]).hasOwnProperty("id"))
					axisConfigXML.vertical[1].@id = "right";
				
				verticalAxisLeft = getAxis(axisConfigXML.vertical.(@id =='left'));
				verticalAxisRight = getAxis(axisConfigXML.vertical.(@id =='right'));
			}
					
			// 配置数据格式器；
			verticalAxisLeft.dataFormatter = horizontalAxis.dataFormatter = this.dataFormatter;
			
			if (verticalAxisRight)
				verticalAxisRight.dataFormatter = dataFormatter;
			
			updateAxisLocation();
		}
		
		
		
		/**
		 */		
		private function getAxis(xml:XMLList):AxisBaseVO
		{
			var reusltAxis:AxisBaseVO;
			
			var classPath:String = axisCreationXML[xml.@type].@classPath;
			reusltAxis = ClassUtil.getObjectByClassPath(classPath) as AxisBaseVO;
			XMLVOMapper.fuck(xml, reusltAxis);
			
			return reusltAxis;
		}
		
		/**
		 * 设置坐标轴的位置；
		 */		
		private function updateAxisLocation():void
		{
			horizontalAxis.location3D.x = 0;
			horizontalAxis.location3D.y = configVO.bgCubeThikness;
			horizontalAxis.location3D.z = 0;
			horizontalAxis.location2D = ManagerFor3D.transform3DTo2DPoint(horizontalAxis.location3D);
			
			verticalAxisLeft.location3D.x = 0
			verticalAxisLeft.location3D.y = configVO.bgCubeThikness;
			verticalAxisLeft.location3D.z = 0;
			verticalAxisLeft.location2D = ManagerFor3D.transform3DTo2DPoint(verticalAxisLeft.location3D);
		}
		
		/**
		 */		
		private var _horizontalAxis:AxisBaseVO;
		public function get horizontalAxis():AxisBaseVO
		{
			return _horizontalAxis;
		}
		
		/**
		 *  individual aixs.
		 * @param v
		 */
		public function set horizontalAxis(value:AxisBaseVO):void
		{
			if (_horizontalAxis != value)
			{
				_horizontalAxis = value;
				_horizontalAxis.direction = AxisBaseVO.HORIZONTAL_AXIS;
				ifAxisVOChanged = true;
			}
		}
		
		/**
		 */
		private var _verticalAxisLeft:AxisBaseVO;
		public function get verticalAxisLeft():AxisBaseVO
		{
			return _verticalAxisLeft;
		}
		
		public function set verticalAxisLeft(value:AxisBaseVO):void
		{
			if (value && _verticalAxisLeft != value)
			{
				_verticalAxisLeft = value;
				_verticalAxisLeft.direction = AxisBaseVO.VERTICAL_AXIX;
				ifAxisVOChanged = true;
			}
		}
		
		private var _verticalAxisRight:AxisBaseVO;

		public function get verticalAxisRight():AxisBaseVO
		{
			return _verticalAxisRight;
		}

		public function set verticalAxisRight(value:AxisBaseVO):void
		{
			if (value && _verticalAxisRight != value)
			{
				_verticalAxisRight = value;
				_verticalAxisRight.direction = AxisBaseVO.VERTICAL_AXIX;
				ifAxisVOChanged = true;
			}
		}
		
		
		
		//------------------------------------------------------
		//
		// 图表模型更新；
		//
		//------------------------------------------------------
		
		
		/**
		 * 刷新图表序列及背景的数据；
		 */		
		public function updateModel():void
		{
			configAxisForSeries();
			configSeriesesColorAndIIndex();
			configSeriesData();
			
			//以下的内容主要因尺寸的改变更新；
			updateAxisData();
			updateModelSize();
			updateBackgroundDrawInfo();
			
			if(ifDataChanged)
				ifDataChanged = false;
			
			if(ifSeriesVOChanged)
				ifSeriesVOChanged = false;
		}
		
		/**
		 * 更新坐标轴，数据节点及渲染节点的 布局信息；
		 */		
		private function updateModelSize():void
		{
			// 将节点的数值转化为坐标位置，用以决定柱体的尺寸,然后更新柱体渲染模型的尺寸信息； 
			for each (var seriesVO:ISeries in columnSeries)
				seriesVO.transformValueToSize();// value to size.
		}
			
		/**
		 * Set series index information and color.
		 * 
		 * 设置序列的颜色及序号， 序号用以决定柱体的位置及宽度；
		 */		
		private function configSeriesesColorAndIIndex():void
		{
			if (ifSeriesVOChanged)
			{
				var length:int = columnSeries.length;
				var colorManager:ChartColorManager
				
				if (length > 1)
					colorManager = new ChartColorManager();// set series item colors.
				
				for (var i:uint = 0; i < length; i ++)
				{
					columnSeries[i].indexOfThisSeries = i;
					columnSeries[i].amountOfThisSeries = length;
					
					if (colorManager && !columnSeries[i].color)// TODO
						columnSeries[i].color = colorManager.chartColor.toString(16);
				}
			}
		}
		
		/**
		 *  Set axis's data for series. 
		 * 
		 *  为序列设置坐标轴;
		 */		
		private function configAxisForSeries():void
		{
			for each (var seriesVO:ISeries in columnSeries)
			{
				if (ifSeriesVOChanged || ifAxisVOChanged)
				{
					seriesVO.horizontalAxis = horizontalAxis;
					
					if (seriesVO.verticalAxisID == "right" && this.verticalAxisRight)
					{
						seriesVO.verticalAxis = verticalAxisRight;
					}
					else
					{
						seriesVO.verticalAxis = verticalAxisLeft;
					}
				}
			}
			
			//当存在两个纵轴时，每个纵轴的标签颜色与其对应的序列色一致；
			if (this.columnSeries.length > 1 && this.verticalAxisRight)
			{
				for each (seriesVO in columnSeries)
				{
					seriesVO.verticalAxis.labelColor =  seriesVO.color;
				}
			}
		}
		
		/**
		 * 设置坐标轴的取值并生成标签；
		 */		
		private function updateAxisData():void                           
		{
			if(this.ifDataChanged || this.ifAxisVOChanged)
			{
				this.horizontalAxis.redyToUpdateData();
				this.verticalAxisLeft.redyToUpdateData();
				
				if (this.verticalAxisRight)
					verticalAxisRight.redyToUpdateData();
				
				//数据更新后同步刷新坐标轴的数据；
				for each (var seriesVO:ISeries in columnSeries)
					seriesVO.updateAxisValueRange();
					
				this.horizontalAxis.dataUpdated();
				this.verticalAxisLeft.dataUpdated();
				
				if (this.verticalAxisRight)
					verticalAxisRight.dataUpdated();
			}
			
			//坐标轴尺寸设置
			horizontalAxis.size = configVO.sizeX;
			horizontalAxis.generateAxisLabelVO();
			horizontalAxis.layoutHorizontalLabels();
			
			verticalAxisLeft.size = innerSizeY;
			verticalAxisLeft.generateAxisLabelVO();
			verticalAxisLeft.layoutVerticalLabels();
			
			if (this.verticalAxisRight)
			{
				verticalAxisRight.location3D.x = configVO.sizeX;
				verticalAxisRight.location3D.y = configVO.bgCubeThikness;
				verticalAxisRight.location3D.z = configVO.sizeZ - configVO.bgCubeThikness;
				verticalAxisRight.location2D = ManagerFor3D.transform3DTo2DPoint(verticalAxisRight.location3D);
				
				verticalAxisRight.size = innerSizeY;
				verticalAxisRight.generateAxisLabelVO();
				verticalAxisRight.layoutVerticalLabels();
			}
		}
		
		/**
		 * 设置序列的数据，创建柱体渲染模型；
		 */		
		private function configSeriesData():void
		{
			var seriesVO:ISeries;
			
			// 序列或者数据源改变时更新渲染模型；
			if (ifSeriesVOChanged || ifDataChanged) 
			{
				setSeriesCoreData();
				_seriesItemRenders = new Vector.<IItemRenderVO>();
				
				for each (seriesVO in columnSeries)
				{
					seriesVO.createItemRenders();
					_seriesItemRenders = _seriesItemRenders.concat(seriesVO.columnRenderVOes);
				}
				
				ifColumnRendersChanged = true;
			}
		}
		
		/**
		 *  数据或序列改变时，更新序列的节点对象；并将数据同步到坐标轴；
		 */		
		private function setSeriesCoreData():void
		{
			var seriesVO:ISeries
			var seriesDataItem:SeriesDataItemVO;
			var sourceDataItem:Object;
			var colorManager:ChartColorManager; 
			
			for each (seriesVO in columnSeries)
			{
				seriesVO.dataProvider = dataProvider;// Set data source.
				
				// Create series items data by data source (data provider).
				seriesVO.seriesItemVOes = new Vector.<SeriesDataItemVO>();// New collection to put VOes.
				colorManager = new ChartColorManager();// set series item colors.
				
				for each (sourceDataItem in seriesVO.dataProvider)
				{
					seriesDataItem = new SeriesDataItemVO();
					seriesDataItem.metaData = sourceDataItem; // source data object.
					seriesDataItem.seriesName = seriesVO.seriesName;
					seriesDataItem.xValue = sourceDataItem[ seriesVO.xField ];// xValue.
					seriesDataItem.yValue = sourceDataItem[ seriesVO.yField ];// yValue.
					seriesDataItem.xLabel = seriesVO.generateXLabelForItem(seriesDataItem.xValue);
					seriesDataItem.yLabel = seriesVO.generateYLabelForItem(seriesDataItem.yValue);
					
					setItemColor(sourceDataItem, seriesDataItem, seriesVO, colorManager);// Color.
					seriesVO.seriesItemVOes.push(seriesDataItem);
				}
			}
		}
		
		/**
		 * 可以为序列中的每一个节点指定颜色值，如果是多序列的话，节点默认取序列的颜色；
		 * 如果是单序列的话, 默认自动分派每个节点的颜色；
		 */		
		private function setItemColor(dataItem:Object, seriesItem:com.fiCharts.charts.common.SeriesDataItemVO, 
									  seriesVO:ISeries, colorManager:ChartColorManager):void
		{
			if (dataItem[seriesVO.colorField])// Special color of item. 
			{
				seriesItem.color = StyleManager.getUintColor(dataItem[seriesVO.colorField]);
			}
			else 
			{
				if (seriesVO.color)
					seriesItem.color = uint(seriesVO.color);// The whole series color.
				else
					seriesItem.color = colorManager.chartColor;
			}
		}
		
		/**
		 * 所有序列的节点渲染器 
		 */		
		private var _seriesItemRenders:Vector.<IItemRenderVO>;
		
		/**
		 */
		public function get seriesItemRenders():Vector.<IItemRenderVO>
		{
			return _seriesItemRenders;
		}
		
		/**
		 * @private
		 */
		public function set seriesItemRenders(value:Vector.<IItemRenderVO>):void
		{
			_seriesItemRenders = value;
		}
		
		
		
		 
		
		//------------------------------------------------
		//
		// 背景
		//
		//------------------------------------------------
		
		/**
		 */		
		private function configBackgroundData():void
		{
			// Location.
			backgroundVO.location3D.x = 0;
			backgroundVO.location3D.y = 0;
			backgroundVO.location3D.z = 0;
			backgroundVO.location2D = ManagerFor3D.transform3DTo2DPoint(backgroundVO.location3D);
			
			// Bottom cube.
			backgroundVO.bottomCube.location3D.x = 0;
			backgroundVO.bottomCube.location3D.y = 0;
			backgroundVO.bottomCube.location3D.z = 0;
			backgroundVO.bottomCube.location2D = 
				ManagerFor3D.transform3DTo2DPoint(backgroundVO.bottomCube.location3D);
			
			backgroundVO.bottomCube.zSize = innerSizeZ;
			backgroundVO.bottomCube.ySize = configVO.bgCubeThikness;
			backgroundVO.bottomCube.color = StyleManager.transformColor(uint(configVO.bgCubeFillColor),
				.8, .8, .8);
			
			// Back cube.
			backgroundVO.backCube.location3D.x = 0;
			backgroundVO.backCube.location3D.y = configVO.bgCubeThikness;
			backgroundVO.backCube.location3D.z = innerSizeZ;
			backgroundVO.backCube.location2D = 
				ManagerFor3D.transform3DTo2DPoint(backgroundVO.backCube.location3D);
			
			backgroundVO.backCube.zSize = configVO.bgCubeThikness;
			backgroundVO.backCube.color = uint(configVO.bgCubeFillColor);
			
			// 背景网格
			backgroundAxisVO.location3D.x = 0;
			backgroundAxisVO.location3D.y = configVO.bgCubeThikness;
			backgroundAxisVO.location3D.z = innerSizeZ;
			backgroundAxisVO.location2D = ManagerFor3D.transform3DTo2DPoint(backgroundAxisVO.location3D);
			backgroundAxisVO.lineColor = uint(configVO.bgGuideColor);
			backgroundAxisVO.lineThikness = configVO.bgGuideThikness;
			
			sideBackgroundAixVO.location3D.x = 0;
			sideBackgroundAixVO.location3D.y = configVO.bgCubeThikness;
			sideBackgroundAixVO.location3D.z = 0;
			sideBackgroundAixVO.location2D = ManagerFor3D.transform3DTo2DPoint(sideBackgroundAixVO.location3D);
			sideBackgroundAixVO.fillColor = uint(configVO.bgCubeFillColor);
			sideBackgroundAixVO.lineColor = uint(configVO.bgGuideColor);
			sideBackgroundAixVO.lineThikness = configVO.bgGuideThikness;
		}
		
		/**
		 */		
		private function updateBackgroundDrawInfo():void
		{
			backgroundVO.backCube.xSize = configVO.sizeX;
			backgroundVO.backCube.ySize = innerSizeY;
			backgroundVO.bottomCube.xSize = configVO.sizeX;
			sideBackgroundAixVO.ySize = innerSizeY;
			
			// 背景分割线；
			backgroundAxisVO.xSize = configVO.sizeX;
			backgroundAxisVO.ySize = innerSizeY;
			
			backgroundAxisVO.linePositions = new Vector.<Number>;
			sideBackgroundAixVO.linePositions = new Vector.<Number>;
			
			var length:uint = verticalAxisLeft.ticks.length;
			var linePosition:Number; 
			for (var i:uint = 0; i < length; i ++)
			{
				linePosition = verticalAxisLeft.ticks[i];
				backgroundAxisVO.linePositions.push(linePosition);
				sideBackgroundAixVO.linePositions.push(linePosition);
				sideBackgroundAixVO.offSet = offset;
			}
		}
		
		/**
		 */		
		private var _backgroundVO:BackGroundVO = new BackGroundVO();

		public function get backgroundVO():BackGroundVO
		{
			return _backgroundVO;
		}

		public function set backgroundVO(value:BackGroundVO):void
		{
			_backgroundVO = value;
		}

		/**
		 */		
		private var _backgroundAxisVO:XYBackgoundAxisVO = new XYBackgoundAxisVO();;
		
		public function get backgroundAxisVO():XYBackgoundAxisVO
		{
			return _backgroundAxisVO;
		}
		
		public function set backgroundAxisVO(value:XYBackgoundAxisVO):void
		{
			_backgroundAxisVO = value;
		}
		
		private var _sideBackgroundAixVO:YZBackgroundAixsVO = new YZBackgroundAixsVO();

		/**
		 */
		public function get sideBackgroundAixVO():YZBackgroundAixsVO
		{
			return _sideBackgroundAixVO;
		}

		/**
		 * @private
		 */
		public function set sideBackgroundAixVO(value:YZBackgroundAixsVO):void
		{
			_sideBackgroundAixVO = value;
		}
		
		/**
		 */		
		public function get innerSizeZ():int
		{
			return configVO.sizeZ - configVO.bgCubeThikness;
		}
		
		public function get innerSizeY():int
		{
			return  configVO.sizeY - configVO.bgCubeThikness;
		}
		
		/**
		 * Z 轴深度在 XY 平面内映射的偏移量；
		 */		
		private function get offset():Number
		{
			return innerSizeZ * Math.cos(Math.PI / 4) / 2;
		}

		/**
		 */		
		private var _title:String = "";
		
		public function get title():String
		{
			return _title;
			
		}
		
		public function set title(value:String):void
		{
			if (_title != value)
			{
				_title = value;
				ifTitleChanged = true;
			}
		}
		
		/**
		 * 将XML配置信息转化为VO的属性信息；
		 */		
		private function applyConfig(configXML:XML):void
		{
			if (ifConfigChanged)
			{
				
				XMLVOMapper.fuck(configXML.style.layout, configVO);
				XMLVOMapper.fuck(configXML.style.background, configVO);
				XMLVOMapper.fuck(configXML, configVO);
				XMLVOMapper.fuck(configXML, dataFormatter);
				XMLVOMapper.fuck(configXML.style.title, configVO.titleStyle);
				
				XMLVOMapper.fuck(configXML.style.valueLabel.fill, configVO.valueLabelStyle.fill);
				
				XMLVOMapper.fuck(configXML.style.axisLabel, configVO.axisLabelStyle);
				XMLVOMapper.fuck(configXML.style.axisTitle, configVO.axisTitleStyle);
				XMLVOMapper.fuck(configXML.style.axisLine, configVO.axisLine);
				
				createAxis(configXML);
				createSeries(configXML.series);
				configBackgroundData();
				
				title = configVO.title;
				ifConfigChanged = false;
			}
		}
		
		/**
		 * 默认信息提示样式，在系统初始化时用来设置toolTip样式;
		 * 
		 * 当用户配置了其样式时，则采用新样式，该样式具有继承性；
		 */		
		public function get defaultToolTipsConfigXML():XML
		{
			var resultXML:XML;
			try 
			{
				resultXML = XML(configXML.style.toolTip.toXMLString())
			}
			catch (e:Error)
			{
				resultXML = XML(defaultConfigXML.style.toolTip.toXMLString());
			}
			
			return resultXML;
		}
		
		/**
		 *  Default configuration of this  chart.
		 */		
		public var defaultConfigXML:XML = <config precision="0" ifFlash='1' ifHasValueLabel='0'>
			                                    <style>
													<layout sizeX="400" sizeY="300" sizeZ="60" gutterLeft="10" gutterRight="10" gutterTop="20" gutterBottom="10"/>
													<background bgGuideColor="AAB1BB" bgGuideThikness="1" bgCubeFillColor="C1C7D2" bgCubeThikness="10"/>
													<title font='宋体' color='333333' size='14' weight='1'/> 
			
 													<axisLabel size='12' color='333333' font='Arial'/>
												  	<axisTitle size='12' color='333333' font='Arial' weight="1"/>
 													<axisLine color="999999" thikness="1" alpha="1"/>
			
													<valueLabel>
														<fill color='555555' alpha='.8'/>
														<font color='FFFFFF' font='Arial' size='11' weight='1'/>
													</valueLabel>
													<toolTip radius='8' gutter='5' ifChangeColor='0' vOffset='15'>
														<line thikness='1' alpha='.8' color='FFFFFF'/>
													  	<fill color='555555' alpha='.8'/>
														<font font='Arial' size='12' weight='0' color='FFFFFF'/>
												  	</toolTip>
												</style>
												<axis>
													<horizontal type="field"/>
													<vertical type="linear"/>
												</axis>
											</config>
		
		/**
		 */			
		private static const axisCreationXML:XML = <definition>
														<field classPath="com.fiCharts.charts.chart3D.model.vo.axis.FieldAxisVO"/>
														<linear classPath="com.fiCharts.charts.chart3D.model.vo.axis.LinearAxisVO"/>
													</definition>
			
		/**
		 */			
		private static const seriesCreationXML:XML = <definition>
														<column classPath="com.fiCharts.charts.chart3D.model.vo.series.ColumnSeriesVO"/>
													</definition>
	}
}