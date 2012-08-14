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
		public static const top:String = "top";
		public static const buttom:String = "buttom";
		public static const left:String = "left";
		public static const right:String = "right";
		public static const center:String = "center";
		
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
		 */
		public static function excuteLayout(target:DisplayObject, 
											parent:DisplayObjectContainer, layout:String=center):void
		{
			var targetX:Number = 0;
			var targetY:Number = 0;
			
			if (layout == center)
			{
				targetX = (parent.width - target.width) / 2;
				targetY = (parent.height - target.height) / 2;
			}
			
			target.x = targetX;
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