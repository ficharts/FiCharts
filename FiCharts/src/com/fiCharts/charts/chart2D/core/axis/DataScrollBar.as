package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.DataBarStyle;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class DataScrollBar extends Sprite implements IStyleStatesUI
	{
		public function DataScrollBar(axis:AxisBase, style:DataBarStyle)
		{
			super();
			this.axis = axis;
			this.barStyle = style;
			
			stateControl = new StatesControl(this);
			stateControl.states = barStyle.states;
			
			this.addChild(holder);
			axis.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0 , true);
			axis.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		private var holder:Shape = new Shape;
		
		/**
		 */		
		private var stateControl:StatesControl;
		
		/**
		 */		
		private function rollOver(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler, false, 0, true);
		}
		
		/**
		 */		
		private function startDragHandler(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler, false, 0 , true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragHandler, false, 0, true);
		}
		
		/**
		 */		
		private function dragHandler(evt:MouseEvent):void
		{
			trace("drag");
		}
		
		/**
		 */		
		private function stopDragHandler(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		}
		
		private function rollOut(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
		}
		
		/**
		 */		
		public function get barHeight():Number
		{
			return 50;
		}
		
		/**
		 * 坐标轴进行任何数据缩放操作时，同步更新；
		 * 
		 */		
		public function update(startPerc:Number, endPerc:Number):void
		{
			holder.graphics.clear();
			
			var w:Number = (endPerc - startPerc) * axis.size;
			holder.graphics.beginFill(0, 0.5);
			holder.graphics.drawRect(startPerc * axis.size, axis.labelUIsCanvas.height, w, barHeight);
		}
		
		/**
		 */		
		private var axis:AxisBase;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			style.width = axis.size;
			style.height = this.barHeight;
			style.ty = axis.labelUIsCanvas.height;
			
			StyleManager.drawRect(this, style);
		}
		
		/**
		 */		
		public function get style():Style
		{
			return _style;
		}
		
		/**
		 */		
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
		/**
		 */		
		public function hoverHandler():void
		{
		}
		
		/**
		 */		
		public function normalHandler():void
		{
		}
		
		/**
		 */		
		public function downHandler():void
		{
		}
		
		/**
		 */		
		public function distory():void
		{
			
		}
		
		/**
		 */		
		private var barStyle:DataBarStyle;
	}
}