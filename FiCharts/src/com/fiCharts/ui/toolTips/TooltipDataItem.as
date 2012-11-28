package com.fiCharts.ui.toolTips
{
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;

	/**
	 * 信息提示的数据节点， 一个信息提示可以由多个数据节点组成
	 * 
	 * 一次提示多份信息，每个数据节点包含元数据和样式两个属性
	 */	
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
		
		/**
		 */		
		public function distory():void
		{
			_style = null;
			_metaData = null;
		}

	}
}