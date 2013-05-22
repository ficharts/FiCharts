package template
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.layout.IBoxItem;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class ChartTempleItem extends ChartItemBase implements IStyleStatesUI, IBoxItem
	{
		/**
		 */		
		public function ChartTempleItem(type:String, imgURL:String, config:XML)
		{
			this.ifLoadImg = true;
			ifSmoothImg = true;
			this.gap = 0;
			
			super(type, imgURL);
			
			this.config = config;
			
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, doubbleHandler, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		
		/**
		 */		
		private function doubbleHandler(evt:MouseEvent):void
		{
			var event:ChartCreatEvent = new ChartCreatEvent(ChartCreatEvent.SELECT_CHART_AND_EDIT);
			event.chart = this;
			
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		public function disSelect():void
		{
			this.mouseEnabled = true;
			
			this.stateControl.enable = true;
			this.currState = states.getNormal;
			this.render();
		}
		
		/**
		 */		
		public function selected():void
		{
			this.mouseEnabled = false;
			this.stateControl.enable = false;
		}
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			var event:ChartCreatEvent = new ChartCreatEvent(ChartCreatEvent.SELECT_CHART);
			event.chart = this;
			
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		public var config:XML;
		
	}
}