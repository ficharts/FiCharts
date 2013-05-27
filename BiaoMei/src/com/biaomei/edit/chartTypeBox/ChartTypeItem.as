package com.biaomei.edit.chartTypeBox
{
	import ui.dragDrop.DragDropEvent;

	/**
	 * 代表序列类型，通过拖拽此完成创建和替换序列
	 */	
	public class ChartTypeItem extends ChartItemBase
	{
		public function ChartTypeItem(type:String, img:String)
		{
			super(type, img);
		}
		
		/**
		 */		 
		override public function downHandler():void
		{
			var event:DragDropEvent = new DragDropEvent(DragDropEvent.WILL_START_DRAG);
			event.dragedUI = this;
			event.dragParm = this.type;
			
			this.dispatchEvent(event);
		}
		
	}
}