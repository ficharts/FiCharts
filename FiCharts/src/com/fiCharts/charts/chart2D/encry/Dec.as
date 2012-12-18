package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.utils.ExternalUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.dec.hash.MD5;
	import com.fiCharts.utils.dec.symmetric.AESKey;
	import com.fiCharts.utils.dec.symmetric.CBCMode;
	import com.fiCharts.utils.dec.symmetric.ICipher;
	import com.fiCharts.utils.dec.symmetric.IPad;
	import com.fiCharts.utils.dec.symmetric.IVMode;
	import com.fiCharts.utils.dec.symmetric.PKCS5;
	import com.fiCharts.utils.dec.symmetric.SimpleIVMode;
	import com.fiCharts.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
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
			this.shell = shell;
			
			configByte = ByteArray(new Config);
			licenseByte = ByteArray(new License);
			
			decryConfigFile(new MD5().hash(licenseByte));
			
			licenseByte.uncompress();
			configByte.uncompress();
			shell.setDefaultConfig(configByte.toString());
			shell.init();
			
			verify();
		}
		
		/**
		 */		
		private var shell:ChartShellBase;
		
		/**
		 */		
		private function verify():void
		{
			var licenseVO:LiInfo = new LiInfo;
			var liXML:XML = XML(licenseByte.toString());
			XMLVOMapper.fuck(liXML, licenseVO);
			XMLVOMapper.fuck(liXML.servers, licenseVO);
			
			if (licenseVO.type == LiInfo.TRIAL) // 免费版
			{
				createLicenseInfo('www.ficharts.com');
			}
			else if (licenseVO.type == LiInfo.CLIENT)
			{
				
			}
			else // 正式版
			{
				var fullURL:String = shell.stage.loaderInfo.url;
				var serverURL:String = getServerName(fullURL);
				var ifSuccess:Boolean = false;
				
				for each (var domain:String in licenseVO.domains)
				{
					if (serverURL.indexOf(domain) != -1)
					{
						ifSuccess = true;
						break;
					}
				}
				
				if (fullURL.indexOf('localhost') != -1)
					ifSuccess = true;
				
				if (ifSuccess == false)
					createLicenseInfo('www.ficharts.com');
			}
			
			ExternalUtil.call('license', licenseVO);
		}
		
		/**
		 */		
		private function createLicenseInfo(info:String):void
		{
			var label:LabelUI = new LabelUI;
			var labelStyle:LabelStyle = new LabelStyle;
			XMLVOMapper.fuck(labelStyleXML, labelStyle);
			label.style = labelStyle;
			label.text = info;
			label.render();
			
			waterLabel = BitmapUtil.drawBitmap(label, true);
			label = null;
			
			shell.stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
			waterLabel.alpha = 0.5;
			shell.addChild(waterLabel);
			layoutWaterLabel();
		}
		
		/**
		 * 
		 */		
		private var waterLabel:Bitmap;
		
		/**
		 */		
		private function stageResized(evt:Event):void
		{
			layoutWaterLabel();
		}
		
		/**
		 */		
		private function layoutWaterLabel():void
		{
			waterLabel.width = shell.width * 0.8;
			waterLabel.scaleY = waterLabel.scaleX;
			
			waterLabel.x = (shell.width - waterLabel.width) / 2;
			waterLabel.y = (shell.height - waterLabel.height) / 2 - waterLabel.height;
		}
		
		/**
		 */		
		private var labelStyleXML:XML = <label>
							                <format size='280' color='555555' bold='true' font='微软雅黑'/>
							            </label>
		
		/**
		 * 剔除协议仅保留www.xxx.com或者 xxx.com
		 */		
		protected function getServerName(url:String):String
		{
			var sp:String = getServerNameWithPort(url);
			
			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = sp.indexOf("]");
			delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");   
			
			if (delim > 0)
				sp = sp.substring(0, delim);
			return sp;
		}
		
		/**
		 */		
		private function getServerNameWithPort(url:String):String
		{
			// Find first slash; second is +1, start 1 after.
			var start:int = url.indexOf("/") + 2;
			var length:int = url.indexOf("/", start);
			return length == -1 ? url.substring(start) : url.substring(start, length);
		}
		
		/**
		 * 根据license的md5码 解密配置文件;
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