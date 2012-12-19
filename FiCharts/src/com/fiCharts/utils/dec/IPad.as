/**
 * IPad
 * 
 * An interface for padding mechanisms to implement.
 * 
 */
package com.fiCharts.utils.dec
{
	import flash.utils.ByteArray;
	
	/**
	 * Tiny interface that represents a padding mechanism.
	 */
	public interface IPad
	{
		/**
		 * Add padding to the array
		 */
		function pad(a:ByteArray):void;
		/**
		 * Remove padding from the array.
		 * @throws Error if the padding is invalid.
		 */
		function unpad(a:ByteArray):void;
		/**
		 * Set the blockSize to work on
		 */
		function setBlockSize(bs:uint):void;
	}
}