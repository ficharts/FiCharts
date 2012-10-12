package com.fiCharts.utils
{
	import flash.external.ExternalInterface;

	public class ExternalUtil
	{
		/**
		 * @param functionName
		 * @param handlerFunction
		 * 
		 */		
		public static function addCallback( functionName : String, handlerFunction : Function ) : void
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback( functionName, handlerFunction );
				}
				catch ( e : Error )
				{
					
				}
			}
		}
		
		/**
		 *  Support for no more than 3 args. 
		 * 
		 * @param functionName
		 * @param arg
		 * 
		 */		
		public static function call( functionName : String, ...arg ) : void
		{
			if (ExternalInterface.available)
			{
				try
				{
					if ( (arg as Array).length == 0 )
					{
						ExternalInterface.call( functionName );
					}
					else if ( ( arg as Array ).length == 1 )
					{
						ExternalInterface.call( functionName, arg[ 0 ] );
					}
					else if ( ( arg as Array ).length == 2 )
					{
						ExternalInterface.call( functionName, arg[ 0 ], arg[ 1 ] );
					}
					else if ( ( arg as Array ).length == 3 )
					{
						ExternalInterface.call( functionName, arg[ 0 ], arg[ 1 ], arg[ 2 ] );
					}
					
				}
				catch ( e : Error )
				{
					
				}
			}
			
		}
		
		/**
		 */		
		public function ExternalUtil()
		{
		}
	}
}