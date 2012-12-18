package com.fiCharts.utils.graphic
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;

	/**
	 */	
	public class BitmapUtil
	{
		public function BitmapUtil()
		{
		}
		
		/**
		 */		
		public static function drawBitmap(target:DisplayObject, ifSmooth:Boolean = false):Bitmap
		{
			var bmp:Bitmap = new Bitmap(drawBitData(target, ifSmooth), PixelSnapping.ALWAYS, true);
			
			return bmp;
		}
		
		/**
		 * 抓取显示对象的位图数据；
		 */		
		public static function drawBitData(target:DisplayObject, ifSmooth:Boolean = false):BitmapData
		{
			var myBitmapData:BitmapData = new BitmapData(target.width, target.height, true, 0xFFFFFF);
			myBitmapData.draw(target, null, null, null, null, ifSmooth);
			
			return myBitmapData;
		}
		
		/**
		 */		
		public static function drawWithSize(target:DisplayObject, width:Number, height:Number, mar:Matrix = null):BitmapData
		{
			var myBitmapData:BitmapData = new BitmapData(width, height, true, 0xFFFFFF);
			myBitmapData.draw(target, mar, null, null, null, true);
			
			return myBitmapData;
		}
	}
}