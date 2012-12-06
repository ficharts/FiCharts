package com.fiCharts.utils
{
	import com.adobe.images.PNGEncoder;
	import com.fiCharts.utils.graphic.BitmapUtil;
	
	import flash.display.DisplayObject;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 */	
	public class ImgSaver
	{
		public function ImgSaver()
		{
		}
		
		/**
		 * 将对象截图并保存图片
		 */		
		public static function saveImg(target:DisplayObject, name:String):void
		{
			var imageByteArray:ByteArray = PNGEncoder.encode(BitmapUtil.draw(target));
			var file:FileReference = new FileReference();
			file.save(imageByteArray, 'name');
		}
		
		/**
		 * 将对象截图并反馈此图片的base64字符串
		 */		
		public static function get64Data(target:DisplayObject):String
		{
			var imageByteArray:ByteArray = PNGEncoder.encode(BitmapUtil.draw(target));
			
			return Base64.encode(imageByteArray);
		}
		
		
	}
}