package com.fiCharts.ui.clickMove
{
	/**
	 * 被多动的对象
	 */	
	public interface IClickMove
	{
		/**
		 * 
		 * 偏移元件，参数为x，y的偏移量
		 * 
		 * 新位置 = 现有位置 + 偏移量
		 * 
		 * @param xOff
		 * @param yOff
		 * 
		 */		
		function moveOff(xOff:Number, yOff:Number):void;	
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		function clicked():void;
		
		/**
		 */		
		function startMove():void
			
		/**
		 */			
		function stopMove():void;
	}
}