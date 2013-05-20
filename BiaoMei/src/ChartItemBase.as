package 
{
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.layout.IBoxItem;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 
	 */	
	public class ChartItemBase extends Sprite implements IBoxItem, IStyleStatesUI
	{
		
		/**
		 */		
		public var styleXML:XML = <states>
										<normal>
											<border color='#BCBCBC' alpha='0.6'/>
										</normal>
										<hover>
											<border color='#4EA6EA' thikness='1' alpha='1'/>
											<fill color='#4EA6EA' alpha='0.'/>
										</hover>
										<down>
											<border color='#4EA6EA' thikness='2' alpha='1'/>
										</down>
									</states>
			
			
		/**
		 */		
		public function ChartItemBase(type:String, img:String)
		{
			super();
			
			this.mouseChildren = false;
			this.addChild(canvas);
			this.addChild(imgCanvas);
				
			this.type = type;
			this.img = img;
		}
		
		/**
		 */		
		public function ready():void
		{
			this.states = new States;
			XMLVOMapper.fuck(this.styleXML, states);
			
			stateControl = new StatesControl(this, states);
			ifReady = true;
		}
		
		/**
		 */		
		private var ifReady:Boolean = false;
		
		/**
		 */		
		protected var stateControl:StatesControl;
		
		/**
		 */		
		public var type:String;
		
		/**
		 */		
		private var _itemW:Number = 0;
		
		/**
		 */		
		private var _itemH:Number = 0;
		
		/**
		 */		
		private var img:String;
		
		/**
		 */		
		public function get itemH():Number
		{
			return _itemH;
		}

		public function set itemH(value:Number):void
		{
			_itemH = value;
		}

		public function get itemW():Number
		{
			return _itemW;
		}

		public function set itemW(value:Number):void
		{
			_itemW = value;
		}

		/**
		 */		
		public function render():void
		{
			if (ifDrawed == false)
			{
				var imgData:BitmapData = ClassUtil.getObjectByClassPath(this.img) as BitmapData;
				BitmapUtil.drawBitmapDataToUI(imgData, imgCanvas, itemW - gap * 2, itemH - gap * 2, gap, gap, false);
				
				ifDrawed = true;
			}
			
			if (ifReady == false)
				this.ready();
			
			canvas.graphics.clear();
			currState.width = this.itemW;
			currState.height = this.itemH;
			StyleManager.drawRectOnShape(canvas, currState);
		}
		
		/**
		 */		
		public var gap:uint = 0;
		
		/**
		 */		
		private var imgCanvas:Sprite = new Sprite;
		
		/**
		 */		
		private var canvas:Shape = new Shape;
		
		/**
		 */		
		private var ifDrawed:Boolean = false;
		
		
		
		//---------------------------------------------
		//
		//
		// 状态控制
		//
		//
		//---------------------------------------------
		
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function get currState():Style
		{
			return style;
		}
		
		/**
		 */		
		private var style:Style;
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			style = value;
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
		
	
	}
}