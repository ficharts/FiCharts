package com.fiCharts.utils
{
	import com.fiCharts.utils.system.FiTrace;
	
	import flash.utils.getTimer;

	/**
	 * 
	 */	
	public class PerformaceTest
	{
		public function PerformaceTest()
		{
		}
		
		/**
		 */		
		public static var ifRun:Boolean = false;
		
		/**
		 */		
		public static function end(desc:String = 'tem'):void
		{
			if (ifRun)
				FiTrace.info("end: " +  desc + " --- " + (getTimer() - time) / 1000 + "s");
		}
		
		/**
		 */		
		public static function start(value:String = "start"):void
		{
			if (ifRun)
			{
				time = getTimer();
				FiTrace.info("start : " + value);
			}
		}
		
		/**
		 */		
		private static var time:uint = 0;
		
		/**
		 */		
		public static function funTest(fun:Function, desc:String = "method"):void
		{
			if (ifRun)
			{
				var preT:Number = flash.utils.getTimer();
				
				fun();
				
				FiTrace.info(desc + " : " + (getTimer() - preT) / 1000 + "s");
			}
			
		}
	}
}