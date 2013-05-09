package edit
{
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.elements.TextFormatStyle;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 */	
	public class LabelInput extends Sprite implements IStyleUI
	{
		public function LabelInput()
		{
			super();
			
			this.w = 50;
			hoverShape.visible = false;
			this.addChild(hoverShape);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		public function setTextFormat(size:uint, color:String):void
		{
			beforeInputStyleXML.format.@size = size;
			inputStyleXML.format.@size = size;
			
			beforeInputStyleXML.format.@color = color;
			inputStyleXML.format.@color = color;
		}
		
		/**
		 */		
		public function reset():void
		{
			this.field.text = '';
			this._inputText();
			
			hideBgField();
		}
		
		/**
		 */		
		private var _maxWidth:uint = 500;

		/**
		 */
		public function get maxWidth():uint
		{
			return _maxWidth;
		}

		/**
		 * @private
		 */
		public function set maxWidth(value:uint):void
		{
			_maxWidth = value;
		}

		
		/**
		 */		
		private var hoverShape:Shape = new Shape;
		
		/**
		 */		
		private function rollOver(evt:MouseEvent):void
		{
			hoverShape.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, select, false, 0, true);
		}
		
		/**
		 * 此时文本框被激活
		 */		
		private function select(evt:MouseEvent):void
		{
			ifSlected = true;
			
			this.graphics.clear();
			StyleManager.drawRect(this, this.selectStyle);
			
			stage.focus = field;
			
			if (bgField)
				bgField.visible = false;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		}
		
		/**
		 */		
		private var ifSlected:Boolean = false;
		
		/**
		 */		
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
				_unSelect();
		}
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			hoverShape.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, select);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, unSelect, false, 0, true);
		}
		
		/**
		 */		
		private function unSelect(evt:MouseEvent):void
		{
			_unSelect();
		}
		
		/**
		 */		
		private function _unSelect():void
		{
			ifSlected = false;
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			hideBgField();
			
			stage.focus = null;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, unSelect);
			this.graphics.clear();
			StyleManager.drawRect(this, this.defaultStyle);
		}
		
		/**
		 */		
		private function hideBgField():void
		{
			if (bgField)
			{
				if (RexUtil.ifTextNull(this.field.text))
					bgField.visible = true;
				else
					bgField.visible = false;	
			}
		}
		
		/**
		 * 默认样式
		 */		
		private var defaultStyle:Style = new Style;
		
		/**
		 */		
		private var selectStyle:Style = new Style;
		
		/**
		 */		
		private var _w:Number = 150;

		/**
		 */
		public function get w():Number
		{
			return _w;
		}

		/**
		 * @private
		 */
		public function set w(value:Number):void
		{
			defalutW = _w = value;
		}
		
		/**
		 */		
		private var defalutW:Number = 20;

		/**
		 */		
		public var h:Number = 30;
		
		/**
		 */		
		private var field:TextField;
		
		/**
		 */
		public function get text():String
		{
			return field.text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if (RexUtil.ifTextNull(value) == false)
			{
				field.text = value;
				
				_inputText();
				hideBgField();
			}
		}
		
		/**
		 */		
		public function get defaultTxt():String
		{
			return _defaultTxt;
		}

		public function set defaultTxt(value:String):void
		{
			_defaultTxt = value;
		}
		
		/**
		 */		
		private var _defaultTxt:String;
		
		
		/**
		 */		
		public function setRotation(value:Number):void
		{
			this.rotation = value;
			field.transform.matrix = null;
		}
		
		/**
		 */		
		public function render():void
		{
			if (field == null)
			{
				field = new TextField;
				field.type = TextFieldType.INPUT;
				field.x = field.y = gap;
				field.width = this.w - gap * 2;
				field.height = this.h - gap * 2;
				
				XMLVOMapper.fuck(beforeInputStyleXML, style);
				field.defaultTextFormat = (style as LabelStyle).getTextFormat();
				field.text = defaultTxt;
				this.h = field.textHeight + gap * 2;
				
				this._inputText();
				if (this.w > this.defalutW)
					this.defalutW = this.w;
				
				bgField = BitmapUtil.getBitmap(field);
				bgField.x = bgField.y = gap;
				this.addChild(bgField);
				
				XMLVOMapper.fuck(inputStyleXML, style);
				field.defaultTextFormat = (style as LabelStyle).getTextFormat();
				field.text = '';
				field.autoSize = TextFieldAutoSize.LEFT;
				field.addEventListener(Event.CHANGE, inputHandler, false, 0, true);
				this.addChild(field);
			}
			
			XMLVOMapper.fuck(this.defaultStyleXML, this.defaultStyle);
			XMLVOMapper.fuck(this.selectStyleXML, this.selectStyle);
				
			defaultStyle.width = this.selectStyle.width = w;
			defaultStyle.height = this.selectStyle.height = h;
			
			drawHoverShape();
			
			this.graphics.clear();
			StyleManager.drawRect(this, this.defaultStyle, this);
		}
		
		/**
		 */		
		private var gap:uint = 4;
		
		/**
		 */		
		private var bgField:Bitmap;
		
		/**
		 */		
		private function inputHandler(evt:Event):void
		{
			_inputText(true);
		}
		
		/**
		 */		
		private function _inputText(ifSelected:Boolean = false):void
		{
			if (field.textWidth + gap * 2 > this.maxWidth)
			{
				ifOverMaxWidth = true;
				field.autoSize = TextFieldAutoSize.NONE;
			}
			else if (field.textWidth + gap * 2 > this.defalutW)
			{
				if (ifOverMaxWidth)
				{
					field.autoSize = TextFieldAutoSize.LEFT;
					ifOverMaxWidth = false;
				}
				
				defaultStyle.width = selectStyle.width = _w = field.textWidth + gap * 2 + 6;
				field.width = field.textWidth + 6;
				
				this.graphics.clear();
				
				if (ifSelected)
					StyleManager.drawRect(this, this.selectStyle, this);
				else
					StyleManager.drawRect(this, this.defaultStyle, this);
				
				
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			else
			{
				if (ifOverMaxWidth)
				{
					field.autoSize = TextFieldAutoSize.LEFT;
					ifOverMaxWidth = false;
				}
				
				defaultStyle.width = selectStyle.width = _w = this.defalutW;
				field.width = this.defalutW - gap * 2;
				
				this.graphics.clear();
				
				if (ifSelected)
					StyleManager.drawRect(this, this.selectStyle, this);
				else
					StyleManager.drawRect(this, this.defaultStyle, this);
				
				
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			
			drawHoverShape();
		}
		
		/**
		 */		
		private var ifOverMaxWidth:Boolean = false;
		
		/**
		 */		
		private function drawHoverShape():void
		{
			if (ifSlected)
			{
				hoverShape.graphics.clear();
				hoverShape.graphics.beginFill(uint(selectStyle.getFill.color), Number(selectStyle.getFill.alpha));
				hoverShape.graphics.drawRect(0, 0, w, h);
			}
		}
		
		/**
		 */		
		public function get style():Style
		{
			return _style;
		}
		
		/**
		 */		
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style = new LabelStyle;
		
		/**
		 */		
		public function set metaData(value:Object):void
		{
			_meta = value;
		}
		
		public function get metaData():Object
		{
			return _meta;
		}
		
		/**
		 */		
		private var _meta:Object;
		
		/**
		 */		
		private var beforeInputStyleXML:XML =  <label>
													<format color='666666' font='微软雅黑' size='16' italic='true'/>
												</label>
			
		/**
		 */		
		private var inputStyleXML:XML =  <label>
											<format color='555555' font='微软雅黑' size='16' italic='false'/>
										</label>
		/**
		 */		
		public var defaultStyleXML:XML = <style>
											<fill color="FFFFFF" alpha='0'/>
											<border color='#eeeeee' thikness='1' alpha='1' pixelHinting='true'/>
										</style>
		/**
		 */		
		public var selectStyleXML:XML = <style>
											<fill color="DDDDDD" alpha='0.2'/>
											<border color='#2494E6' thikness='1' alpha='1' pixelHinting='true'/>
										</style>
			
			
											
	}
}