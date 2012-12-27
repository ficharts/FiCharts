package com.fiCharts.charts.chart2D.encry
{
	import flash.display.Sprite;
	
	/**
	 * License信息
	 */	
	public class LM extends Sprite
	{
		
		/**
		 * 试用版
		 */		
		public static const TRIAL:String = 'Trial';
		
		/**
		 * 客户端方式授权
		 */		
		public static const DESK:String = 'Desk';
		
		/**
		 */		
		public static const APP:String = "App";
		
		/**
		 */		
		public function LM()
		{
			
		}
		
		/**
		 */
		public function get url():String
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			domains.push(value);
		}
		
		/**
		 */		
		public function get mac():String
		{
			return null;
		}

		/**
		 */		
		public function set mac(value:String):void
		{
			macs.push(value);
		}
		
		/**
		 */		
		public var macs:Array = [];

		/**
		 */		
		public function get app():String
		{
			return null;
		}

		public function set app(value:String):void
		{
			apps.push(value);
		}
		
		/**
		 */		
		public var apps:Array = [];

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
		 * 认证类型; Web, Intranet, Enterprise, Enterprise_Plus, Desk 
		 */		
		public var type:String ='Web';
		
		/**
		 * 服务器信息
		 */		
		public var domains:Array = [];
		
		/**
		 */		
		public var desc:String;
	}
}