package com.fiCharts.charts.toolTips
{
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;

	public class TooltipDataItem
	{
		public function TooltipDataItem()
		{
		}
		
		/**
		 */		
		private var _metaData:Object;

		/**
		 */
		public function get metaData():Object
		{
			return _metaData;
		}

		/**
		 * @private
		 */
		public function set metaData(value:Object):void
		{
			_metaData = value;
		}

		/**
		 */		
		private var _style:TooltipStyle;

		/**
		 */
		public function get style():TooltipStyle
		{
			return _style;
		}

		/**
		 * @private
		 */
		public function set style(value:TooltipStyle):void
		{
			_style = value;
		}

	}
}