package edit.chartTypeBox
{
	import com.fiCharts.utils.interactive.DragControl;
	import com.fiCharts.utils.interactive.IDragCanvas;
	import com.fiCharts.utils.layout.BoxLayout;
	
	import edit.dragDrop.DragDropEvent;
	import edit.dragDrop.IDragDrapSender;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * 负责序列类型的创建和改变，可以拖动的面板
	 * 
	 */	
	public class ChartTypePanel extends Sprite implements IDragTarget, IDragDrapSender 
	{
		/**
		 */		
		public static const COLUMN:String = 'column';
		
		/**
		 */		
		public static const LINE:String = 'line';
		
		/**
		 */		
		public static const AREA:String = 'area';
		
		/**
		 */		
		public static const PIE:String = 'pie';
		
		/**
		 */		
		public static const BAR:String = 'bar';
		
		/**
		 */		
		public static const MARKER:String = 'marker';
		
		/**
		 */		
		public static const BUBBLE:String = 'bubble';
		
		/**
		 */		
		public static const STACKED_COLUMN:String = 'stackedColumn';
		
		/**
		 */		
		public static const STACKED_BAR:String = 'stackedBar';
		
		/**
		 */		
		public static function getChartBitmapByType(type:String):String
		{
			var img:String = CHART_BM.item.(@type==type).@img;
			
			return img;
		}
		
		/**
		 */		
		public static const CHART_BM:XML = <charts>
											<item type='line' img="type_line"/>
											<item type='area' img="type_area"/>
											<item type='column' img="type_column"/>
											<item type='stackedColumn' img="type_stackedColumn"/>
											<item type='bar' img="type_bar"/>
											<item type='stackedBar' img="type_stackedBar"/>
											<item type='marker' img="type_marker"/>
											<item type='bubble' img="type_bubble"/>
											<item type='pie' img="type_pie"/>
										</charts>
		
		/**
		 */		
		public function ChartTypePanel()
		{
			super();
			
			
			type_line;
			type_column;
			type_pie;
			type_area;
			type_bar;
			type_marker;
			type_bubble;
			type_stackedColumn;
			type_stackedBar;
			
			this.addChild(bg);
			bg.addChild(bar);
			
			dragger = new Drager(bg, this);
		}
		
		/**
		 */		
		public function setDragRect(rect:Rectangle):void
		{
			dragger.setDragRect(rect);
		}
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 * 控制面板拖动
		 */		
		private var dragger:Drager;
		
		/**
		 *背景 
		 */		
		private var bg:Sprite = new Sprite;
		
		/**
		 */		
		public function render():void
		{
			bar.w = this.w;
			bar.render();
			
			boxLayout.setLoc(0, this.bar.h);
			boxLayout.setItemSizeAndFullWidth(w, 45, 45);
			boxLayout.ready();
			
			var chart:ChartTypeItem;
			for each (var item:XML in CHART_BM.children())
			{
				chart = new ChartTypeItem(item.@type, item.@img);
				chart.styleXML = <states>
										<normal>
											<border color='#4EA6EA' alpha='0.6'/>
											<fill color='#FFFFFF' alpha='0.8'/>
										</normal>
										<hover>
											<border color='#4EA6EA' thikness='1' alpha='1'/>
											<fill color='#4EA6EA' alpha='0.3'/>
										</hover>
										<down>
											<border color='#4EA6EA' thikness='2' alpha='1'/>
										</down>
									</states>
				boxLayout.layout(chart);
				chart.render();
				
				this.addChild(chart);
			}
			
			this.h = boxLayout.getRectHeight() + bar.h;
			
			bg.graphics.clear();
			bg.graphics.lineStyle(1, 0xDDDDDD);
			bg.graphics.beginFill(0xEEEEEE, 0.9);
			bg.graphics.drawRoundRect(0, 0, w, h, 0, 0);
			//this.filters =[new GlowFilter(0xCCCCCC, 1)]
		}
		
		/**
		 */		
		public function enable():void
		{
			this.mouseChildren = this.mouseEnabled = true;
		}
		
		/**
		 */		
		public function disEnable():void
		{
			this.mouseChildren = this.mouseEnabled = false;
		}
			
		/**
		 */		
		public var w:Number = 110;
		
		/**
		 */		
		public var h:Number = 300;
		
		/**
		 */		
		private var bar:DragBar = new DragBar;
		
		
	}
}