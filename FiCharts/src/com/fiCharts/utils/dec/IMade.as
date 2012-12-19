/**
 * IHash
 * 
 * An interface for each hash function to implement
 */
package com.fiCharts.utils.dec
{
	import flash.utils.ByteArray;

	/**
	 * IHash
	 */	
	public interface IMade
	{
		function getInputSize():uint;
		function getSize():uint;
		function fuck(src:ByteArray):ByteArray;
		function toString():String;
	}
}