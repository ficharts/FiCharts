package com.fiCharts.charts.chart2D.encry
{
	import com.fiCharts.utils.ExternalUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.dec.CCB;
	import com.fiCharts.utils.dec.ICipher;
	import com.fiCharts.utils.dec.IPad;
	import com.fiCharts.utils.dec.IVMode;
	import com.fiCharts.utils.dec.KP;
	import com.fiCharts.utils.dec.Made;
	import com.fiCharts.utils.dec.SEA;
	import com.fiCharts.utils.dec.VI;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.system.OS;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * 
	 * 负责解密、License验证、水印显示
	 */	
	public class Dec
	{
		public function Dec()
		{
		}
		
		/**
		 */		
		public function run(shell:CSB):void
		{
			this.shell = shell;
			
			configByte = ByteArray(new Meta);
			licenseByte = ByteArray(new Lc);
			
			var md5:Made = new Made;
			decryConfigFile(md5.fuck(licenseByte));
			
			licenseByte.uncompress();
			configByte.uncompress();
			shell.setDefaultConfig(configByte.toString());
			shell.init();
			
			verify();
		}
		
		/**
		 */		
		private var shell:CSB;
		
		/**
		 */		
		private function verify():void
		{
			var licenseVO:LM = new LM;
			var liXML:XML = XML(licenseByte.toString());
			XMLVOMapper.fuck(liXML, licenseVO);
			XMLVOMapper.fuck(liXML.servers, licenseVO);
			var ifSuccess:Boolean = false;
			
			if (licenseVO.type == LM.TRIAL) // 免费版
			{
				createLicenseInfo('www.ficharts.com');
			}
			else if (licenseVO.type == LM.DESK)// 桌面客户端授权
			{
				if (OS.isDesktopSystem)
				{
					var netInfo:Object = getDefinitionByName("flash.net.NetworkInfo").networkInfo;
					var interfaceVector:Object = netInfo.findInterfaces();
					var mac:String = interfaceVector[0].hardwareAddress;
					
					for each (var url:String in licenseVO.domains)
					{
						if (url == mac)
						{
							ifSuccess = true;
							break;
						}
					}
					
					if (ifSuccess == false)
						createLicenseInfo('www.ficharts.com');
					
				}
				else// web 下想用desk的license， 没门
				{
					createLicenseInfo('www.ficharts.com');
				}
			}
			else if (licenseVO.type == LM.APP)// 应用ID授权
			{
				// toDO
				var appID:String = getDefinitionByName("flash.desktop.NativeApplication").nativeApplication.applicationID;
				for each (var id:String in licenseVO.domains)
				{
					if (appID == id)
					{
						ifSuccess = true;
						break;
					}
				}
				
				if (ifSuccess == false)
					createLicenseInfo('www.ficharts.com');
				
			}
			else // 服务区授权
			{
				var fullURL:String = shell.stage.loaderInfo.url;
				var serverURL:String = getServerName(fullURL);
				
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
			var pad:IPad = new KP;
			var aesKey:SEA = new SEA(licenseMd5);
			var cbcMode:CCB = new CCB(aesKey, pad)
			var mode:ICipher = new VI(cbcMode as IVMode);
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
		public var Lc:Class;
		
		/**
		 */		
		public var Meta:Class;
	}
}