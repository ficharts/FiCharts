package temple
{
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class ChartImgUI extends Sprite implements IStyleStatesUI
	{
		/**
		 */		
		public function ChartImgUI(imgID:String, config:XML)
		{
			super();
			
			new StatesControl(this);
			
			this.imgID = imgID;
			this.config = config;
			
			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			var event:ChartCreatEvt = new ChartCreatEvt(ChartCreatEvt.CREATE_CHART);
			event.configXML = this.config;
			
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xEEEEEE);
			this.graphics.drawRect(0, 0, w, h);
		}
		
		/**
		 */		
		public var w:Number = 100;
		
		/**
		 */		
		public var h:Number = 100;
		
		/**
		 */		
		private var imgID:String;
		
		/**
		 */		
		public var config:XML
		
		/**
		 */		
		public function get states():States
		{
			return null;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			
		}
		
		/**
		 */		
		public function get currState():Style
		{
			return null;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			
		}
		
		/**
		 */		
		public function hoverHandler():void
		{
			
		}
		
		/**
		 */		
		public function normalHandler():void
		{
			
		}
		
		/**
		 */		
		public function downHandler():void
		{
			
		}
		
		/**
		 */		
		override public function get visible():Boolean
		{
			return true
		}
		
		/**
		 */		
		override public function set visible(value:Boolean):void
		{
		}
	}
}