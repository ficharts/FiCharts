package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.series.SeriesItemUIBase;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 */	
	public class PartLineUI extends SeriesItemUIBase
	{
		public function PartLineUI(dataItem:SeriesDataItemVO)
		{
			super(dataItem);
			
			canvas.mask = maskUI;
			addChild(canvas);
			addChild(maskUI);
		}
		
		/**
		 */		
		public function show():void
		{
			
		}
		
		/**
		 */		
		public function hide():void
		{
			
		}
		
		
		/**
		 */		
		protected var _partUIRender:LineSeries;

		/**
		 */
		public function get partUIRender():LineSeries
		{
			return _partUIRender;
		}

		/**
		 * @private
		 */
		public function set partUIRender(value:LineSeries):void
		{
			_partUIRender = value;
		}
		
		/**
		 */		
		override public function render():void
		{
			maskUI.graphics.clear();
			maskUI.graphics.beginFill(0, 0.3);
			maskUI.graphics.drawRect(locX, this.locY, this.locWidth, this.locHeight);
			maskUI.graphics.endFill();
			
			partUIRender.renderPartUI(canvas, this.style, this.metaData, this.renderIndex);
		}
		
		/**
		 * 此节点在整个数据节点中的位置 
		 * 
		 * 当前正在被渲染的节点 ， 每个节点的渲染是以此节点为中心向两边
		 * 
		 * 各延伸一个节点
		 */		
		public var renderIndex:uint;
		
		/**
		 */		
		protected var maskUI:Shape = new Shape;
		
		/**
		 */		
		protected var canvas:Shape = new Shape;
		
		/**
		 */		
		private var _locX:Number = 0;

		/**
		 */
		public function get locX():Number
		{
			return _locX;
		}

		/**
		 * @private
		 */
		public function set locX(value:Number):void
		{
			_locX = value;
		}

		/**
		 */		
		private var _locY:Number = 0;

		/**
		 */
		public function get locY():Number
		{
			return _locY;
		}

		/**
		 * @private
		 */
		public function set locY(value:Number):void
		{
			_locY = value;
		}

		/**
		 */		
		private var _locWidth:Number = 0;

		/**
		 */
		public function get locWidth():Number
		{
			return _locWidth;
		}

		/**
		 * @private
		 */
		public function set locWidth(value:Number):void
		{
			_locWidth = value;
		}

		/**
		 */		
		private var _locHeight:Number = 0;

		/**
		 */
		public function get locHeight():Number
		{
			return _locHeight;
		}

		/**
		 * @private
		 */
		public function set locHeight(value:Number):void
		{
			_locHeight = value;
		}

	}
}