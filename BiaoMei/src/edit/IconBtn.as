package edit
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Img;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class IconBtn extends Sprite implements IStyleStatesUI
	{
		public function IconBtn()
		{
			super();
			this.mouseChildren = false;
			
			this.states = new States;
			XMLVOMapper.fuck(styleXML, states);
			statesControl = new StatesControl(this, states);
		}
		
		/**
		 */		
		public function init(normalImg:String, hoverImg:String, downImg:String, w:Number, h:Number):void
		{
			this.normalImg = normalImg;
			this.hoverImg = hoverImg;
			this.downImg = downImg;
			
			states.width = w;
			states.height = h;
			
			states.getNormal.getImg.classPath = normalImg;
			states.getHover.getImg.classPath = hoverImg;
			states.getDown.getImg.classPath = downImg;
		}
		
		/**
		 */		
		private var normalImg:String;
		
		/**
		 */		
		private var hoverImg:String;
		
		/**
		 */		
		private var downImg:String;
		
		/**
		 */		
		private var statesControl:StatesControl;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear()
				
			StyleManager.setFillStyle(this.graphics, currState);
			this.graphics.drawRect(0, 0, this.currState.width, currState.height);	
			this.graphics.endFill();
			
			var img:Img = currState.getImg;
			var tx:Number = (currState.width - img.width ) / 2;
			var ty:Number = (currState.height - img.height ) / 2;
			BitmapUtil.drawBitmapDataToSprite(img.data, this, img.width, img.height, tx, ty, false);
			this.graphics.endFill();
			
			StyleManager.setLineStyle(this.graphics, currState.getBorder, currState);
			this.graphics.drawRect(0, 0, this.currState.width, currState.height);	
			this.graphics.endFill();
		}
		
		/**
		 */		
		public function get currState():Style
		{
			return style;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			style = value;
		}
		
		/**
		 */		
		private var style:Style;
		
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
										<normal>
											<fill color='#FFFFFF' alpha='0'/>
											<img/>
										</normal>
										<hover>
											<fill color='#FFFFFF' alpha='0'/>
											<img/>
										</hover>
										<down>
											<fill color='#2494E6' alpha='0'/>
											<img/>
										</down>
									</states>
	}
}