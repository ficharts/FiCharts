/**
 * SimpleIVMode
 * 
 * A convenience class that automatically places the IV
 * at the beginning of the encrypted stream, so it doesn't have to
 * be handled explicitely.
 * 
 */
package com.fiCharts.utils.dec.symmetric
{
	import flash.utils.ByteArray;
	import com.fiCharts.utils.dec.Memory;
	
	public class SimpleIVMode implements IMode, ICipher
	{
		protected var mode:IVMode;
		protected var cipher:ICipher;
		
		public function SimpleIVMode(mode:IVMode) {
			this.mode = mode;
			cipher = mode as ICipher;
		}
		
		public function getBlockSize():uint {
			return mode.getBlockSize();
		}
		
		public function dispose():void {
			mode.dispose();
			mode = null;
			cipher = null;
			Memory.gc();
		}
		
		public function jj(src:ByteArray):void {
			cipher.jj(src);
			var tmp:ByteArray = new ByteArray;
			tmp.writeBytes(mode.IV);
			tmp.writeBytes(src);
			src.position=0;
			src.writeBytes(tmp);
		}
		
		public function yy(src:ByteArray):void {
			var tmp:ByteArray = new ByteArray;
			tmp.writeBytes(src, 0, getBlockSize());
			mode.IV = tmp;
			tmp = new ByteArray;
			tmp.writeBytes(src, getBlockSize());
			cipher.yy(tmp);
			src.length=0;
			src.writeBytes(tmp);
		}
		public function toString():String {
			return "simple-"+cipher.toString();
		}
	}
}