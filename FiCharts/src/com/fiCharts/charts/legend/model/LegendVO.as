package com.fiCharts.charts.legend.model
{
	import com.fiCharts.charts.legend.view.itemRender.RecItemRender;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleUI;
	
	import flash.events.EventDispatcher;

	public class LegendVO extends EventDispatcher
	{
		public function LegendVO()
		{
		}
		
		/**
		 * 原数据 
		 */		
		private var _mataData:EventDispatcher;

		public function get metaData():EventDispatcher
		{
			return _mataData;
		}

		public function set metaData(value:EventDispatcher):void
		{
			_mataData = value;
		}

		/**
		 */		
		public function get itemRender():IStyleStatesUI
		{
			var result:RecItemRender = new RecItemRender();
			result.metaData = this.metaData;
			
			return result;
		}
		
	}
}