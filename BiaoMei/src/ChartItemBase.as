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
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 
	 */	
	public class ChartItemBase extends Sprite implements IBoxItem, IStyleStatesUI, ITipsSender
	{
		
		/**
		 */		
		public var styleXML:XML = <states>
										<normal radius='6'>
											<border pixelHinting='true' color='#BCBCBC' alpha='0.6'/>
										</normal>
										<hover radius='6' >
											<border pixelHinting='true' color='#4EA6EA' thikness='1' alpha='1'/>
											<fill color='#4EA6EA' alpha='0.'/>
										</hover>
										<down radius='6' >
											<border pixelHinting='true' color='#4EA6EA' thikness='2' alpha='1'/>
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
			addChild(frame);
				
			this.type = type;
			this.img = img;
			
			tipsHolder = new TipsHolder(this);
		}
		
		/**
		 */		
		private var _tips:String;
		
		/**
		 */		
		private var tipsHolder:TipsHolder;
		
		/**
		 */		
		private var frame:Shape = new Shape;
		
		/**
		 * 是否启用加载图片方式，默认是类绑定方式，提供图片类名 
		 */		
		public var ifLoadImg:Boolean = false;
		
		public function get tips():String
		{
			return _tips;
		}

		public function set tips(value:String):void
		{
			_tips = value;
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
			if (ifReady == false)
				this.ready();
			
			if (ifDrawed == false)
			{
				if (ifLoadImg)
				{
					imgLoader = new Loader
					imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
					imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoadFail, false, 0, true);
					imgLoader.load(new URLRequest(this.img));
					
					ifDrawed = true;
				}
				else
				{
					var imgData:BitmapData = ClassUtil.getObjectByClassPath(this.img) as BitmapData;
					drawImg(imgData);
					
					ifDrawed = true;
				}
			}
			
			canvas.graphics.clear();
			currState.width = this.itemW;
			currState.height = this.itemH;
			StyleManager.setFillStyle(canvas.graphics, currState);
			canvas.graphics.drawRoundRect(0, 0, itemW, itemH, currState.radius, currState.radius);
			canvas.graphics.endFill();
			
			frame.graphics.clear();
			StyleManager.setLineStyle(frame.graphics, currState.getBorder, currState);
			frame.graphics.drawRoundRect(0, 0, itemW, itemH, currState.radius, currState.radius);
			frame.graphics.endFill();
		}
		
		/**
		 */		
		public var ifSmoothImg:Boolean = false;
		
		/**
		 */		
		private function imgLoaded(evt:Event):void
		{
			drawImg((imgLoader.content as Bitmap).bitmapData);
		}
		
		/**
		 */		
		private function drawImg(bmd:BitmapData):void
		{
			BitmapUtil.drawBitmapDataToSprite(bmd, imgCanvas, itemW - gap * 2, itemH - gap * 2, gap, gap, ifSmoothImg, currState.radius)
		}
		
		/**
		 */		
		private function imgLoadFail(evt:IOErrorEvent):void
		{
			
		}
		
		/**
		 */		
		private var imgLoader:Loader;
		
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