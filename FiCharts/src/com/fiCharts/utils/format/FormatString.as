package com.fiCharts.utils.format
{
	public class FormatString
	{
		/**
		 * @param sourceNum
		 * @return 
		 * 
		 */		
		public static function numToTwoBitString( sourceNum : Number ) : String
		{
			if ( sourceNum < 10 )
			{
				return '0' + sourceNum.toString();
			}
			else
			{
				return sourceNum.toString();
			}
		}
		
		/**
		 */		
		public function FormatString()
		{
		}
	}
}