package com.fiCharts.charts.chart2D.core.zoomBar
{
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
	
	/**
	 */	
	public class ZoomBarStyle implements IStyleElement
	{
		public function ZoomBarStyle()
		{
			super();
		}
		
		/**
		 *  style 采取的是继承模式，更新原有样
		 */
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, "zoomBar");		
			
			styleXML = XMLVOMapper.getStyleXMLBy_ID(_style, "zoomBar");
		}
		
		/**
		 * 样式的配置文件 
		 */		
		public var styleXML:Object;
		
		/**
		 */		
		private var _style:String;
		
		/**
		 */
		public function get style():String
		{
			return _style;
		}
		
		/**
		 */		
		private var _visible:Object = true;

		public function get visible():Object
		{
			return _visible;
		}

		public function set visible(value:Object):void
		{
			_visible = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		private var _height:Number = 0;

		/**
		 */
		public function get height():Number
		{
			return _height;
		}

		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			_height = value;
		}

		/**
		 */		
		private var _barBG:Style;

		public function get barBG():Style
		{
			return _barBG;
		}

		public function set barBG(value:Style):void
		{
			_barBG = value;
		}
		
		/**
		 */		
		private var _window:ZoomWindowStyle;

		/**
		 */
		public function get window():ZoomWindowStyle
		{
			return _window;
		}

		/**
		 * @private
		 */
		public function set window(value:ZoomWindowStyle):void
		{
			_window = value;
		}
		
		/**
		 */		
		private var _chart:Style;

		/**
		 */
		public function get chart():Style
		{
			return _chart;
		}
		
		/**
		 * @private
		 */
		public function set chart(value:Style):void
		{
			_chart = value;
		}
		
		/**
		 */		
		public var grayChart:Style;
		
		/**
		 */		
		private var _zoomPoint:DataRender;

		/**
		 */
		public function get zoomPoint():DataRender
		{
			return _zoomPoint;
		}

		/**
		 * @private
		 */
		public function set zoomPoint(value:DataRender):void
		{
			_zoomPoint = XMLVOMapper.updateObject(value, _zoomPoint, Model.DATA_RENDER, this) as DataRender;
		}


	}
}