package com.fiCharts.utils.system
{
	import com.fiCharts.utils.ExternalUtil;

	/**
	 */	
	public class FiTrace
	{
		public function FiTrace()
		{
		}
		
		/**
		 */		
		public static var isOpen:Boolean = false;
		
		/**
		 */		
		public static var ifAlert:Boolean = false;
		
		/**
		 * 
		 */		
		public static function info(value:String):void
		{
			if (isOpen)
				trace(value);
			
			if (ifAlert)
				ExternalUtil.call("alert", value);
		}
	}
}