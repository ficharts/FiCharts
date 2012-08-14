package com.fiCharts.utils.graphic
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 */	
	public class TextBitmapUtil
	{
		public function TextBitmapUtil()
		{
		}
		
		/**
		 */		
		public static function drawUI(target:DisplayObject):Bitmap
		{
			var bw:Number = target.width;
			var bh:Number = target.height;
			var myBitmapData:BitmapData = new BitmapData(bw, bh, true, 0xFFFFFF);
			myBitmapData.draw(target, null, null, null, null, true);
			
			var bmp:Bitmap = new Bitmap(myBitmapData, PixelSnapping.ALWAYS, true);
			
			return bmp;
		}

		/**
		 */
		public static function drawText(_text:String, _textFmt:TextFormat = null):Bitmap
		{
			var textfield:TextField = new TextField();
			textfield.text = _text;

			if (_textFmt == null)
			{
				var textFmt:TextFormat = new TextFormat();
				textFmt.color = 0x333333;
				textFmt.size = 12;
				textFmt.align = "left";
				textFmt.bold = false;
				textfield.setTextFormat(textFmt);
			}
			else
			{
				textfield.setTextFormat(_textFmt);
			}

			textfield.autoSize = TextFieldAutoSize.CENTER;

			var bw:Number = textfield.width;
			var bh:Number = textfield.height;
			var myBitmapData:BitmapData = new BitmapData(bw, bh, true, 0xFFFFFF);
			myBitmapData.draw(textfield, null, null, null, null, false);

			var bmp:Bitmap = new Bitmap(myBitmapData, PixelSnapping.ALWAYS, true);
			return bmp;
		}
	}
}