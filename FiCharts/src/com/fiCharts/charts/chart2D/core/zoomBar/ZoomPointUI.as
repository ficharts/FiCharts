package com.fiCharts.charts.chart2D.core.zoomBar
{
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	public class ZoomPointUI extends Sprite implements IStyleStatesUI
	{
		public function ZoomPointUI()
		{
			super();
			stateControl = new StatesControl(this);
		}
		
		/**
		 */		
		private var stateControl:StatesControl;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			dataRender.render(this, metaData);
		}
		
		/**
		 */		
		public var metaData:Object;
		
		/**
		 */		
		public function get currState():Style
		{
			return _currState;
		}
		
		/**
		 */		
		private var _currState:Style;
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_currState = value;
		}
		
		/**
		 */		
		public function hoverHandler():void
		{
			dataRender.toHover();
		}
		
		/**
		 */		
		public function normalHandler():void
		{
			dataRender.toNormal();
		}
		
		/**
		 */		
		public function downHandler():void
		{
			dataRender.toDown();
		}
		
		/**
		 * 默认为系统统一配置，如果颜色没有配置则采用节点颜色，序列可以单独定�
		 * 
		 * 渲染节点的显示与尺寸�
		 */		
		private var _dataRender:DataRender;
		
		/**
		 */
		public function get dataRender():DataRender
		{
			return _dataRender;
		}
		
		/**
		 * @private
		 */
		public function set dataRender(value:DataRender):void
		{
			_dataRender = XMLVOMapper.updateObject(value, _dataRender, Model.DATA_RENDER, this) as DataRender;
		}
	}
}