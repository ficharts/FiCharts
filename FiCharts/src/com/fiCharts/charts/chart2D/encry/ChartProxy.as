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
	import com.fiCharts.charts.chart2D.core.Chart2DStyleSheet;
	import com.fiCharts.charts.chart2D.core.axis.TickMarkStyle;
	import com.fiCharts.charts.chart2D.core.model.AxisModel;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.ChartBGStyle;
	import com.fiCharts.charts.chart2D.core.model.DataRenderStyle;
	import com.fiCharts.charts.chart2D.core.model.GridFieldStyle;
	import com.fiCharts.charts.chart2D.core.model.Series;
	import com.fiCharts.charts.chart2D.core.model.XAxis;
	import com.fiCharts.charts.chart2D.core.model.YAxis;
	import com.fiCharts.charts.chart2D.line.LineSeries;
	import com.fiCharts.charts.chart2D.marker.MarkerSeries;
	import com.fiCharts.charts.common.ChartColorManager;
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.charts.toolTips.TooltipStyle;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.events.EventDispatcher;

	/**
	 * Proxy
	 */	
	public class ChartProxy extends EventDispatcher
	{
		public function ChartProxy()
		{
			XMLVOLib.registerCustomClasses(<dataScale path='com.fiCharts.charts.chart2D.core.model.DataScale'/>);
			
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
			
			DataRenderStyle;
			XMLVOLib.registerCustomClasses(<dataRender path='com.fiCharts.charts.chart2D.core.model.DataRenderStyle'/>);
			XMLVOLib.registerCustomClasses(<bubbleRender path='com.fiCharts.charts.chart2D.core.model.DataRenderStyle'/>);
			XMLVOLib.registerCustomClasses(<markerRender path='com.fiCharts.charts.chart2D.core.model.DataRenderStyle'/>);
			
			XMLVOLib.setASLabelStyleKey('valueLabel');
			XMLVOLib.setASLabelStyleKey('innerValueLabel');
			XMLVOLib.setASStyleKey('scrollBar');
			
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
		// 图表的配置
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
				_configXML = value;
		}
		
		/**
		 * 创建新模型，一次性 应用混合好的样式；
		 */		
		public function setConfigCore(value:XML):void
		{
			YAxis.update();
			XAxis.update();
			
			this.chartModel = new Chart2DModel();
			modelChanged = true;
			
			var seriesDataStyle:XML = <seriesDataStyle/>
				
			seriesDataStyle.appendChild(value.child('tooltip'));
			seriesDataStyle.appendChild(value.child('dataRender'));
			seriesDataStyle.appendChild(value.child('valueLabel'));
			seriesDataStyle.appendChild(value.child('innerValueLabel'));
			XMLVOLib.setXML(Chart2DModel.SERIES_DATA_STYLE, seriesDataStyle);
			
			XMLVOLib.setXML(Chart2DModel.X_AXIS_STYLE, value.child('xAxis'));
			XMLVOLib.setXML(Chart2DModel.Y_AXIS_STYLE, value.child('yAxis'));
			
			XMLVOLib.setXML(Chart2DModel.LINE_SERIES, value.child('line'));
			XMLVOLib.setXML(Chart2DModel.AREA_SERIES, value.child('area'));
			
			XMLVOLib.setXML(Chart2DModel.COLUMN_SERIES, value.child('column'));
			XMLVOLib.setXML(Chart2DModel.STACKED_COLUMN_SERIES, value.child('stackedColumn'));
			
			XMLVOLib.setXML(Chart2DModel.BUBBLE_SERIES, value.child('bubble'));
			XMLVOLib.setXML(Chart2DModel.MARKER_SERIES, value.child('marker'));
			
			XMLVOLib.setXML(Chart2DModel.BAR_SERIES, value.child('bar'));
			XMLVOLib.setXML(Chart2DModel.STACKED_BAR_SERIES, value.child('stackedBar'));
			
			for each (var item:XML in value.child('definition').children())
				XMLVOLib.setXML(item.@id, item);
			
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
		 * 根据样式名称设置对应的样式表； 
		 */		
		public function styleInit(styleName:String = 'white'):void
		{
			currentStyleName = styleName;
			currentStyleXML = Chart2DStyleSheet.getTheme(currentStyleName);
			ChartColorManager.chartColors = Chart2DStyleSheet.getColors(currentStyleName);// TODO
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
		 * 当前的样式名称， 此名称与样式模板一一对应；
		 */		
		public var currentStyleName:String = 'black';
		
	}
}