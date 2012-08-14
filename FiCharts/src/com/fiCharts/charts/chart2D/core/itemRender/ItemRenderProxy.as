package com.fiCharts.charts.chart2D.core.itemRender
{
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	import flash.display.Sprite;
	
	/**
	 * 不接收鼠标事件的 ItemRender， 只做显示只用，可以控制工具提示的显示与关闭；
	 */	
	public class ItemRenderProxy extends ItemRenderBace
	{
		public function ItemRenderProxy(ifVisible:Boolean = true)
		{
			this.hitArea = canvas;
			
			canvas.mouseEnabled = false;
			canvas.visible = ifVisible;
			addChild(canvas);
		}
		
		/**
		 */		 
		override public function disable():void
		{
			_itemVO.removeEventListener(ItemRenderEvent.SHOW_TOOLTIP, showTooltipHandler);
			_itemVO.removeEventListener(ItemRenderEvent.HIDE_TOOLTIP, hideTooltipHandler);
			
			_itemVO.removeEventListener(ItemRenderEvent.SHOW_ITEM_RENDER, showItemRenderHandler);
			_itemVO.removeEventListener(ItemRenderEvent.HIDE_ITEM_RENDER, hideItemRenderHandler);
			
			this.statesContorl.enable = this._isEnable = false;
		}
		
		/**
		 */		
		override public function enable():void
		{
			this.statesContorl.enable = this._isEnable = true;
			
			_itemVO.addEventListener(ItemRenderEvent.SHOW_TOOLTIP, showTooltipHandler, false, 0, true);
			_itemVO.addEventListener(ItemRenderEvent.HIDE_TOOLTIP, hideTooltipHandler, false, 0, true);
			
			_itemVO.addEventListener(ItemRenderEvent.SHOW_ITEM_RENDER, showItemRenderHandler, false, 0, true);
			_itemVO.addEventListener(ItemRenderEvent.HIDE_ITEM_RENDER, hideItemRenderHandler, false, 0, true);
		}
		
		/**
		 */		
		override public function set itemVO(value:SeriesDataItemVO):void
		{
			super.itemVO = value;
			
			_itemVO.addEventListener(ItemRenderEvent.SHOW_TOOLTIP, showTooltipHandler, false, 0, true);
			_itemVO.addEventListener(ItemRenderEvent.HIDE_TOOLTIP, hideTooltipHandler, false, 0, true);
			
			_itemVO.addEventListener(ItemRenderEvent.SHOW_ITEM_RENDER, showItemRenderHandler, false, 0, true);
			_itemVO.addEventListener(ItemRenderEvent.HIDE_ITEM_RENDER, hideItemRenderHandler, false, 0, true);
			
			// 代理类型的渲染节点默认是不可见;
		}

		/**
		 */		
		private function showItemRenderHandler(evt:ItemRenderEvent):void
		{
			canvas.visible = true;
		}
		
		/**
		 */		
		private function hideItemRenderHandler(evt:ItemRenderEvent):void
		{
			canvas.visible = false;
		}
		
		/**
		 */		
		protected function showTooltipHandler(evt:ItemRenderEvent):void
		{
			showToolTips();
		}
		
		/**
		 */		
		protected function hideTooltipHandler(evt:ItemRenderEvent):void
		{
			hideToolTips();
		}
	}
}