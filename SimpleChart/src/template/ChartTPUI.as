package template
{
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class ChartTPUI extends Sprite implements IStyleStatesUI
	{
		/**
		 */		
		public function ChartTPUI(imgID:String, config:XML)
		{
			super();
			
			this.mouseChildren = false;
			new StatesControl(this);
			
			this.imgID = imgID;
			this.config = config;
			
			disSelect();
		}
		
		/**
		 */		
		public function disSelect():void
		{
			this.mouseEnabled = true;
			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			this.graphics.clear();
			this.graphics.beginFill(0x555555);
			this.graphics.drawRect(0, 0, w, h);
		}
		
		/**
		 */		
		public function selected():void
		{
			this.mouseEnabled = false;
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			this.graphics.clear();
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(0, 0, w, h);
		}
		
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			var event:ChartCreatEvt = new ChartCreatEvt(ChartCreatEvt.SELECT_CHART);
			event.chartTPUI = this;
			
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		public function render():void
		{
			if (mouseEnabled == false)
			{
				this.graphics.clear();
				this.graphics.beginFill(0x555555);
				this.graphics.drawRect(0, 0, w, h);
			}
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
		public var config:XML;
		
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