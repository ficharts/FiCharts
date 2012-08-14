package com.fiCharts.charts.common.language
{
	public class LanguageConfig
	{
		public function LanguageConfig()
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

		/**
		 */		
		private var _licenseExpended:String;

		public function get licenseExpended():String
		{
			return _licenseExpended;
		}

		public function set licenseExpended(value:String):void
		{
			_licenseExpended = value;
		}

		/**
		 */		
		private var _forDeploy:String;

		public function get forDeploy():String
		{
			return _forDeploy;
		}

		public function set forDeploy(value:String):void
		{
			_forDeploy = value;
		}

		/**
		 */		
		private var _trailDateExpended:String;

		public function get trailDateExpended():String
		{
			return _trailDateExpended;
		}

		public function set trailDateExpended(value:String):void
		{
			_trailDateExpended = value;
		}
		
	}
}