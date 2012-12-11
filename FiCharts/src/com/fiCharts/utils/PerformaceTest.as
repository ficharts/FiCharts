package com.fiCharts.utils
{
	import flash.utils.getTimer;

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
				trace(desc + " : " + (getTimer() - time) / 1000 + "s");
		}
		
		/**
		 */		
		public static function start(value:String = "start"):void
		{
			if (ifRun)
			{
				time = getTimer();
				trace("start : " + value);
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
				
				trace(desc + " : " + (getTimer() - preT) / 1000 + "s");
			}
			
		}
	}
}