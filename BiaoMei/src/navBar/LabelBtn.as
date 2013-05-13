package navBar
{
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
			labelUI.style = this.labelStyle;
			XMLVOMapper.fuck(this.labelStyleXML, labelStyle);
			this.addChild(labelUI);
			
			this.states = new States;
			XMLVOMapper.fuck(styleXML, states);
			statesControl = new StatesControl(this, states);
		}
		
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
			labelUI.text = text;
			labelUI.render();
			
			this.graphics.clear();
			currState.width = this.w;
			currState.height = this.h;
			StyleManager.drawRect(this, currState);
			
			LayoutManager.excuteVLayout(labelUI, this);
			LayoutManager.excuteHLayout(labelUI, this);
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
		public var styleXML:XML = <states>
										<normal>
											<fill color='#DDDDDD' alpha='0'/>
										</normal>
										<hover>
											<fill color='#DDDDDD' alpha='0.6'/>
										</hover>
										<down>
											<fill color='#DDDDDD' alpha='0.4'/>
										</down>
									</states>
			
			
		private var labelStyleXML:XML =  <label>
							                <format color='555555' font='微软雅黑' size='16'/>
											<text>
												<effects>
													<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='0.9'/>
												</effects>
											</text>
							            </label>

	}
}