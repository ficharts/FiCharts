package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.charts.chart2D.area2D.AreaSeries2D;
	import com.fiCharts.charts.chart2D.bar.BarSeries;
	import com.fiCharts.charts.chart2D.bar.stack.StackedBarSeries;
	import com.fiCharts.charts.chart2D.bar.stack.StackedPercentBarSeries;
	import com.fiCharts.charts.chart2D.bubble.BubbleSeries;
	import com.fiCharts.charts.chart2D.column2D.ColumnSeries2D;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedColumnSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedPercentColumnSeries;
	import com.fiCharts.charts.chart2D.column2D.stack.StackedSeries;
	import com.fiCharts.charts.chart2D.core.Chart2DStyleTemplate;
	import com.fiCharts.charts.chart2D.core.axis.TickMarkStyle;
	import com.fiCharts.charts.chart2D.core.model.AxisModel;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.ChartBGStyle;
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.charts.chart2D.core.model.GridFieldStyle;
	import com.fiCharts.charts.chart2D.core.model.Series;
	import com.fiCharts.charts.chart2D.core.model.XAxis;
	import com.fiCharts.charts.chart2D.core.model.YAxis;
	import com.fiCharts.charts.chart2D.core.zoomBar.ZoomWindowStyle;
	import com.fiCharts.charts.chart2D.line.LineSeries;
	import com.fiCharts.charts.chart2D.marker.MarkerSeries;
	import com.fiCharts.charts.common.ChartColors;
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.charts.toolTips.TooltipStyle;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.events.EventDispatcher;

	/**
	 * Proxy
	 */	
	public class CP extends EventDispatcher
	{
		public function CP()
		{
			XMLVOLib.registerCustomClasses(<colors path='com.fiCharts.utils.XMLConfigKit.style.Colors'/>);
			
			//-------------------数据缩放--------------------------------
			ZoomWindowStyle;
			XMLVOLib.registerCustomClasses(<window path='com.fiCharts.charts.chart2D.core.zoomBar.ZoomWindowStyle'/>);
			
			XMLVOLib.setASStyleKey("barBG");
			XMLVOLib.setASStyleKey("chart");
			XMLVOLib.setASStyleKey("grayChart");
			
			XMLVOLib.registerCustomClasses(<zoom path='com.fiCharts.charts.chart2D.core.model.Zoom'/>);
			//------------------数据缩放---------------------------------
			
			
			
			ChartBGStyle;
			XMLVOLib.registerCustomClasses(<chartBG path='com.fiCharts.charts.chart2D.core.model.ChartBGStyle'/>);
			
			GridFieldStyle;
			XMLVOLib.registerCustomClasses(<gridField path='com.fiCharts.charts.chart2D.core.model.GridFieldStyle'/>);
			XMLVOLib.registerCustomClasses(<hGrid path='com.fiCharts.utils.XMLConfigKit.style.Style'/>);
			XMLVOLib.registerCustomClasses(<vGrid path='com.fiCharts.utils.XMLConfigKit.style.Style'/>);
			
			ChartDataFormatter;
			XMLVOLib.registerCustomClasses(<dataFormatter path='com.fiCharts.charts.common.ChartDataFormatter'/>);
			
			XMLVOLib.setASLabelStyleKey('title');
			XMLVOLib.setASLabelStyleKey('subTitle');
			
			TooltipStyle;
			XMLVOLib.registerCustomClasses(<tooltip path='com.fiCharts.charts.toolTips.TooltipStyle'/>);
			XMLVOLib.setASLabelStyleKey('self');
			XMLVOLib.setASLabelStyleKey('group');
			
			LegendStyle;
			XMLVOLib.registerCustomClasses(<legend path='com.fiCharts.charts.legend.LegendStyle'/>);
			XMLVOLib.registerCustomClasses(<icon path='com.fiCharts.charts.chart2D.core.model.DataRender'/>);
			
			AxisModel;
			XMLVOLib.registerCustomClasses(<axis path='com.fiCharts.charts.chart2D.core.model.AxisModel'/>);
			
			XAxis;
			XMLVOLib.registerCustomClasses(<xAxis path='com.fiCharts.charts.chart2D.core.model.XAxis'/>);
			XMLVOLib.registerCustomClasses(<x path='com.fiCharts.charts.chart2D.core.model.XAxis'/>);
			
			YAxis;
			XMLVOLib.registerCustomClasses(<yAxis path='com.fiCharts.charts.chart2D.core.model.YAxis'/>);
			XMLVOLib.registerCustomClasses(<y path='com.fiCharts.charts.chart2D.core.model.YAxis'/>);
			
			TickMarkStyle;
			XMLVOLib.registerCustomClasses(<tickMark path='com.fiCharts.charts.chart2D.core.axis.TickMarkStyle'/>);
			
			Series;
			XMLVOLib.registerCustomClasses(<series path='com.fiCharts.charts.chart2D.core.model.Series'/>);
			
			LineSeries;
			XMLVOLib.registerCustomClasses(<line path='com.fiCharts.charts.chart2D.line.LineSeries'/>);
			
			ColumnSeries2D;
			XMLVOLib.registerCustomClasses(<column path='com.fiCharts.charts.chart2D.column2D.ColumnSeries2D'/>);
			
			BubbleSeries;
			XMLVOLib.registerCustomClasses(<bubble path='com.fiCharts.charts.chart2D.bubble.BubbleSeries'/>);
			
			MarkerSeries;
			XMLVOLib.registerCustomClasses(<marker path='com.fiCharts.charts.chart2D.marker.MarkerSeries'/>);
			
			AreaSeries2D;
			XMLVOLib.registerCustomClasses(<area path='com.fiCharts.charts.chart2D.area2D.AreaSeries2D'/>);
			
			StackedSeries;
			XMLVOLib.registerCustomClasses(<stack path='com.fiCharts.charts.chart2D.column2D.stack.StackedSeries'/>);
			
			StackedColumnSeries;
			XMLVOLib.registerCustomClasses(<stackedColumn path='com.fiCharts.charts.chart2D.column2D.stack.StackedColumnSeries'/>);
			
			StackedPercentColumnSeries;
			XMLVOLib.registerCustomClasses(<stackedPercentColumn path='com.fiCharts.charts.chart2D.column2D.stack.StackedPercentColumnSeries'/>);
			
			BarSeries;
			XMLVOLib.registerCustomClasses(<bar path='com.fiCharts.charts.chart2D.bar.BarSeries'/>);
			
			StackedBarSeries;
			XMLVOLib.registerCustomClasses(<stackedBar path='com.fiCharts.charts.chart2D.bar.stack.StackedBarSeries'/>);
			
			StackedPercentBarSeries;
			XMLVOLib.registerCustomClasses(<stackedPercentBar path='com.fiCharts.charts.chart2D.bar.stack.StackedPercentBarSeries'/>);
			
			DataRender;
			XMLVOLib.registerCustomClasses(<dataRender path='com.fiCharts.charts.chart2D.core.model.DataRender'/>);
			
			XMLVOLib.setASLabelStyleKey('valueLabel');
			XMLVOLib.setASLabelStyleKey('innerValueLabel');
			
			XMLVOLib.registerObjectToProperty('config', 'title', 'text');
			XMLVOLib.registerObjectToProperty('config', 'subTitle', 'text');
			
			XMLVOLib.registerObjectToProperty('yAxis', 'title', 'text');
			XMLVOLib.registerObjectToProperty('y', 'title', 'text');
			XMLVOLib.registerObjectToProperty('xAxis', 'title', 'text');
			XMLVOLib.registerObjectToProperty('x', 'title', 'text');
			
			XMLVOLib.registerObjectToProperty('title', 'text', 'value');
			XMLVOLib.registerObjectToProperty('subTitle', 'text', 'value');
			
			XMLVOLib.registerObjectToProperty('legend', 'label', 'text');
			XMLVOLib.registerObjectToProperty('label', 'text', 'value');
			XMLVOLib.registerObjectToProperty('label', 'label', 'text');
			
			XMLVOLib.registerObjectToProperty('tooltip', 'self', 'text');
			XMLVOLib.registerObjectToProperty('self', 'text', 'value');
			
			XMLVOLib.registerObjectToProperty('tooltip', 'group', 'text');
			XMLVOLib.registerObjectToProperty('group', 'text', 'value');
			
			XMLVOLib.registerObjectToProperty('config', 'tooltip', 'label');
			
			XMLVOLib.registerObjectToProperty('x', 'label', 'text');
			XMLVOLib.registerObjectToProperty('y', 'label', 'text');
		}
		
		/**
		 * When chart has new data, update legends' data.
		 * 
		 * 注：用于获取legend图例的数据源
		 */		
		private var _legendData:Array = [];
		
		public function  set legendData(data:Array):void
		{
			_legendData = data;
		}
		
		public function get legendData():Array
		{
			return this._legendData;
		}
		
		
		
		//----------------------------------------
		//
		// 图表的配�
		//
		//----------------------------------------
		/**
		 */
		private var _chartModel : Chart2DModel
		public function get chartModel():Chart2DModel
		{
			return _chartModel;
		}

		public function set chartModel(v:Chart2DModel):void
		{
			_chartModel = v;
		}
		
		/**
		 */		
		private var _configXML:XML;

		public function get configXML():XML
		{
			return _configXML;
		}

		/**
		 */		
		public function set configXML(value:XML):void
		{
			if (_configXML != value)
			{
				_configXML = value;
			}
		}
		
		/**
		 * 创建新模型，一次�应用混合好的样式�
		 */		
		public function setChartModel(value:XML):void
		{
			XMLVOLib.clearPartLib();
			
			// 先刷新颜色板，因稍后会构建图表的数据模型
			if (configXML && configXML.hasOwnProperty("colors"))
			{
				ChartColors.clear();
				XMLVOMapper.fuck(configXML, ChartColors);
			}
			
			YAxis.update();
			XAxis.update();
			
			this.chartModel = new Chart2DModel();
			modelChanged = true;
			
			var seriesDataStyle:XML = <seriesDataStyle/>
				
			seriesDataStyle.appendChild(value.child('tooltip'));
			seriesDataStyle.appendChild(value.child('valueLabel'));
			seriesDataStyle.appendChild(value.child('innerValueLabel'));
			
			XMLVOLib.registerPartXML(Chart2DModel.SERIES_DATA_STYLE, seriesDataStyle, Model.SYSTEM);
			
			XMLVOLib.registerPartXML(Chart2DModel.X_AXIS_STYLE, value.child('xAxis'), Model.SYSTEM);
			XMLVOLib.registerPartXML(Chart2DModel.Y_AXIS_STYLE, value.child('yAxis'), Model.SYSTEM);
			
			XMLVOLib.registerPartXML(Chart2DModel.LINE_SERIES, value.child('line'), Model.SYSTEM);
			XMLVOLib.registerPartXML(Chart2DModel.AREA_SERIES, value.child('area'), Model.SYSTEM);
			
			XMLVOLib.registerPartXML(Chart2DModel.COLUMN_SERIES, value.child('column'), Model.SYSTEM);
			XMLVOLib.registerPartXML(Chart2DModel.STACKED_COLUMN_SERIES, value.child('stackedColumn'), Model.SYSTEM);
			
			XMLVOLib.registerPartXML(Chart2DModel.BUBBLE_SERIES, value.child('bubble'), Model.SYSTEM);
			XMLVOLib.registerPartXML(Chart2DModel.MARKER_SERIES, value.child('marker'), Model.SYSTEM);
			
			XMLVOLib.registerPartXML(Chart2DModel.BAR_SERIES, value.child('bar'), Model.SYSTEM);
			XMLVOLib.registerPartXML(Chart2DModel.STACKED_BAR_SERIES, value.child('stackedBar'), Model.SYSTEM);
			
			// 缩放条样式定
			XMLVOLib.registerPartXML(Chart2DModel.ZOOM_BAR, value.child('zoomBar'), Model.SYSTEM);
			
			//添加局部样式模板到局部库
			for each (var item:XML in value.child('template').children())
				XMLVOLib.registerPartXML(item.@id, item, item.name().toString());
			
			XMLVOMapper.fuck(value, chartModel);
		}
		
		/**
		 */		
		private var _modelChanged:Boolean = false;

		/**
		 */
		public function get modelChanged():Boolean
		{
			return _modelChanged;
		}

		/**
		 * @private
		 */
		public function set modelChanged(value:Boolean):void
		{
			_modelChanged = value;
		}

		/**
		 * 根据样式名称设置当前样式模板�
		 */		
		public function setCurStyleTemplate(styleName:String = 'Simple'):void
		{
			currentStyleName = styleName;
			currentStyleXML = Chart2DStyleTemplate.getTheme(currentStyleName);
			XMLVOMapper.fuck(currentStyleXML, ChartColors);// 映射颜色
		}
		
		/**
		 * 当前的样式模板；
		 */		
		public function set currentStyleXML(value:XML):void
		{
			_currentStyleXML = value;
		}
		
		/**
		 */		
		public function get currentStyleXML():XML
		{
			return _currentStyleXML;
		}
		
		/**
		 */		
		private var _currentStyleXML:XML;
		
		/**
		 * 当前的样式名称， 此名称与样式模板一一对应�
		 */		
		public var currentStyleName:String = 'Simple';
		
	}
}