package com.fiCharts.utils.XMLConfigKit.effect
{
	/**
	 * 每个滤镜文件都要继承此
	 */	
	public interface IEffectElement
	{
		/**
		 * 获取真正的滤镜对象
		 */		
		function getEffect(metaData:Object):Object;
	}
}