package com.fiCharts.utils.XMLConfigKit
{
	
	import flash.display.Sprite;
	
	/**
	 *  每个应用拥有一个属于自己的 XMLVOlib， 此对象库存储着
	 * 
	 *  应用内样式定义，对象模型，自定义类等信息
	 *  
	 *  应用初始化时这些信息注册进 XMLVOlib
	 */	
	public class App extends Sprite implements IApp
	{
		public function App()
		{
			super();
		}
		/**
		 */		
		private var xmlVOLib:XMLVOLib = new XMLVOLib;
		
		/**
		 * 
		 * 只要关系到注册，映射等关键操作时，记得调用此方法
		 * 
		 * 保证当前库为此应用的
		 * 
		 */		
		public function resetLib():void
		{
			XMLVOLib.currentLib = xmlVOLib;
		}
	}
}