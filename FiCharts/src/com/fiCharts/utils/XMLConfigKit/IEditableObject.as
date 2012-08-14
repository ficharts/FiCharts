package com.fiCharts.utils.XMLConfigKit
{
	/**
	 * 有时通过XML创建的对象需要一些灵活的调整， 
	 * 
	 * 所以在属性映射前后需要调用此接口的方法;
	 * 
	 */	
	public interface IEditableObject
	{
		/**
		 * 在数据映射之前调用， 有时需要预映射一些属性；
		 */		
		function beforeUpdateProperties(xml:* = null):void;
		
		/**
		 * 对象已经被创建并且成为了父层的一个子对象 
		 */		
		function created():void;
	}
}