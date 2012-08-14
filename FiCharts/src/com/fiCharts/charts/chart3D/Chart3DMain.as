package com.fiCharts.charts.chart3D
{
	import com.fiCharts.charts.chart3D.baseClasses.ISeries;
	import com.fiCharts.charts.chart3D.event.Chart3DEvent;
	import com.fiCharts.charts.chart3D.model.Chart3DConfig;
	import com.fiCharts.charts.chart3D.model.Chart3DProxy;
	import com.fiCharts.charts.chart3D.model.vo.axis.AxisBaseVO;
	import com.fiCharts.charts.chart3D.view.ColumnSeriesUI;
	import com.fiCharts.charts.chart3D.view.axis.AxisUIBase;
	import com.fiCharts.charts.chart3D.view.axis.HoriticalAxisUI;
	import com.fiCharts.charts.chart3D.view.axis.VerticalLeftAxisUI;
	import com.fiCharts.charts.chart3D.view.axis.VerticalRightAxisUI;
	import com.fiCharts.charts.chart3D.view.bg.BackgroundUI;
	import com.fiCharts.charts.chart3D.view.bg.SideBackgroundAxisUI;
	import com.fiCharts.charts.chart3D.view.bg.XYBackgroundAxisUI;
	import com.fiCharts.ui.text.Label;
	import com.fiCharts.ui.toolTips.ToolTipsManager;
	import com.fiCharts.utils.StageUtil;
	import com.fiCharts.utils.system.GC;
	
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author wallen
	 * 
	 */	
	public class Chart3DMain extends Sprite
	{
		public function Chart3DMain()
		{
			super();
			StageUtil.initApplication(this, init);
		}
		
		
		
		
		
		//---------------------------------------
		//
		// 数据及配置接口
		//
		//----------------------------------------
		
		/**
		 */		
		public function set configXML(value:XML):void
		{
			proxy.configXML = value;
		}
		
		/**
		 */		
		private var _dataXML:XML;
		
		public function get dataXML():XML
		{
			return _dataXML;
		}
		
		/**
		 * @param value
		 */		
		public function set dataXML(value:XML):void
		{
			_dataXML = value;
			
			var data:Vector.<Object> = new Vector.<Object>();
			var vo:Object;
			
			for each (var item:XML in value.children())
			{
				vo = new Object();
				for each (var attribute:XML in item.attributes())
				{
					vo[attribute.name().toString()] = attribute.toString();
				}
				
				data.push(vo);
			}
			
			proxy.dataProvider = data;
		}
		
		/**
		 * 
		 */		
		private function get configVO():Chart3DConfig
		{
			return proxy.configVO;
		}
		
		/**
		 */		
		public function get horizontalAxis():AxisBaseVO
		{
			return proxy.horizontalAxis;
		}
		
		/**
		 *  individual aixs.
		 * @param v
		 */
		public function set horizontalAxis(value:AxisBaseVO):void
		{
			proxy.horizontalAxis = value;
		}
		
		/**
		 */
		public function get verticalAxis():AxisBaseVO
		{
			return proxy.verticalAxisLeft;
		}
		
		public function set verticalAxis(value:AxisBaseVO):void
		{
			proxy.verticalAxisLeft = value;
		}
		
		/**
		 */		
		private var horizontalAxisUI:AxisUIBase = new HoriticalAxisUI; 
		
		/**
		 */		
		private var verticalAxisUILeft:AxisUIBase = new VerticalLeftAxisUI;
		
		/**
		 */		
		private var verticalAxisUIRight:AxisUIBase = new VerticalRightAxisUI;
		
		/**
		 */		
		public function clearSeries():void
		{
			proxy.series = new Vector.<ISeries>();
		}
		
		/**
		 * @param series
		 */		
		public function addSeriesVO(value:ISeries):void
		{
			proxy.addSeriesVO(value);
		}
		
		/**
		 * @param series
		 */		
		public function removeSeriesVO(value:ISeries):void
		{
			proxy.removeSeriesVO(value);
		}
		
		
		
		
		
		//--------------------------------------------------
		//
		// 图表渲染
		//
		//---------------------------------------------------

		/**
		 *  Render this chart.
		 */		
		public function render():void
		{
			if (!proxy.dataProvider) return;
			
			preRender();
			
			if(isLayoutUpdated())
			{
				preRender();
				coreRender();
				return;
			}
			
			coreRender();
		}
		
		/**
		 */		
		private function preRender():void
		{
			proxy.updateModel();//建模
			renderAxis();
		}
		
		/**
		 */		
		private function coreRender():void
		{
			//渲染坐标轴背景等
			renderBackground();
			renderTitle();
			
			//渲染柱状图序列
			renderColumnSeries();
			layoutChartContainer();
			
			GC.run();
		}
		
		/**
		 * Check gutter, adjust the gutter to contain all labels. 
		 * 
		 * 如果坐标轴渲染后占得尺寸过大则不能被完全显示， 需要更新图标的边距后重新渲染；
		 */		
		private function isLayoutUpdated():Boolean
		{
			var ifChanged:Boolean = false;
			if (temBottomSpace != this.bottomSpace) 
			{
				bottomSpace = temBottomSpace;
				updateSizeY();
				ifChanged = true;
			}
			
			if (temTopSpace != this.topSpace) 
			{
				topSpace = temTopSpace;
				updateSizeY();
				ifChanged = true;
			}
			
			if (temLeftSpace != leftSpace || temRightSpace != rightSpace)
			{
				leftSpace = temLeftSpace;
				rightSpace = temRightSpace;
				updateSizeX();
				ifChanged = true;
			}
			
			//限制重复渲染次数；
			if (ifChanged)
				return true;

			return false;
		}
		
		/**
		 */		
		private function renderTitle():void
		{
			if (proxy.ifTitleChanged)
			{
				titleLabel.reLabel(proxy.title);
				proxy.ifTitleChanged = false;
			}
			
			titleLabel.x = (chartWidth - this.rightSpace - this.leftSpace - titleLabel.textWidth) / 2;
			titleLabel.y = - this.originY + (topSpace - titleLabel.textHeight) / 2;
		}
		
		/**
		 */		
		private function renderAxis():void
		{
			if(proxy.ifAxisVOChanged)
			{
				horizontalAxisUI.axisVO = proxy.horizontalAxis;
				verticalAxisUILeft.axisVO = proxy.verticalAxisLeft;
				
				if (proxy.verticalAxisRight)
					this.verticalAxisUIRight.axisVO = proxy.verticalAxisRight;
				
				proxy.ifAxisVOChanged = false;
			}
			
			horizontalAxisUI.render(configVO);
			verticalAxisUILeft.render(configVO);
			verticalAxisUIRight.render(configVO);
		}
		
		/**
		 */		
		private function renderColumnSeries():void
		{
			columnsSeriesUI.canvasHeight = proxy.innerSizeY;
			
			if (proxy.ifColumnRendersChanged)
			{
				columnsSeriesUI.renderVOes = proxy.seriesItemRenders;
				proxy.ifColumnRendersChanged = false;
			}
			
			columnsSeriesUI.render();
			
			if (proxy.configVO.ifBgCubeThiknessChanged)
			{
				columnsSeriesUI.location3D.x = 0;
				columnsSeriesUI.location3D.y = proxy.configVO.bgCubeThikness;
				columnsSeriesUI.location3D.z = 0;
				columnsSeriesUI.location2D = ManagerFor3D.transform3DTo2DPoint(columnsSeriesUI.location3D);
				columnsSeriesUI.x = columnsSeriesUI.location2D.x;
				columnsSeriesUI.y = columnsSeriesUI.location2D.y;
				proxy.configVO.ifBgCubeThiknessChanged = false;
			}
			
		}
		
		
		
		
		//--------------------------------------------
		//
		// 图表尺寸
		//
		//--------------------------------------------
		
		/**
		 */		
		private var _chartWidth:int;
		
		public function get chartWidth():int
		{
			return _chartWidth;
		}
		
		public function set chartWidth(value:int):void
		{
			if (value >= miniWidth)
			{
				_chartWidth = value;
				leftSpace = temLeftSpace;
				rightSpace = temRightSpace;
				updateSizeX();
			}
		}
		
		/**
		 */		
		private var _chartHeight:int;
		
		public function get chartHeight():int
		{
			return _chartHeight;
		}
		
		/**
		 */		
		public function set chartHeight(value:int):void
		{
			if (value >= miniHeight)
			{
				_chartHeight = value;
				bottomSpace = temBottomSpace;
				topSpace = temTopSpace;
				updateSizeY();
			}
		}
		
		/**
		 */		
		private function get miniWidth():Number
		{
			return 100 + 
			configVO.sizeZ * Math.cos(Math.PI / 4) / 2 + configVO.gutterLeft + configVO.gutterRight;
		}
		
		private function get miniHeight():Number
		{
			return 100 +
			configVO.sizeZ * Math.sin(Math.PI / 4) / 2 + configVO.gutterTop + configVO.gutterBottom;
		}
		
		/**
		 */		
		private function updateSizeX():void
		{
			var fullWidth:int = _chartWidth - leftSpace - rightSpace;
			configVO.sizeX = fullWidth - configVO.sizeZ * Math.cos(Math.PI / 4) / 2;
		}
		
		/**
		 */		
		private function updateSizeY():void
		{
			var fullHeight:int = _chartHeight - topSpace - bottomSpace;
			configVO.sizeY = fullHeight - configVO.sizeZ * Math.sin(Math.PI / 4) / 2;
		}
		
		/**
		 */		
		private function get temBottomSpace():int
		{
			return horizontalAxisUI.height + configVO.gutterBottom - configVO.bgCubeThikness;
		}
		
		/**
		 */		
		private function get temTopSpace():uint
		{
			return this.titleLabel.textHeight + configVO.gutterTop;
		}
		
		/**
		 */		
		private function get temLeftSpace():int
		{
			return this.verticalAxisUILeft.width + configVO.gutterLeft ;
		}
		
		private function get temRightSpace():int
		{
			return this.verticalAxisUIRight.width + this.configVO.gutterRight;
		}
		
		/**
		 */		
		private var leftSpace:int;
		private var rightSpace:int;
		private var bottomSpace:int;
		private var topSpace:int;
		
		/**
		 */		
		private function get originX():Number
		{
			return this.temLeftSpace;
		}
		
		/**
		 */		
		private function get originY():Number
		{
			return this.chartHeight - bottomSpace;
		}
		
		/**
		 */		
		private function layoutChartContainer():void
		{
			chartContainer.x = originX;
			chartContainer.y = originY;
		}
		
		
		
		
		
		//-------------------------------------
		//
		// 背景
		//
		//-------------------------------------
		
		
		/**
		 */		
		private function renderBackground():void
		{
			backgroundUI.render();
			backgroundAxisUI.render();
			sideBackgroundAixUI.render();
		}
		
		/**
		 */		
		private var backgroundAxisUI:XYBackgroundAxisUI;
		
		/**
		 */		
		private var sideBackgroundAixUI:SideBackgroundAxisUI;
		
		/**
		 */		
		private var backgroundUI:BackgroundUI;
		
		
		
		
		
		//-----------------------------------------
		//
		// 初始化
		//
		//-----------------------------------------
		
		/**
		 */		
		private function init():void
		{
			addChild(chartContainer);
			titleLabel = new Label();
			chartContainer.addChild(titleLabel);
			toolTipsManager = new ToolTipsManager(this);
			
			//总数据驱动
			proxy = new Chart3DProxy();
			
			//配置默认设置
			proxy.configXML = proxy.defaultConfigXML;
			
			// 背景
			backgroundUI = new BackgroundUI(proxy.backgroundVO);
			chartContainer.addChild(backgroundUI);
			
			backgroundAxisUI = new XYBackgroundAxisUI(proxy.backgroundAxisVO);
			chartContainer.addChild(backgroundAxisUI);
			
			sideBackgroundAixUI = new SideBackgroundAxisUI(proxy.sideBackgroundAixVO);
			chartContainer.addChild(sideBackgroundAixUI);
			
			// 坐标轴
			chartContainer.addChild(horizontalAxisUI);
			chartContainer.addChild(verticalAxisUILeft);
			chartContainer.addChild(verticalAxisUIRight);
			
			// 柱状图渲染器
			columnsSeriesUI = new ColumnSeriesUI();
			chartContainer.addChild(columnsSeriesUI);
			
			updateStyleConfig();
			proxy.addEventListener(Chart3DEvent.CONFIG_CHANGED, configChangedHandler, false, 0, true);
		}
		
		/**
		 */		
		private function configChangedHandler(evt:Chart3DEvent):void
		{
			updateStyleConfig();
		}
		
		/**
		 * 配置更新时，同步更新整体配置相关项;
		 */		
		private function updateStyleConfig():void
		{
			toolTipsManager.setStyleXML(proxy.defaultToolTipsConfigXML);
			
			titleLabel.setTextFormat(configVO.titleStyle.getTextFormat());
			
			columnsSeriesUI.ifFlash = configVO.ifFlash;
			columnsSeriesUI.ifHasValueLabel = configVO.ifHasValueLabel;
			columnsSeriesUI.valueLabelFillStyle = configVO.valueLabelStyle.getFill;
			columnsSeriesUI.valueLabelFontStyle = configVO.valueLabelStyle;
		}
		
		/**
		 */		
		private var proxy:Chart3DProxy;
		
		/**
		 */		
		private var titleLabel:Label;
		
		/**
		 */		
		private var toolTipsManager:ToolTipsManager;
		
		/**
		 */		
		private var chartContainer:Sprite = new Sprite();
		
		/**
		 */		
		private var columnsSeriesUI:ColumnSeriesUI;
		
		
	}
}