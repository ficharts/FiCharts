package com.fiCharts.utils.graphic
{
	/**
	 *  正多边形绘制工具
	 **/
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 */	
	public class DrawPolygon
	{
		private static var drawPolygon:DrawPolygon;
		
		/**
		 */		
		public static function getInstance():DrawPolygon
		{
			if (drawPolygon == null)
				drawPolygon = new DrawPolygon();
			
			return drawPolygon;
		}
		
		/**
		 * 绘制多边形方法
		 */
		public function createLVP(canvas:Sprite, edgeAmount:uint, location:Point, color:uint, thikness:Number, 
		lineAlpha:Number, fillApha:Number):void
		{
			canvas.graphics.clear();
			canvas.graphics.lineStyle(thikness, color, lineAlpha);
			canvas.graphics.beginFill(color, fillApha);
			canvas.graphics.moveTo(location.x + Math.cos(Math.PI * 2) * 5, location.y + Math.sin(Math.PI * 2) * 5);
			
			var tem:uint = edgeAmount;
			
			while (edgeAmount --)
				canvas.graphics.lineTo(location.x + Math.cos(edgeAmount / tem * Math.PI * 2) * 5,location.y + Math.sin(edgeAmount / tem * Math.PI * 2) * 5);
			
			canvas.graphics.endFill();
		}
	}
}