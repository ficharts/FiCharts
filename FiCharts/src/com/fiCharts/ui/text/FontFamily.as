package com.fiCharts.ui.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class FontFamily
	{
		private static var _TextFormat:TextFormat;
		
		/**
		 * @param $fontName
		 */		
		public static function setFont( $fontName : String ) : void
		{
			format.font = $fontName;
		}
		
		/**
		 * @return 
		 */		
		public static function get format():TextFormat
		{
			if (!_TextFormat)
			{
				_TextFormat = new TextFormat();
				_TextFormat.color = 0x000000;
				_TextFormat.size = 12;
				_TextFormat.align = "left"; 
				_TextFormat.kerning = true;
				//_TextFormat.letterSpacing = 2;
				//_TextFormat.leading = 5;
			}
			
			return _TextFormat;
		}
		
		/**
		 * 
		 * @param $textField
		 * 
		 */		
		public static function setFontForTextField($textField:TextField):void
		{
			$textField.selectable = false;
			$textField.mouseEnabled = false;	
			//$textField.embedFonts = true;
			$textField.autoSize = TextFieldAutoSize.LEFT;
			$textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			$textField.gridFitType = flash.text.GridFitType.PIXEL;
		}
		
		/**
		 */		
		public  function FontFamily()
		{
		}
	}
}