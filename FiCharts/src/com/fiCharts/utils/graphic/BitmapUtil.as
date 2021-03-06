package com.fiCharts.utils.graphic
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 截取显示对象
	 */	
	public class BitmapUtil
	{
		public function BitmapUtil()
		{
		}
		
		/**
		 */		
		public static function bitmapDataToByteArrar(bmd:Bitmap):ByteArray
		{
			return bmd.bitmapData.getPixels(bmd.bitmapData.rect);
		}
		
		/**
		 * 将位图绘制到显示对象的指定区域内, 拟定宽高和位置
		 */		
		public static function drawBitmapDataToSprite(bmd:BitmapData, ui:Sprite, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = true, radius:uint = 0):void
		{
			if (bmd)
			{
				var mat:Matrix = new Matrix;
				mat.createBox(w / bmd.width, h / bmd.height, 0, tx, ty);
				ui.graphics.beginBitmapFill(bmd, mat, false, smooth);
				ui.graphics.drawRoundRect(tx, ty, w, h, radius, radius);
			}
		}
		
		/**
		 * 将位图绘制到显示对象的指定区域内, 拟定宽高和位置
		 */		
		public static function drawBitmapDataToShape(bmd:BitmapData, ui:Shape, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = true, radius:uint = 0):void
		{
			if (bmd)
			{
				var mat:Matrix = new Matrix;
				mat.createBox(w / bmd.width, h / bmd.height, 0, tx, ty);
				ui.graphics.beginBitmapFill(bmd, mat, false, smooth);
				ui.graphics.drawRoundRect(tx, ty, w, h, radius, radius);
			}
		}
		
		/**
		 * 获取显示对象的截图，并转换为位图
		 */		
		public static function getBitmap(target:DisplayObject, ifSmooth:Boolean = false):Bitmap
		{
			var bmp:Bitmap = new Bitmap(getBitmapData(target, ifSmooth), PixelSnapping.ALWAYS, true);
			
			return bmp;
		}
		
		/**
		 * 抓取显示对象的位图数据；
		 */		
		public static function getBitmapData(target:DisplayObject, ifSmooth:Boolean = false):BitmapData
		{
			var rect:Rectangle = target.getBounds(target);
			var myBitmapData:BitmapData = new BitmapData(target.width, target.height, true, 0xFFFFFF);
			
			var mat:Matrix = new Matrix;
			mat.createBox(1, 1, 0, - rect.left, - rect.top);
			myBitmapData.draw(target, mat, null, null, null, ifSmooth);
			
			return myBitmapData;
		}
		
		/**
		 * 抓取显示对象上的指定范围内位图数据,
		 */		
		public static function drawWithSize(target:DisplayObject, width:Number, height:Number, mar:Matrix = null):BitmapData
		{
			var myBitmapData:BitmapData = new BitmapData(width, height, true, 0xFFFFFF);
			myBitmapData.draw(target, mar, null, null, null, true);
			
			return myBitmapData;
		}
	}
}