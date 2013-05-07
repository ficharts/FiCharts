package preview.stylePanel
{
	import com.fiCharts.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 负责改变图表类型
	 */	
	public class ChartStylePanel extends Sprite
	{
		public function ChartStylePanel()
		{
			super();
			
			this.addEventListener(StyleChangedEvt.STYLE_SELECTED, styleChangedHandler, false, 0, true);
		}
		
		/**
		 */		
		private function styleChangedHandler(evt:StyleChangedEvt):void
		{
			if (curStyleItem)
			{
				curStyleItem.disSelect();
				
				curStyleItem = evt.styleItem;
				curStyleItem.selected();
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 */		
		public var curStyleItem:StyleItemUI;
		
		/**
		 */		
		public function render():void
		{
			boxLayout.setLoc(0, 0);
			boxLayout.setHoriHeightAndGap(this.h);
			boxLayout.ready();
			
			var styleItem:StyleItemUI;
			var i:uint = 0;
			for each (var item:XML in styleConfig.children())
			{
				styleItem = new StyleItemUI(item.@type, item.@img);
				boxLayout.horiLayout(styleItem);
				styleItem.render();
				this.addChild(styleItem);
				
				if (i == 0)
				{
					curStyleItem = styleItem;
					curStyleItem.selected();
				}
				
				i ++;
			}
			
			graphics.clear();
			graphics.beginFill(0x555555, 0.5);
			w = boxLayout.horiWidth;
			graphics.drawRoundRect(0, 0, w, h, 5, 5);
		}
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 */		
		public function getStyleType():String
		{
			return curStyleItem.type;
		}
		
		/**
		 */		
		public var w:Number = 0;
		
		/**
		 */		
		public var h:Number = 0;
		
		/**
		 */		
		private var styleConfig:XML = <charts>
										<item type='Simple' img="type_line"/>
										<item type='Classic' img="type_line"/>
										<item type='Black' img="type_line"/>
									</charts>
	}
}