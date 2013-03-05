package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	
	/**
	 */	
	public class LabelUI extends Sprite implements IStyleUI
	{
		public function LabelUI()
		{
			super();
			
			addChild(textField);
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		/**
		 */		
		private var _text:String;

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
			if (labelStyle == null) return;
			
			this.visible = labelStyle.enable;
			StyleManager.setLabelUIText(this, this.metaData);
			textField.autoSize = TextFieldAutoSize.CENTER;
			
			if (labelStyle.layout == LabelStyle.WRAP)
			{
				textField.wordWrap = true;
				textField.autoSize = 'center';
				
				if (maxLabelWidth - labelStyle.hPadding * 2 < minLabelWidth)
					textField.width = minLabelWidth;
				else
					textField.width = maxLabelWidth - labelStyle.hPadding * 2;
				
				textField.defaultTextFormat = labelStyle.getTextFormat(metaData);
				textField.text = text;
				
				textField.x = labelStyle.hPadding;
				textField.height = textField.textHeight;
			}
			else
			{
				textField.wordWrap = false;
				textField.autoSize = 'none';
				textField.defaultTextFormat = labelStyle.getTextFormat(metaData);
				textField.text = text;
				textMetric = textField.getLineMetrics(0);  
				textField.width = textField.textWidth + textMetric.leading;
				textField.height = textField.textHeight;
				textField.x = labelStyle.hPadding - textMetric.leading / 2;
			}
			
			StyleManager.setEffects(textField, labelStyle.text as Text, metaData);
			
			// 绘制背景
			this.graphics.clear();
			StyleManager.setShapeStyle(labelStyle, this.graphics, this.metaData);
			this.graphics.drawRoundRect(0, 0, this.uiWidth, this.uiHeight, labelStyle.radius, labelStyle.radius);
			
			textField.x = labelStyle.hPadding;
			textField.y = labelStyle.vPadding;
		}
		
		/**
		 */		
		private var textMetric:TextLineMetrics;
		
		/**
		 */		
		public var maxLabelWidth:Number = 0;
		
		/**
		 */		
		private var minLabelWidth:Number = 15;
		
		/**
		 * 相对于某点的布局, 默认居中
		 */		
		public function layout(x:Number, y:Number):void
		{
			if (labelStyle.hAlign == 'right')
			{
				this.x = x //+ labelStyle.hPadding;
			}
			else if (labelStyle.hAlign == 'left')
			{
				this.x = x - this.uiWidth //- labelStyle.hPadding;
			}
			else
			{
				this.x = x - this.uiWidth / 2;
			}
			
			// 垂直布局
			if (labelStyle.vAlign == 'bottom')
			{
				this.y = y //+ labelStyle.vPadding;
			}
			else if (labelStyle.vAlign == 'top')
			{
				this.y = y - this.uiHeight //- labelStyle.vPadding;	
			}
			else
			{
				this.y = y - this.uiHeight / 2;	
			}
		}
		
		override public function get width():Number
		{
			return uiWidth;
		}
		
		override public function get height():Number
		{
			return uiHeight
		}
		
		/**
		 * 用textWidth是为了防止当换行显示时，maxLabelWidth 过大�这时要截取此Label的图时右�
		 * 
		 * 将有一部分空白，为了避免截取多余的空白区域这用textWidth靠谱一些，不能用width
		 */		
		private function get uiWidth():Number
		{
			return textField.x + textField.width + labelStyle.hPadding; 
		}
		
		/**
		 * 换行�textField 的高度不等于 textHeight �区域的Bound高度�鄙视一下adobe
		 */		
		private function get uiHeight():Number
		{
			return textField.height + labelStyle.vPadding * 2;
		}
		
		/**
		 */		
		private var textField:TextField = new TextField();
		
		/**
		 */		
		public function get style():Style
		{
			return labelStyle;
		}
		
		/**
		 */		
		public function set style(value:Style):void
		{
			labelStyle = value as LabelStyle;
		}
		
		/**
		 */		
		private var _metaData:Object;

		public function get metaData():Object
		{
			return _metaData;
		}

		public function set metaData(value:Object):void
		{
			_metaData = value;
		}
		
		/**
		 */		
		private var labelStyle:LabelStyle;
		
	}
}