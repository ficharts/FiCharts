package com.fiCharts.utils.graphic
{
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 *
	 * @author peter
	 *   画虚线
	 */
	public class DrawDashes
	{

		public static function hideDashed(sprite:Sprite):void
		{
			sprite.graphics.clear();
		}

		/**
		 *
		 * @param sprite 显示虚线的容器
		 * @param beginPoint 起始点
		 * @param endPoint   终止点
		 * @param color   虚线的颜色
		 * @param width   虚线的宽度
		 * @param grap    虚线间的距离
		 *
		 */
		public static function showDashed(sprite:Sprite, beginPoint:Point, endPoint:Point, color:uint = 0, width:Number = 1, grap:Number = 2):void
		{
			if (!sprite || !beginPoint || !endPoint || width <= 0 || grap <= 0)
				return;
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;

			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number;
			var y:Number;
			sprite.graphics.clear();
			sprite.graphics.lineStyle(width, color);
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy + Math.sin(radian) * currLen;
				sprite.graphics.moveTo(x, y);

				currLen += width;
				if (currLen > totalLen)
					currLen = totalLen;

				x = Ox + Math.cos(radian) * currLen;
				y = Oy + Math.sin(radian) * currLen;
				sprite.graphics.lineTo(x, y);

				currLen += grap;
			}
		}

		public function DrawDashes()
		{
		}
	}
}