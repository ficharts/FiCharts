package com.fiCharts.charts.chart2D.core.series
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.LegendStateControl;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 每个序列的节点不但要有ItemRender， 还要有专门渲染此节点的渲染器，
	 * 
	 * 如柱体， 散点，气泡等类型的节点；
	 * 
	 * @author wallen
	 * 
	 */	
	public class SeriesItemUIBase extends Sprite implements IStyleStatesUI
	{
		public function SeriesItemUIBase(dataItem:SeriesDataItemVO)
		{
			super();
			
			this.dataItem = dataItem;
			this.mouseChildren = false;
			
			this.statesControl = new StatesControl(this);
			this.legendStateContorl = new LegendStateControl(dataItem, this.statesControl);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		}
		
		/**
		 */		
		private var _style:Style;
		
		/**
		 * 
		 */
		public function get style():Style
		{
			return _style;
		}
		
		/**
		 * @private
		 */
		public function set style(value:Style):void
		{
			_style = value;
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
		private var _states:States;
		
		/**
		 */
		public function get states():States
		{
			return _states;
		}
		
		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = value;
			
			statesControl.states = this.states;
		}
		
		/**
		 */		
		public function render():void
		{
			
		}
		
		/**
		 */		
		private var statesControl:StatesControl;
		
		/**
		 */		
		protected var legendStateContorl:LegendStateControl;
		
		/**
		 */		
		public function hoverHandler():void
		{
			this.dataItem.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SHOW_ITEM_RENDER));
		}
		
		/**
		 */		
		public function normalHandler():void
		{
			this.dataItem.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.HIDE_ITEM_RENDER));
		}
		
		/**
		 */		
		public function downHandler():void
		{
			//this.y = dataItem.y + 1;
		}
		
		/**
		 */		
		protected function rollOverHandler(evt:MouseEvent):void
		{
			dataItem.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SHOW_TOOLTIP));
		}
		
		/**
		 */		
		protected function rollOutHandler(evt:MouseEvent):void
		{
			dataItem.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.HIDE_TOOLTIP));
		}
		
		/**
		 */		
		private var _dataItem:SeriesDataItemVO;
		
		/**
		 */
		public function get dataItem():SeriesDataItemVO
		{
			return _dataItem;
		}
		
		/**
		 * @private
		 */
		public function set dataItem(value:SeriesDataItemVO):void
		{
			_dataItem = value;
		}
		
		
	}
}