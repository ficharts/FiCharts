package com.fiCharts.ui.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * @author wallen
	 */	
	public class Label extends TextField
	{
		private var _label:String;
		
		/**
		 */		
		public function Label( $label:String = " ", $wordWrap:Boolean = false )
		{
			super();
			
			mouseEnabled = false;
			
			thickness = 100;
			wordWrap = $wordWrap;
			FontFamily.setFontForTextField( this );
			renderText( FontFamily.format, $label );
		}
		
		/**
		 */		
		public function get labelWidth():Number
		{
			return textWidth;
		}
		
		public function get labelHeight():Number
		{
			return textHeight;
		}
		
		/**
		 * @param $align
		 */		
		public function setAlign($align:String):void
		{
			var textFormat:TextFormat = this.getTextFormat();
			textFormat.align = $align;
			
			if ($align != "left")
			{
				gridFitType = flash.text.GridFitType.SUBPIXEL;
			}
			
			renderText( textFormat, text );
		}
		
		/**
		 * 
		 * @param $labelText
		 * 
		 */		
		public function reLabel($labelText:String = null ):void
		{
			if ( $labelText == null )
			{
				$labelText = _label;
			}
			renderText( getTextFormat(), $labelText );
		}
		
		/**
		 * @param $color
		 */		
		public function setColor($color:uint):void
		{
			var textFormat:TextFormat = getTextFormat();
			textFormat.color = $color;
			
			renderText(textFormat);
		}
		
		/**
		 * @param $color
		 */		
		public function set isItalic(value:Boolean):void
		{
			var textFormat:TextFormat = getTextFormat();
			textFormat.italic = value;
			
			renderText(textFormat);
		}
		
		/**
		 * @param blod
		 */		
		public function set isBlod( blod : Boolean ) : void
		{
			var textFormat:TextFormat = getTextFormat();
			textFormat.bold = blod;
			
			renderText(textFormat);
		}
		
		/**
		 * @param blod
		 */		
		public function set isUnderLine( underLine : Boolean ) : void
		{
			var textFormat:TextFormat = getTextFormat();
			textFormat.underline = underLine;
			
			renderText(textFormat);
		}
		
		/**
		 * 
		 * @param $size
		 * 
		 */		
		public function setSize($size:uint):void
		{
			var textFormat:TextFormat = getTextFormat();
			textFormat.size = $size;
			
			renderText(textFormat);
		}
		
		/**
		 * @param $font
		 * 
		 */		
		public function setFont( $font : String ):void
		{
			var textFormat:TextFormat = getTextFormat();
			textFormat.font = $font;
			
			renderText(textFormat);
		}
		
		/**
		 */		
		public function autoSizeFont():void
		{
			renderText( getTextFormat() );
		}
		
		/**
		 * 
		 * @param $format
		 * @param $label
		 * 
		 */		
		public function renderText($format:TextFormat, $label:String = null):void
		{
			if ($label)
			{
				_label = $label;
			}
			
			if (_label)
			{
				text = _label;
				setTextFormat($format);
			}
			
			width = textWidth + fix;
			height = textHeight + fix;
		}
		
		/**
		 */		
		override public function set htmlText(value:String):void
		{
			super.htmlText = value;
			
			width = textWidth + fix;
			height = textHeight + fix;
		}
		
		/**
		 */		
		private var fix:uint = 0;
	}
}