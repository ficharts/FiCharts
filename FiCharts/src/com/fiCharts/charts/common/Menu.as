package com.fiCharts.charts.common
{
	public class Menu
	{
		public function Menu()
		{
		}
		
		/**
		 */		
		private var _saveASImage:String;

		/**
		 */
		public function get saveAsImage():String
		{
			return _saveASImage;
		}

		/**
		 * @private
		 */
		public function set saveAsImage(value:String):void
		{
			_saveASImage = value;
		}

		/**
		 * 
		 */		
		private var _about:String;

		public function get about():String
		{
			return _about;
		}

		public function set about(value:String):void
		{
			_about = value;
		}

		/**
		 */		
		private var _version:String;

		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			_version = value;
		}
		
	}
}