/**
 * CBCMode
 * 
 * An ActionScript 3 implementation of the CBC confidentiality mode
 * 
 */
package com.fiCharts.utils.dec.symmetric
{
	import flash.utils.ByteArray;
	
	/**
	 * CBC confidentiality mode. why not.
	 */
	public class CBCMode extends IVMode implements IMode
	{
		
		public function CBCMode(key:ISymmetricKey, padding:IPad = null) {
			super(key, padding);
		}

		/**
		 * 加密
		 */		
		public function jj(src:ByteArray):void {
			padding.pad(src);
			var vector:ByteArray = getIV4e();
			for (var i:uint=0;i<src.length;i+=blockSize) {
				for (var j:uint=0;j<blockSize;j++) {
					src[i+j] ^= vector[j];
				}
				key.encrypt(src, i);
				vector.position=0;
				vector.writeBytes(src, i, blockSize);
			}
		}
		
		/**
		 * 解密
		 */		
		public function yy(src:ByteArray):void {
			var vector:ByteArray = getIV4d();
			var tmp:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i+=blockSize) {
				tmp.position=0;
				tmp.writeBytes(src, i, blockSize);
				key.decrypt(src, i);
				for (var j:uint=0;j<blockSize;j++) {
					src[i+j] ^= vector[j];
				}
				vector.position=0;
				vector.writeBytes(tmp, 0, blockSize);
			}
			padding.unpad(src);
		}
		
		/**
		 */		
		public function toString():String {
			return key.toString()+"-cbc";
		}
	}
}
