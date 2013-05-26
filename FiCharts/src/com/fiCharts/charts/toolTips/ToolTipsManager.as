package com.fiCharts.charts.toolTips
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 提示窗口以中下部为坐标基�
	 */	
	public class ToolTipsManager
	{
		/**
		 * toolTips will show in this. 
		 */		
		private var container:Sprite;
		
		/**
		 */		
		public static var tipsShowTime:Number = 0.8;
		
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
			//toolTipUI.visible = false;
			
			toolTipUI.alpha = 0;
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
			
			if (isHiding)
			{
				TweenLite.killTweensOf(toolTipUI, true);
				isHiding = false;
				toolTipUI.alpha = 1;
			}
			else
			{
				if (toolTipUI.alpha == 0)
				{
					isShowing = true;
					TweenLite.to(toolTipUI, 0.3, {alpha: 1, delay: tipsShowTime, onComplete:finishShow});
				}
			}
				
			//toolTipUI.visible = false;
			locked = evt.toolTipsHolder.locked;
			
			toolTipUI.tooltipHolder = evt.toolTipsHolder;
			toolTipUI.updateLabel();
			
			isHorizontal = evt.toolTipsHolder.isHorizontal;
			
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
			else// 随鼠标位置而移�
			{
				ifMoving = true;
				_moveTips();
			}
			
			toolTipUI.show();
		}
		
		/**
		 */		
		private function hideToolTipsHandler(evt:ToolTipsEvent):void
		{
			ifMoving = false;
			evt.stopPropagation();
			//toolTipUI.hide();
			
			if (isShowing)
			{
				TweenLite.killTweensOf(toolTipUI, true);
				isShowing = false;
				toolTipUI.alpha = 0;
			}
			else
			{
				isHiding = true;
				TweenLite.to(toolTipUI, 0.3, {alpha: 0, onComplete:finishHide});
			}
		}
		
		/**
		 */		
		private var isHiding:Boolean = false;
		
		/**
		 */		
		private var isHorizontal:Boolean = false;
		
		/**
		 */		
		private function finishHide():void
		{
			isHiding = false;
		}
		
		/**
		 */		
		private function finishShow():void
		{
			isShowing = false;
		}
		
		/**
		 */		
		private var isShowing:Boolean = false;
		
		/**
		 * 非锁定状态下，tip只按先右后左方式布局
		 */		
		private function moveHandler(evt:Event):void
		{
			_moveTips();
		}
		
		/**
		 */		
		private function _moveTips():void
		{
			if (ifMoving)
			{
				toolTipUI.x = container.mouseX + toolTipUI.width / 2 + toolTipUI.style.hMargin;
				toolTipUI.y = container.mouseY + 30//toolTipUI.height;
				
				adjustTipUILocation();
			}
		}
		
		/**
		 * 有时候提示UI会超出边界，需要调整一下； 
		 */		
		private function adjustTipUILocation():void
		{
			// �
			if (toolTipUI.x - toolTipUI.width / 2 - container.x < edgeGutter)
				toolTipUI.x =  - container.x + toolTipUI.width / 2 + edgeGutter;
			
			// �
			if (toolTipUI.x + toolTipUI.width / 2 + container.x + edgeGutter > container.stage.stageWidth)
			{
				if (locked)
					toolTipUI.x = container.stage.stageWidth - toolTipUI.width / 2 - container.x - edgeGutter;
				else
					toolTipUI.x = container.stage.mouseX - toolTipUI.width / 2 - toolTipUI.style.hMargin;
			}
			
			// �
			if (toolTipUI.y - toolTipUI.height / 2 - container.y < edgeGutter)
				toolTipUI.y = toolTipUI.height / 2 - container.y + edgeGutter;
			
			// �
			var time:uint = 0; // 防止死循�
			while (toolTipUI.y + toolTipUI.height / 2 + container.y >= container.stage.stageHeight - edgeGutter && time < 50)
			{
				toolTipUI.y = container.stage.height - toolTipUI.height / 2 - container.y - 1 - edgeGutter;
				time ++;
			}
			
			//toolTipUI.visible = true;
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