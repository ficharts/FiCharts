package com.fiCharts.utils.XMLConfigKit
{
	public interface IApp
	{
		/**
		 * 每个应用拥有自己的对象库， 此方法用于将app自己的对象库
		 * 
		 * 更新到唯一的公共库上 
		 */		
		function resetLib():void;
		
	}
}