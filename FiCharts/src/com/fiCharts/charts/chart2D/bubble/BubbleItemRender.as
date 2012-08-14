package com.fiCharts.charts.chart2D.bubble
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 */	
	public class BubbleItemRender extends ItemRenderBace
	{
		public function BubbleItemRender()
		{
			super();
		}
		
		/**
		 */		
		override public function enable():void
		{
			_isEnable = true;
		}
		
		/**
		 */		
		override public function disable():void
		{
			_isEnable = false;
		}
		
		/**
		 */		
		private var _bubbleLabel:String;

		/**
		 */
		public function get bubbleLabel():String
		{
			return _bubbleLabel;
		}

		/**
		 * @private
		 */
		public function set bubbleLabel(value:String):void
		{
			_bubbleLabel = value;
		}
		
		/** 
		 */		
		override public function render():void
		{
			style.radius = itemVO.z;
			
			//更新正确的Radius值， style.radius 是共有的， 每个bubble的radius值不同；
			this.radius = itemVO.z;
			
			// 绘制圆圈
			style.tx = style.ty = - style.radius;
			style.width = style.height = style.radius * 2;
			
			canvas.graphics.clear();
			StyleManager.drawCircle(this.canvas, style, itemVO.metaData);
		}
		
		/**
		 */		
		override protected function layoutValueLabel():void
		{
			valueLabelUI.x = - valueLabelUI.width / 2;
			valueLabelUI.y = - valueLabelUI.height / 2;
			
			// 当柱体太小不能容纳标签时隐藏标签；
			if (this.itemVO.z * 2 < valueLabelUI.width)
				valueLabelUI.visible = false;
			else
				valueLabelUI.visible = true;
		}
		
		/**
		 */		
		override protected function get zTipLabel():String
		{
			var bubbleTip:String;
			bubbleTip = itemVO.zLabel;
			
			if (itemVO.zDisplayName)
				bubbleTip = itemVO.zDisplayName + ':' + bubbleTip;
			
			return '<br>' + bubbleTip;
		}
	}
}