package com.fiCharts.ui.button
{
	import com.fiCharts.ui.FiUI;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Img;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	
	/**
	 * 仅有图标构成的按钮, 图标可随按钮状态切换时也切换
	 */	
	public class IconBtn extends FiUI implements IStyleStatesUI
	{
		public function IconBtn()
		{
			super();
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.states = new States;
			XMLVOMapper.fuck(styleXML, states);
			statesControl = new StatesControl(this, states);
			
			this.render();
		}
		
		/**
		 * 设置图片
		 */		
		protected function setIcons(normalImg:String, hoverImg:String, downImg:String, w:Number, h:Number):void
		{
			states.width = w;
			states.height = h;
			
			states.getNormal.getImg.classPath = normalImg;
			states.getHover.getImg.classPath = hoverImg;
			states.getDown.getImg.classPath = downImg;
		}
		
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
		 * 先绘制背景， 在绘制图片，最后绘制边框
		 */		
		public function render():void
		{
			this.graphics.clear()
				
			StyleManager.setFillStyle(this.graphics, currState);
			this.graphics.drawRect(0, 0, this.currState.width, currState.height);	
			this.graphics.endFill();
			
			var img:Img = currState.getImg;
			img.ready();
			var tx:Number = (currState.width - img.width ) / 2;
			var ty:Number = (currState.height - img.height ) / 2;
			BitmapUtil.drawBitmapDataToSprite(img.data, this, img.width, img.height, tx, ty, false);
			this.graphics.endFill();
			
			StyleManager.setLineStyle(this.graphics, currState.getBorder, currState);
			this.graphics.drawRect(0, 0, this.currState.width, currState.height);	
			this.graphics.endFill();
			
			StyleManager.setEffects(this, currState);
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