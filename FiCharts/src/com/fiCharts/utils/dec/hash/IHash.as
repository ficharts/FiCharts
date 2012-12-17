/**
 * IHash
 * 
 * An interface for each hash function to implement
 */
package com.fiCharts.utils.dec.hash
{
	import flash.utils.ByteArray;

	public interface IHash
	{
		function getInputSize():uint;
		function getHashSize():uint;
		function hash(src:ByteArray):ByteArray;
		function toString():String;
	}
}