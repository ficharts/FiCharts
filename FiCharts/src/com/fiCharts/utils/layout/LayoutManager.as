package com.fiCharts.utils.layout
{
	import com.fiCharts.utils.XMLConfigKit.style.IStyleUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 */
	public class LayoutManager
	{
		/**
		 */		
		public static const TOP:String = "top";
		public static const BOTTOM:String = "buttom";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		
		/**
		 */		
		public function LayoutManager()
		{
		}
		
		/**
		 */		
		public static function hLayoutStyleUI(styleUI:IStyleUI, width:Number):void
		{
			if ((styleUI.style as LabelStyle).hAlign == 'left')
				(styleUI as Sprite).x = (styleUI.style as LabelStyle).hMargin;
			else if ((styleUI.style as LabelStyle).hAlign == 'right')
				(styleUI as Sprite).x = width - (styleUI as Sprite).width - (styleUI.style as LabelStyle).hMargin;
			else
				(styleUI as Sprite).x = (width - (styleUI as Sprite).width) / 2;
		}
		
		/**
		 * 水平方向布局
		 */
		public static function excuteHLayout(target:DisplayObject, 
											parent:DisplayObjectContainer, layout:String=CENTER, padding:uint = 10):void
		{
			var targetX:Number = 0;
			
			if (layout == CENTER)
			{
				targetX = (parent.width - target.width) / 2;
			}
			else if (layout == LEFT)
			{
				targetX = padding;
			}
			else if (layout == RIGHT)
			{
				targetX = parent.width - target.width - padding;
			}
			
			target.x = targetX;
		}
		
		/**
		 * 方向布局
		 */
		public static function excuteVLayout(target:DisplayObject, 
											 parent:DisplayObjectContainer, layout:String=CENTER, padding:uint = 10):void
		{
			var targetY:Number = 0;
			
			if (layout == CENTER)
			{
				targetY = (parent.height - target.height) / 2;
			}
			else if (layout == TOP)
			{
				targetY = padding;
			}
			else if (layout == BOTTOM)
			{
				targetY = parent.height - target.height - padding;
			}
			
			target.y = targetY;
		}
		
		/**
		 * 调整对象至舞台正中心
		 */		
		public static function stageCenter(target:DisplayObject, stage:Stage):void
		{
			target.x = (stage.stageWidth - target.width) / 2;
			target.y = (stage.stageHeight - target.height) / 2;
		}
	}
}