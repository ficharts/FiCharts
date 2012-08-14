package com.fiCharts.utils.XMLConfigKit.effect
{
	/**
	 * 可以被附加滤镜效果的对象需要继承此接口
	 */	
	public interface IEffectable
	{
		function get effects():Object
		function set effects(value:Object):void;
		
	}
}