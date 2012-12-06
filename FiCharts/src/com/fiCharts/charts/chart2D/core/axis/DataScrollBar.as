package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.model.DataBarStyle;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class DataScrollBar extends Sprite
	{
		public function DataScrollBar(axis:AxisBase, style:DataBarStyle)
		{
			super();
			this.axis = axis;
			this.barStyle = style;
			this.addChild(window);
			
			axis.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0 , true);
			axis.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		private var window:DataBarWindow = new DataBarWindow;
		
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
			currenPos = evt.stageX;
		}
		
		/**
		 */		
		private var currenPos:Number = 0;
		
		/**
		 */		
		private function dragHandler(evt:MouseEvent):void
		{
			var offset:Number = currenPos - evt.stageX;
			axis.scrollingData(offset / (max - min));
			currenPos = evt.stageX;
			axis.stopTip();
		}
		
		/**
		 */		
		private function stopDragHandler(evt:MouseEvent):void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.DATA_SCROLLED));
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
			min = startPerc;
			max = endPerc; 
				
			window.graphics.clear();
			
			var w:Number = (endPerc - startPerc) * axis.size;
			window.graphics.beginFill(0, 0.5);
			window.graphics.drawRect(startPerc * axis.size, axis.labelUIsCanvas.height, w, barHeight);
		}
		
		/**
		 */		
		private var min:Number = 0;
		private var max:Number = 0;
		
		/**
		 */		
		private var axis:AxisBase;
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			barStyle.barBG.width = axis.size;
			barStyle.barBG.ty = axis.labelUIsCanvas.height;
			StyleManager.drawRect(this, barStyle.barBG);
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