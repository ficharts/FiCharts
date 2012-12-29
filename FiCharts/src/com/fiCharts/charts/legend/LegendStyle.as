package com.fiCharts.charts.legend
{
	import com.fiCharts.charts.chart2D.core.axis.DataRange;
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.ContainerStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	public class LegendStyle extends ContainerStyle
	{
		public function LegendStyle()
		{
			super();
		}
		
		/**
		 */		
		public var icon:DataRender;
		
		/**
		 */		
		private var _label:LabelStyle;

		/**
		 */
		public function get label():LabelStyle
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:LabelStyle):void
		{
			_label = value;
		}
		
		/**
		 */		
		private var _position:String = 'bottom';

		/**
		 */
		public function get position():String
		{
			return _position;
		}

		/**
		 * @private
		 */
		public function set position(value:String):void
		{
			_position = value;
		}

		
	}
}