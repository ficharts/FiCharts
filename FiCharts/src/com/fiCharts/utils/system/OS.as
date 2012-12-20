package com.fiCharts.utils.system
{
	import com.fiCharts.utils.ClassUtil;
	
	import flash.net.LocalConnection;

	/**
	 */	
	public class OS
	{
		public function OS()
		{
			
		}
		
		/**
		 * 是否为网页环境
		 */		
		public static function get isWebSystem():Boolean
		{
			checkSystem();
			
			return ifWeb;
		}
		
		/**
		 * 目前移动操作系统不支持此特性，咱用此来判断系统类型；
		 */		
		public static function get isDesktopSystem():Boolean
		{
			checkSystem();
			
			return ifDeskAIR;
		}
		
		/**
		 */		
		public static function get isMobileSystem():Boolean
		{
			checkSystem();
			
			return ifMobile;
		}
		
		/**
		 */		
		private static function checkSystem():void
		{
			if (isChecked == false)
			{
				if (ClassUtil.getObjectByClassPath("flash.desktop.NativeProcess"))
					ifDeskAIR = true;
				else
					ifDeskAIR = false;
				
				if (LocalConnection.isSupported == false)
					ifMobile = true;
				else
					ifMobile = false;
				
				if (ifDeskAIR == false && ifMobile == false)
					ifWeb = true;
				else
					ifWeb = false;
				
				isChecked = true;
			}
		}
		
		/**
		 */		
		private static var isChecked:Boolean = false;
		
		/**
		 * 是否是桌面AIR环境
		 */		
		private static var ifDeskAIR:Boolean = false;
		
		/**
		 * 是否是移动环境
		 */		
		private static var ifMobile:Boolean = false;
		
		/**
		 */		
		private static var ifWeb:Boolean = false;
		
		
		
	}
}