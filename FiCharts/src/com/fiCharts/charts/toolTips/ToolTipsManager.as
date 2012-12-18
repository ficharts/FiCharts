package com.fiCharts.charts.toolTips
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 提示窗口以中下部为坐标基点
	 */	
	public class ToolTipsManager
	{
		/**
		 * toolTips will show in this. 
		 */		
		private var container:Sprite;
		
		/**
		 */		
		public function ToolTipsManager(container:Sprite)
		{
			this.container = container;
			init();
			
			// 默认样式
			setStyleXML(defaultStyle);
		}
		
		/**
		 * 以XML方式设置样式;
		 */		
		public function setStyleXML(value:XML):void
		{
			toolTipUI.style = new LabelStyle;
			XMLVOMapper.fuck(value, toolTipUI.style);
			XMLVOMapper.fuck(value, this);
			toolTipUI.updateStyle();
		}
		
		/**
		 */		
		public function setStyle(value:LabelStyle):void
		{
			toolTipUI.style = value;
			toolTipUI.updateStyle();
		}
		
		/**
		 */		
		private var defaultStyle:XML = <toolTip radius='5' padding='5' vMargin='10' hMargin='10'>
											<border thikness='1' alpha='1' color='444444'/>
										  	<fill color='e6e7e5' alpha='1'/>
											<format font='Arial' size='12' bold='false' color='444444'/>
									   </toolTip>
		
		/**
		 */		
		private var toolTipUI:ToolTipsUI = new ToolTipsUI();
		
		/**
		 */		
		private function init():void
		{
			container.addChild(toolTipUI);
			container.addEventListener(ToolTipsEvent.SHOW_TOOL_TIPS, showToolTipsHandler, false, 0, true);
			container.addEventListener(ToolTipsEvent.HIDE_TOOL_TIPS, hideToolTipsHandler, false, 0, true);
			container.addEventListener(Event.ENTER_FRAME, moveHandler, false, 0, true);
		}
		
		/**
		 */		
		private function showToolTipsHandler(evt:ToolTipsEvent):void
		{
			evt.stopPropagation();
			
			toolTipUI.tooltipHolder = evt.toolTipsHolder;
			toolTipUI.updateLabel();
			
			if (evt.toolTipsHolder.locked && evt.toolTipsHolder.location)// 固定位置
			{
				var location:Point = this.container.globalToLocal(evt.toolTipsHolder.location);
				toolTipUI.x = location.x;
				
				if (evt.toolTipsHolder.isHorizontal)
				{
					toolTipUI.y = location.y;
						
					if (evt.toolTipsHolder.isPositive)
						toolTipUI.x = location.x + toolTipUI.width / 2 + toolTipUI.style.hMargin; 
					else
						toolTipUI.x = location.x - toolTipUI.width / 2 - toolTipUI.style.hMargin;
				}
				else
				{
					if (evt.toolTipsHolder.isPositive)
						toolTipUI.y = location.y - toolTipUI.height / 2 - toolTipUI.style.vMargin; 
					else
						toolTipUI.y = location.y + toolTipUI.height / 2 + toolTipUI.style.vMargin;
				}
				
				adjustTipUILocation();
				
			}
			else// 随鼠标位置而移动
			{
				ifMoving = true;
			}
			
			toolTipUI.show();
		}
		
		/**
		 */		
		private function hideToolTipsHandler(evt:ToolTipsEvent):void
		{
			ifMoving = false;
			evt.stopPropagation();
			toolTipUI.hide();
		}
		
		/**
		 */		
		private function moveHandler(evt:Event):void
		{
			if (ifMoving)
			{
				toolTipUI.x = container.mouseX;
				toolTipUI.y = container.mouseY - toolTipUI.height / 2 - toolTipUI.style.vPadding;
				
				adjustTipUILocation();
			}
		}
		
		/**
		 * 有时候提示UI会超出边界，需要调整一下； 
		 */		
		private function adjustTipUILocation():void
		{
			// 左
			if (toolTipUI.x - toolTipUI.width / 2 - container.x < edgeGutter)
				toolTipUI.x =  - container.x + toolTipUI.width / 2 + edgeGutter;
			
			// 右
			if (toolTipUI.x + toolTipUI.width / 2 + container.x + edgeGutter > container.stage.stageWidth)
				toolTipUI.x = container.stage.stageWidth - toolTipUI.width / 2 - container.x - edgeGutter;
			
			// 上
			if (toolTipUI.y - toolTipUI.height / 2 - container.y < edgeGutter)
				toolTipUI.y = toolTipUI.height / 2 - container.y + edgeGutter;
			
			// 下
			var time:uint = 0; // 防止死循环;
			while (toolTipUI.y + toolTipUI.height / 2 + container.y >= container.stage.stageHeight - edgeGutter && time < 50)
			{
				toolTipUI.y = container.stage.height - toolTipUI.height / 2 - container.y - 1 - edgeGutter;
				time ++;
			}
		}
		
		/**
		 */		
		private var _locked:Boolean = false;

		/**
		 */
		public function get locked():Boolean
		{
			return _locked;
		}

		/**
		 * @private
		 */
		public function set locked(value:Boolean):void
		{
			_locked = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		private var edgeGutter:uint = 5;
		
		/**
		 */		
		private var ifMoving:Boolean = false;
		
	}
}