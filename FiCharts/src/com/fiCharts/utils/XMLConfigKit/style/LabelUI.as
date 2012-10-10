package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.ui.text.Label;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
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
			textField.text = text;
			textField.setTextFormat(labelStyle.getTextFormat(metaData));
			
			textField.x = labelStyle.hPadding;
			textField.y = labelStyle.vPadding;
			
			textField.width = textField.textWidth;
			textField.height = textField.textHeight;
			textField.autoSize = TextFieldAutoSize.CENTER;
			
			StyleManager.setEffects(textField, labelStyle.text as Text, metaData);
			
			// 绘制背景
			this.graphics.clear();
			StyleManager.setShapeStyle(labelStyle, this.graphics, this.metaData);
			this.graphics.drawRoundRect(0, 0, this.uiWidth, this.uiHeight, labelStyle.radius, labelStyle.radius);
		}
		
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
		
		/**
		 */		
		private function get uiWidth():Number
		{
			return textField.textWidth + labelStyle.hPadding * 2; 
		}
		
		/**
		 */		
		private function get uiHeight():Number
		{
			return textField.textHeight + labelStyle.vPadding * 2;
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