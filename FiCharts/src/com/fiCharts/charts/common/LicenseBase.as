package com.fiCharts.charts.common
{
	import flash.display.Sprite;
	
	public class LicenseBase extends Sprite
	{
		/**
		 * 表准版本 
		 */		
		public static const STANDARD:String = 'standard';
		
		/**
		 * 企业版 
		 */		
		public static const ENTERPRISE:String = 'enterprise';
		
		/**
		 * 试用版
		 */		
		public static const TRIAL:String = 'trial';
		
		/**
		 */		
		public function LicenseBase()
		{
			
		}
		
		/**
		 * 公司名称
		 */		
		public var company:String;
		
		/**
		 * 公司地址
		 */		
		public var location:String;
		
		/**
		 * 公司联系电话
		 */		
		public var telephone:String;
		
		/**
		 * 公司邮箱
		 */		
		public var email:String;
		
		/**
		 * 认证类型; enterprise, website;
		 */		
		public var licenseType:String ='website';
		
		/**
		 * 服务器信息
		 */		
		public var domains:Array = [];
	}
}