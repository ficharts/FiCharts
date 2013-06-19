package com.fiCharts.ui
{
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.RexUtil;
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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * 类似于一个图标按钮, 能相应交互，图标来自于图片加载或类定义创建;
	 * 
	 * 与IconBtn不同的是这里仅有一个图标，仅绘制一次，不随原件状态切换而重绘
	 */	
	public class IconShape extends FiUI implements IBoxItem, IStyleStatesUI
	{
		/**
		 */		
		public function IconShape()
		{
			super();
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = false;
			addChild(canvas);
			addChild(iconCanvas);
			addChild(frameCanvas);
			
			ready();
		}
		
		/**
		 * @private
		 */
		public function set icon(value:String):void
		{
			_icon = value;
		}

		/**
		 */		
		private var _icon:String;
		
		/**
		 */
		public function get icon():String
		{
			return _icon;
		}
		
		/**
		 */		
		private var _iconURL:String = '';

		/**
		 *  图标资源的加载路径
		 */
		public function get iconURL():String
		{
			return _iconURL;
		}

		/**
		 */
		public function set iconURL(value:String):void
		{
			_iconURL = value;
		}
		
		/**
		 * 初始化样式及状态控制, 正式渲染之前必须保证初始化完成
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
		public function render():void
		{
			if (ifReady == false)
				this.ready();
			
			// 图表仅绘制一次， 状态切换实则是切换背景和边框样式
			if (ifIConDrawed == false)
			{
				// 如果定义了图标URL，则采用加载图片方式，否则按照类绑定
				// 方式绘制图标
				if (RexUtil.ifHasText(iconURL))
				{
					imgLoader = new Loader
					imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
					imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoadFail, false, 0, true);
					imgLoader.load(new URLRequest(this.icon));
				}
				else
				{
					var imgData:BitmapData = ClassUtil.getObjectByClassPath(this.icon) as BitmapData;
					drawImg(imgData);
				}
				
				ifIConDrawed = true;
			}
			
			canvas.graphics.clear();
			currState.width = this.w;
			currState.height = this.h;
			StyleManager.setFillStyle(canvas.graphics, currState);
			canvas.graphics.drawRoundRect(0, 0, w, h, currState.radius, currState.radius);
			canvas.graphics.endFill();
			
			frameCanvas.graphics.clear();
			StyleManager.setLineStyle(frameCanvas.graphics, currState.getBorder, currState);
			frameCanvas.graphics.drawRoundRect(0, 0, w, h, currState.radius, currState.radius);
			frameCanvas.graphics.endFill();
		}
		
		/**
		 * 是否图标已经被绘制，图标仅需绘制一次
		 */		
		private var ifIConDrawed:Boolean = false;
		
		/**
		 */		
		private function imgLoaded(evt:Event):void
		{
			drawImg((imgLoader.content as Bitmap).bitmapData);
			imgLoader.unload();
			imgLoader = null;
		}
		
		/**
		 */		
		private function drawImg(bmd:BitmapData):void
		{
			BitmapUtil.drawBitmapDataToShape(bmd, iconCanvas, w - gap * 2, h - gap * 2, gap, gap, ifSmoothImg, currState.radius)
		}
		
		/**
		 */		
		public var ifSmoothImg:Boolean = false;
		
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
		 * 边框画布
		 */		
		private var frameCanvas:Shape = new Shape;
		
		/**
		 * 用来绘制图标的画布
		 */		
		private var iconCanvas:Shape = new Shape;
		
		/**
		 * 背景画布
		 */		
		private var canvas:Shape = new Shape;
		
		
		
		
		
		
		
		//---------------------------------------------
		//
		//
		// 状态控制
		//
		//
		//---------------------------------------------
		
		/**
		 */		
		protected var stateControl:StatesControl;
		
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
	}
}