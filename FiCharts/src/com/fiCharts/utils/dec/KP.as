/**
 * PKCS5
 * 
 * A padding implementation of PKCS5.
 * 
 */
package com.fiCharts.utils.dec
{
	import flash.utils.ByteArray;
	
	public class KP implements IPad
	{
		private var blockSize:uint;
		
		public function KP(blockSize:uint=0) {
			this.blockSize = blockSize;
		}
		
		public function pad(a:ByteArray):void {
			var c:uint = blockSize-a.length%blockSize;
			for (var i:uint=0;i<c;i++){
				a[a.length] = c;
			}
		}
		public function unpad(a:ByteArray):void {
			var c:uint = a.length%blockSize;
			if (c!=0) throw new Error("PKCS#5::unpad: ByteArray.length isn't a multiple of the blockSize");
			c = a[a.length-1];
			for (var i:uint=c;i>0;i--) {
				var v:uint = a[a.length-1];
				a.length--;
				if (c!=v) throw new Error("PKCS#5:unpad: Invalid padding value. expected ["+c+"], found ["+v+"]");
			}
			// that is all.
		}

		public function setBlockSize(bs:uint):void {
			blockSize = bs;
		}

	}
}