package com.fiCharts.charts.legend
{
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.charts.legend.view.LegendItemUI;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;

	/**
	 */	
	public class LegendPanel extends Sprite
	{
		public static const VERTICAL:String = "vertical";
		public static const HIRIZONTAL:String = "horizontal";

		/**
		 */
		public function LegendPanel()
		{
			super();
			
			XMLVOLib.registerCustomClasses(<icon path='com.fiCharts.charts.legend.LegendIconStyle'/>);
			addChild(container);
		}

		
		//--------------------------------------
		//
		// 样式配置
		//
		//--------------------------------------
		
		/**
		 */		
		public function setStyleConfig(value:XML):void
		{
			this.style = new LegendStyle;
			XMLVOMapper.fuck(value, this.style);
			XMLVOMapper.fuck(value, this);
		}
		
		/**
		 * 
		 */		
		public function setStyle(value:LegendStyle):void
		{
			style = value;
		}
		
		/**
		 */		
		public var style:LegendStyle = new LegendStyle;
		
		/**
		 * 每行或者每列的节点数
		 */
		private var _itemsPerLine:uint = 30;

		public function get itemsPerLine():uint
		{
			return _itemsPerLine;
		}

		public function set itemsPerLine(value:uint):void
		{
			_itemsPerLine = value;
		}

		/**
		 *  Layout direction of items, vertical or horizontal.
		 */
		private var _direction:String = HIRIZONTAL;

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}

		/**
		 * 图例的宽度，当图例总尺寸超过这个值时便开始换行；
		 */
		private var _size:Number = 200;

		/**
		 */
		public function get panelWidth():Number
		{
			return _size;
		}

		/**
		 * @private
		 */
		public function set panelWidth(value:Number):void
		{
			_size = value;
		}
		
		/**
		 */		
		private var _panelHeight:Number = 200;

		public function get panelHeight():Number
		{
			return _panelHeight;
		}

		public function set panelHeight(value:Number):void
		{
			_panelHeight = value;
		}

		
		/**
		 */
		private var _legendData:Vector.<LegendVO>;

		public function get legendData():Vector.<LegendVO>
		{
			return _legendData;
		}

		public function set legendData(value:Vector.<LegendVO>):void
		{
			_legendData = value;
			ifDataChanged = true;
		}
		
		/**
		 */		
		private var ifDataChanged:Boolean = false;

		/**
		 */		
		public function clear():void
		{
			legendData = null;
			legendUIs = null;
			
			while (container.numChildren)
				container.removeChildAt(0);
			
			this.graphics.clear()
		}
		
		/**
		 */
		public function render():void
		{
			container.x = this.style.hPadding;
			container.y = this.style.vPadding;
			
			var legendUI:LegendItemUI;
			
			// 创建
			if (ifDataChanged)
			{
				legendUIs = new Vector.<LegendItemUI>;
				for each (var legendVO:LegendVO in legendData)
				{
					legendUI = new LegendItemUI(legendVO);
					legendUI.render(style);
					legendUIs.push(legendUI);
				}
				
				ifDataChanged = false;
			}
			
			while (container.numChildren)
				container.removeChildAt(0);
			
			// 布局
			legendX = legendY = index = 0;
			for each (legendUI in this.legendUIs)
			{
				legendUI.x = legendX;
				legendUI.y = legendY;
				
				container.addChild(legendUI);
				
				if (direction == VERTICAL)
					verticalLayout(legendUI);
				else if (direction == HIRIZONTAL)
					horiticalLayout(legendUI);
			}
			
			renderBG();
		}
		
		/**
		 */		
		private var legendUIs:Vector.<LegendItemUI>;
		
		/**
		 * 转载图例的容器
		 */		
		private var container:Sprite = new Sprite;

		/**
		 */
		private function verticalLayout(legendUI:LegendItemUI):void
		{
			legendY += legendUI.height + style.vPadding;

			index += 1;
			if (legendY + legendUI.height > panelHeight)
			{
				legendX = container.width + style.vPadding;
				legendY = index = 0;
			}
		}

		/**
		 */
		private function horiticalLayout(legendUI:LegendItemUI):void
		{
			legendX += legendUI.width + style.hPadding;

			if (legendX + legendUI.width > panelWidth)
			{
				legendX = index = 0;
				legendY = container.height + style.hPadding;

				return;
			}

			index += 1;
			if (index >= itemsPerLine)
			{
				legendX = index = 0;
				legendY = container.height + style.hPadding;
			}
		}

		/**
		 * 绘制边框
		 */
		private function renderBG():void
		{
			style.width = uiWidth;
			style.height = uiHeight;
			this.graphics.clear();
			StyleManager.drawRect(this, style);
		}
		
		/**
		 */		
		public function get uiWidth():Number
		{
			return container.width + style.hPadding * 2;
		}
		
		/**
		 */		
		public function get uiHeight():Number
		{
			return container.height + style.vPadding * 2;
		}

		/**
		 */
		private var legendX:Number = 0;
		private var legendY:Number = 0;
		private var index:uint = 0;

	}
}