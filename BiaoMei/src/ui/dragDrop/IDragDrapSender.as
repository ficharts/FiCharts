package ui.dragDrop
{
	import flash.events.IEventDispatcher;

	public interface IDragDrapSender extends IEventDispatcher
	{
		function enable():void;
		function disEnable():void;
	}
}