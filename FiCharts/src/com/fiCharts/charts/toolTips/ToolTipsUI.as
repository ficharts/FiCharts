package com.fiCharts.charts.toolTips
{
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.Text;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	/**
	 */	
	public class ToolTipsUI extends Sprite
	{
		public function ToolTipsUI()
		{
			super();
			init();
		}
		
		/**
		 * 信息提示的样式取决于节点，而非统一设置；
		 */		
		private var _style:LabelStyle = new LabelStyle;

		public function get style():LabelStyle
		{
			return _style;
		}

		public function set style(value:LabelStyle):void
		{
			_style = value;
		}

		/**
		 */		
		private var _toolTipsVO:ToolTipHolder;

		public function get tooltipHolder():ToolTipHolder
		{
			return _toolTipsVO;
		}

		public function set tooltipHolder(value:ToolTipHolder):void
		{
			_toolTipsVO = value;
		}
		
		/**
		 */		
		private function init():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			label.multiline = true;;
			label.autoSize = "left";
			
			addChild(bg);
			labelsContainer = new Sprite;
			addChild(labelsContainer);
		}
		
		/**
		 */		
		private function get thisHeight():int
		{
			return labelsContainer.height + style.vPadding * 2
		}
		
		/**
		 */		
		private function get thisWidth():int
		{
			return labelsContainer.width + style.hPadding * 2
		}
		
		/**
		 */		
		private function get leftX():int
		{
			return - labelsContainer.width / 2 - style.hPadding;
		}
		
		private function get topY():int
		{
			return - labelsContainer.height / 2 - style.vPadding;
		}
		
		/**
		 */		
		public function show():void
		{
			this.visible = true;
		}
		
		/**
		 */		
		public function hide():void
		{
			this.visible = false;
		}
		
		/**
		 */		
		private var label:TextField = new TextField;
		
		/**
		 * 有两种信息提示模式，一是含有多个一是只有一项内容；
		 */		
		public function updateLabel():void
		{
			while (labelsContainer.numChildren)
				labelsContainer.removeChildAt(0);
			
			if (tooltipHolder.tipLength)
			{
				updateMultiDataLabel();
				updateBgSize();
				
				StyleManager.drawRect(this.bg, style, tooltipHolder.tooltips[0].metaData);
				StyleManager.setEffects(bg, style);
				
				labelsContainer.x = - labelsContainer.width / 2;
				labelsContainer.y = labelsContainer.height / 2;
			}
			else// 饼图的tips直接以holder为载体
			{
				this.style = tooltipHolder.style;
				updateBgSize();
				
				var labelUI:LabelUI = new LabelUI();
				labelUI.style = this.style;
				labelUI.metaData = tooltipHolder.metaData;
				labelUI.render();
				labelsContainer.addChild(labelUI);
				
				labelsContainer.x = - labelsContainer.width / 2;
				labelsContainer.y = - labelsContainer.height / 2;
			}
		}
		
		/**
		 */		
		private function updateMultiDataLabel():void
		{
			// 动态调整颜色
			var fontColor:uint;
			var bm:Bitmap;
			var labelY:Number = 0;
			
			for each (var tooltipItem:TooltipDataItem  in tooltipHolder.tooltips)
			{
				// 可以独立设置tooltip的样式
				if (tooltipItem.style)
				{
					if (tooltipHolder.tipLength > 1)
						this.style = tooltipItem.style.group;
					else
						this.style = tooltipItem.style.self as LabelStyle;
					
					this.updateStyle();					
				}
				
				fontColor = uint(StyleManager.getColor(tooltipItem.metaData, style.format.color));
				pStyle.color = '#' + fontColor.toString(16);
				styleSheet.setStyle("p", pStyle);
				label.styleSheet = styleSheet;
				label.htmlText = '<p>' +  RexUtil.replaceFieldBraceValue(this.style.text.value, tooltipItem.metaData) + '</p>'; 
				label.width = label.textWidth;
				label.height = label.textHeight;
				
				StyleManager.setEffects(label, this.style.text as Text, tooltipItem.metaData);
				
				bm = BitmapUtil.drawBitmap(label);
				bm.y = labelY - bm.height;
				
				labelsContainer.addChild(bm);
				labelY = - labelsContainer.height - style.vPadding;
			}
		}
		
		/**
		 */		
		private var labelsContainer:Sprite;
		
		/**
		 */		
		private var bg:Sprite = new Sprite;
		
		/**
		 * 每次样式配置发生改变时更新文字的样式表；
		 */		
		public function updateStyle():void
		{
			pStyle.fontSize = style.getTextFormat().size;
			pStyle.fontFamily = style.getTextFormat().font;
			pStyle.letterSpacing = style.getTextFormat().letterSpacing;
			pStyle.leading = style.getTextFormat().leading;
			
			if (style.getTextFormat().bold)
				pStyle.fontWeight = 'bold';
			else 
				pStyle.fontWeight = 'normal';
		}
		
		/**
		 * 背景
		 */		
		private function updateBgSize():void
		{
			// 设置背景尺寸参数
			bg.graphics.clear();
			style.tx = leftX;
			style.ty = topY;
			style.width = thisWidth;
			style.height = thisHeight;
		}
		
		/**
		 */		
		private function get lineStyle():BorderLine
		{
			return style.getBorder;
		}
		
		/**
		 */		
		private function get fillStyle():Fill
		{
			return style.getFill;
		}
		
		/**
		 */		
		private var pStyle:Object = new Object();
		
		/**
		 */		
		private var styleSheet:StyleSheet = new StyleSheet(); 
	}
}