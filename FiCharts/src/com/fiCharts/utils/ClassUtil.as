package com.fiCharts.utils
{
	import flash.utils.getDefinitionByName;
	
	/**
	 */	
	public class ClassUtil
	{
		public function ClassUtil()
		{
		}
		
		/**
		 * @return 
		 */		
		public static function getObjectByClassPath(path:String, parm:Object = null):Object
		{
			var result:Object;
			
			try
			{
				var TargetClass:Class = getDefinitionByName(path) as Class;
				
				if (parm)
					result = new TargetClass(parm);
				else
					result = new TargetClass();
			}
			catch (e:Error)
			{
				trace("GET CLASS WRONG: " + path);
			}
			
			return result;
		}
	}
}