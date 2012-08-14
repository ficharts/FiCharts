package com.fiCharts.utils.system 
{
	import flash.net.LocalConnection;
	
	/**
	 *  Used for clearing. 
	 * 
	 * @author wallen
	 * 
	 */	
	public class GC 
	{
		/**
		 */		
		public function GC() 
		{
		}
		
		public static function run():void 
		{
			try 
			{
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			} 
			catch (error:Error) 
			{
				//trace("clear success")                  
			}
		}
	}
}