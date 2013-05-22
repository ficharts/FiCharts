package navBar
{
	import com.fiCharts.utils.StageUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.layout.LayoutManager;
	
	import flash.display.Sprite;
	
	/**
	 * 基本的按钮组件
	 */	
	public class LabelBtn extends Sprite implements IStyleStatesUI
	{
		public function LabelBtn()
		{
			super();
			this.mouseChildren = false;
		}
		
		/**
		 */		
		public function updateLabelStyle(style:XML):void
		{
			XMLVOMapper.fuck(style, labelStyle);
			this.render();
		}
		
		/**
		 */		
		public function ready():void
		{
			labelUI.style = this.labelStyle;
			XMLVOMapper.fuck(this.labelStyleXML, labelStyle);
			this.addChild(labelUI);
			
			this.states = new States;
			XMLVOMapper.fuck(bgStyleXML, states);
			statesControl = new StatesControl(this, states);
			
			ifReady = true;
		}
		
		/**
		 */		
		private var ifReady:Boolean = false;
		
		/**
		 */		
		public function selected():void
		{
			this.mouseEnabled = false;
			
			this.currState = states.getDown;
			this.render();
			
			statesControl.enable = false;
		}
		
		/**
		 */		
		public function disSelect():void
		{
			this.mouseEnabled = true;
			statesControl.enable = true;
			
			this.currState = states.getNormal;
			this.render();
		}
		
		/**
		 */		
		private var statesControl:StatesControl;

		/**
		 */		
		public var w:Number = 50;
		
		/**
		 */		
		public var h:Number = 30;
		
		/**
		 */		
		private var labelUI:LabelUI = new LabelUI;
		
		/**
		 */		
		private var labelStyle:LabelStyle = new LabelStyle;
		
		/**
		 */		
		private var _text:String

		/**
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
		}
		
		/**
		 */		
		public function render():void
		{
			if (ifReady)
			{
				labelUI.text = text;
				labelUI.render();
				
				this.graphics.clear();
				currState.width = this.w;
				currState.height = this.h;
				StyleManager.drawRect(this, currState);
				
				LayoutManager.excuteVLayout(labelUI, this, this.labelStyle.vAlign, labelStyle.padding);
				LayoutManager.excuteHLayout(labelUI, this);
			}
			else
			{
				this.ready();
				ifReady = true;
				render();
			}
			
		}
		
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
			return _style;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
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
		public var bgStyleXML:XML = <states>
										<normal>
											<fill color='#DDDDDD' alpha='0'/>
										</normal>
										<hover>
											<fill color='#EEEEEE, #EFEFEF' alpha='0.8, 0.8' angle="90"/>
										</hover>
										<down>
											<fill color='#DDDDDD' alpha='0.3' angle="90"/>
										</down>
									</states>
			
			
		public var labelStyleXML:XML =  <label vAlign="center">
							                <format color='555555' font='微软雅黑' size='12' letterSpacing="3"/>
							            </label>

	}
}