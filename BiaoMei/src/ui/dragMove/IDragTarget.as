package ui.dragMove
{
	/**
	 * 可以被拖动的对象
	 */	
	public interface IDragTarget
	{
		function startDragHandler():void;
		function stopDragHandler():void;
	}
}