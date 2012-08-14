package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	/**
	 */
	public class Chart2DModel
	{
		/**
		 */		
		public static const UPDATE_TITLE_STYLE:String = 'upateTitleStyle';
		
		/**
		 */		
		public static const UPDATE_SUB_TITLE_STYLE:String = 'updateSubTitleStyle';
		
		/**
		 */		
		public static const UPDATE_LEGEND_STYLE:String = 'updateLegendStyle';
		
		/**
		 * 每个序列都有自己单独的数据渲染相关样式, 这包含 tootip, valueLabel, dataRender;
		 * 
		 * 以此名称为Key值存储在 XMLVOMapper中， 在序列初始化的时候应用这些统一的样式配置， 同时每个序列
		 * 
		 * 也可以自己独立配置这些样式， 默认集成统一配置样式，也可以完全重写样式；
		 */		
		public static const SERIES_DATA_STYLE:String = 'seriesDataStyle';
		
		/**
		 */		
		public static const X_AXIS_STYLE:String = 'xAxisStyle';
		
		/**
		 */		
		public static const Y_AXIS_STYLE:String = 'yAxisStyle';
		
		/**
		 */		
		public static const LINE_SERIES:String = 'lineSeries';
		
		/**
		 */		
		public static const AREA_SERIES:String = 'areaSeries';
		
		/**
		 */		
		public static const BAR_SERIES:String = 'barSeries';
		
		/**
		 */		
		public static const STACKED_BAR_SERIES:String = 'stackedBarSeries';
		
		/**
		 */		
		public static const COLUMN_SERIES:String = 'columnSeries';
		
		/**
		 */		
		public static const STACKED_COLUMN_SERIES:String = 'stackedColumnSeries'
		
		/**
		 */		
		public static const BUBBLE_SERIES:String = 'bubbleSeries';
		
		/**
		 */		
		public static const MARKER_SERIES:String = 'markerSeries';
		
		/**
		 */		
		public function Chart2DModel()
		{
		}
		
		
		
		
		//------------------------------
		//
		// 全局特性统一配置
		//
		//-------------------------------
		
		/**
		 */
		public function get animation():Object
		{
			return _animation;
		}
		
		/**
		 * @private
		 */
		public function set animation(value:Object):void
		{
			_animation = XMLVOMapper.boolean(value);
		}
		
		/**
		 * 是否开启开场动画
		 */		
		private var _animation:Object = true;
		
		/**
		 */		
		private var _fullScreen:Object = true;

		/**
		 */
		public function get fullScreen():Object
		{
			return _fullScreen;
		}

		/**
		 * @private
		 */
		public function set fullScreen(value:Object):void
		{
			_fullScreen = value;
		}
		
		
		
		
		
		//-----------------------------------------
		//
		// 数据格式与样式控制
		//
		//-----------------------------------------

		/**
		 */		
		private var _legend:LegendStyle;

		/**
		 */
		public function get legend():LegendStyle
		{
			return _legend;
		}

		/**
		 * @private
		 */
		public function set legend(value:LegendStyle):void
		{
			_legend = value;
			
			XMLVOLib.dispatchCreation(Chart2DModel.UPDATE_LEGEND_STYLE, value);
		}

		/**
		 * 数据格式定义；
		 */		
		private var _dataFormatter:ChartDataFormatter = new ChartDataFormatter;

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
		
		
		
		//-------------------------------------------------
		//
		// 后缀快捷设置
		//
		//-------------------------------------------------
		
		/**
		 */		
		public function get ySuffix():String
		{
			return _dataFormatter.ySuffix;
		}

		public function set ySuffix(value:String):void
		{
			_dataFormatter.ySuffix = value;
		}
		
		/**
		 */		
		public function get xSuffix():String
		{
			return _dataFormatter.xSuffix;
		}
		
		public function set xSuffix(value:String):void
		{
			_dataFormatter.xSuffix = value;
		}
		
		
		
		
		
		//-------------------------------------------------
		//
		// 前缀快捷设置
		//
		//-------------------------------------------------
		
		
		/**
		 */		
		public function get yPrefix():String
		{
			return _dataFormatter.yPrefix;
		}
		
		public function set yPrefix(value:String):void
		{
			_dataFormatter.yPrefix = value;
		}
		
		/**
		 */		
		public function get xPrefix():String
		{
			return _dataFormatter.xPrefix;
		}
		
		public function set xPrefix(value:String):void
		{
			_dataFormatter.xPrefix = value;
		}
		
		/**
		 */		
		public function get zPrefix():String
		{
			return _dataFormatter.zPrefix;
		}
		
		public function set zPrefix(value:String):void
		{
			_dataFormatter.zPrefix = value;
		}
		
		
		/**
		 */
		public function get precision():uint
		{
			return _dataFormatter.precision;
		}

		/**
		 * @private
		 */
		public function set useGrouping(value:Object):void
		{
			_dataFormatter.useGrouping = value;
		}
		
		/**
		 */
		public function get useGrouping():Object
		{
			return _dataFormatter.useGrouping;
		}
		
		/**
		 * @private
		 */
		public function set precision(value:uint):void
		{
			_dataFormatter.precision = value;
		}
		
		
		
		
		//-----------------------------------------
		//
		// 坐标轴与序列
		//
		//-----------------------------------------
		
		/**
		 */		
		private var _axis:AxisModel;

		/**
		 */
		public function get axis():AxisModel
		{
			return _axis;
		}

		/**
		 * @private
		 */
		public function set axis(value:AxisModel):void
		{
			_axis = value;
		}
		
		/**
		 */		
		private var _series:Series;

		public function get series():Series
		{
			return _series;
		}

		public function set series(value:Series):void
		{
			_series = value;
		}
		
		
		//-------------------------------------------------
		//
		// 标题样式与设置
		//
		//-------------------------------------------------

		/**
		 */		
		private var _title:LabelStyle;

		/**
		 */		
		public function get title():LabelStyle
		{
			return _title;
		}
		
		/**
		 */		
		public function set title(value:LabelStyle):void
		{
			_title = value;
			XMLVOLib.dispatchCreation(Chart2DModel.UPDATE_TITLE_STYLE);
		}
		
		/**
		 */		
		private var _subTitle:LabelStyle

		public function get subTitle():LabelStyle
		{
			return _subTitle;
		}

		public function set subTitle(value:LabelStyle):void
		{
			_subTitle = value;
			XMLVOLib.dispatchCreation(Chart2DModel.UPDATE_TITLE_STYLE);
		}

		
		//-------------------------------------------------
		//
		// 背景样式
		//
		//-------------------------------------------------
		
		/**
		 */		
		private var _chartBG:ChartBGStyle = new ChartBGStyle;

		/**
		 */
		public function get chartBG():ChartBGStyle
		{
			return _chartBG;
		}

		/**
		 * @private
		 */
		public function set chartBG(value:ChartBGStyle):void
		{
			_chartBG = value;
		}
		
		/**
		 */		
		private var _gridField:GridFieldStyle;

		public function get gridField():GridFieldStyle
		{
			return _gridField;
		}

		public function set gridField(value:GridFieldStyle):void
		{
			_gridField = value;
		}

	}
}