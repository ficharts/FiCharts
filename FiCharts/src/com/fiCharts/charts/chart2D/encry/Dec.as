package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.utils.dec.hash.MD5;
	import com.fiCharts.utils.dec.symmetric.AESKey;
	import com.fiCharts.utils.dec.symmetric.CBCMode;
	import com.fiCharts.utils.dec.symmetric.ICipher;
	import com.fiCharts.utils.dec.symmetric.IPad;
	import com.fiCharts.utils.dec.symmetric.IVMode;
	import com.fiCharts.utils.dec.symmetric.PKCS5;
	import com.fiCharts.utils.dec.symmetric.SimpleIVMode;
	
	import flash.utils.ByteArray;

	/**
	 */	
	public class Dec
	{
		public function Dec()
		{
		}
		
		/**
		 */		
		public function run(shell:ChartShellBase):void
		{
			configByte = ByteArray(new Config);
			licenseByte = ByteArray(new License);
			
			//decryConfigFile(new MD5().hash(licenseByte));
			
			licenseByte.uncompress();
			configByte.uncompress();
			shell.setDefaultConfig(configByte.toString());
			
			verify(XML(licenseByte.toString()));
			
			shell.init();
		}
		
		/**
		 */		
		private function verify(licenseXML:XML):void
		{
			
		}
		
		/**
		 * 根据license的md5信息 解密配置文件;
		 */		
		private function decryConfigFile(licenseMd5:ByteArray):void
		{
			var pad:IPad = new PKCS5;
			var mode:ICipher = new SimpleIVMode(new CBCMode(new AESKey(licenseMd5), pad) as IVMode);
			pad.setBlockSize(mode.getBlockSize());
			mode.yy(configByte);
		}
		
		/**
		 */		
		private var configByte:ByteArray;
		
		/**
		 */		
		private var licenseByte:ByteArray;
		
		/**
		 */		
		public var License:Class;
		
		/**
		 */		
		public var Config:Class;
	}
}