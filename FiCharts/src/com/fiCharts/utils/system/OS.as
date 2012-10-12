package com.fiCharts.utils.system
{
	import flash.net.LocalConnection;

	/**
	 */	
	public class OS
	{
		public function OS()
		{
		}
		
		/**
		 * 目前移动操作系统不支持此特性，咱用此来判断系统类型；
		 */		
		public static function get isDesktopSystem():Boolean
		{
			if (LocalConnection.isSupported)
				return true;
			else
				return false;
		}
	}
}