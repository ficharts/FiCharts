package preview
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import navBar.LabelBtn;
	
	/**
	 */	
	public class MessagePanel extends Sprite
	{
		public function MessagePanel()
		{
			super();
			
			this.addChild(labelUI);
			
			XMLVOMapper.fuck(styleXML, labelStyleVO);
			labelUI.style = this.labelStyleVO;
			
			sucessBMD = new success;
			alertBMD = new alert;
			
			this.visible = false;
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		/**
		 */		
		public var rect:Rectangle;
		
		/**
		 */		
		public function info(mes:String, icon:String = "succ"):void
		{
			labelUI.text = mes;
			labelUI.render();
			
			var bmd:BitmapData;
			
			if (icon == "succ")
				bmd = sucessBMD;
			else if (icon == "alert")
				bmd = alertBMD;
				
			BitmapUtil.drawBitmapDataToUI(bmd, labelUI, 30, 30, 14, (this.height - 30) / 2);
			
			this.x = (rect.width - this.width) / 2;
			this.y = (rect.height - this.height) / 2;
			
			this.visible = true;
			TweenLite.to(this, 0.5, {alpha: 0, delay: 1.5, onComplete: dispare});
		}
		
		/**
		 */		
		private function dispare():void
		{
			this.visible = false;
			this.alpha = 1;
		}
		
		/**
		 */		
		private var labelUI:LabelUI = new LabelUI;
		
		/**
		 */		
		private var labelStyleVO:LabelStyle = new LabelStyle;
		
		/**
		 */		
		private var styleXML:XML = <label radius='10' paddingLeft='58'paddingRight="30" vPadding="30">
										<format font="微软雅黑" color='FFFFFF'/>
										<fill color='333333' alpha='0.9' angle='90'/>
									</label>
		
		/**
		 */			
		private var sucessBMD:BitmapData;
		
		/**
		 */		
		private var alertBMD:BitmapData;
			
		/**
		 */		
		public var w:Number;
		
		/**
		 */		
		public var h:Number;
		
	}
}