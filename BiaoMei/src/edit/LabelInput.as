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
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
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
			this.addChild(frame);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		/**
		 */		
		public function toImgMode():void
		{
			ifIMGModel = true;
			
			clearProxy();
			
			proxyBm = BitmapUtil.getBitmap(this.field);
			proxyBm.x = field.x;
			proxyBm.y = field.y;
			this.addChild(proxyBm);
			
			this.field.alpha = 0;
		}
		
		/**
		 */		
		private var proxyBm:Bitmap;
		
		/**
		 */		
		public function activit():void
		{
			ifIMGModel = false;
			clearProxy();
			
			this.field.alpha = 1;
		}
		
		/**
		 */		
		private var ifIMGModel:Boolean = false;
		
		/**
		 */		
		private function clearProxy():void
		{
			if (proxyBm && this.contains(proxyBm))
			{
				this.removeChild(proxyBm)
				proxyBm = null;
			}
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if (RexUtil.ifTextNull(value) == false)
			{
				var temRot:Number = this.rotation;
				var temSx:Number = this.scaleX;
				var temSy:Number = this.scaleY;
				
				this.rotation = 0;
				this.scaleX = this.scaleY = 1;
				
				field.text = value;
				
				updateFieldSize();
				
				checkIfShowDefaultText();
				
				if (ifIMGModel)
					this.toImgMode();
				
				this.rotation = temRot;
				this.scaleX = temSx;
				this.scaleY = temSy;
			}
		}
		
		/**
		 */		
		private var frame:Shape = new Shape;
		
		/**
		 */		
		public function setTextFormat(size:uint, color:String = '555555'):void
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
			
			this.updateFieldSize();
			
			if (this.ifIMGModel)
				this.toImgMode();
			
			checkIfShowDefaultText();
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
			
			this.dispatchEvent(new Event(Event.SELECT));
			
			stage.focus = field;
			
			this.drawFrame();
			this.drawHoverShape();
			
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
			{
				_unSelect();
			}
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
		public function leave():void
		{
			_unSelect();
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
			if (ifSlected)
			{
				ifSlected = false;
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				
				checkIfShowDefaultText();
				
				stage.focus = null;
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, unSelect);
				frame.graphics.clear();
				StyleManager.drawRectOnShape(frame, this.defaultStyle);
				
				this.dispatchEvent(new Event(Event.MOUSE_LEAVE));
			}
		}
		
		/**
		 */		
		private function checkIfShowDefaultText():void
		{
			if (bgField)
			{
				if (RexUtil.ifTextNull(this.field.text))
				{
					bgField.visible = true;
					
					if (this.w < bgField.width + this.gap * 2)
					{
						this.selectStyle.width = this.defaultStyle.width = this._w = bgField.width + this.gap * 2;
						this.drawFrame();
						this.drawHoverShape();
					}
				}
				else
				{
					bgField.visible = false;	
					updateFieldSize();
				}
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
		}
		
		/**
		 */		
		public function render():void
		{
			XMLVOMapper.fuck(this.defaultStyleXML, this.defaultStyle);
			XMLVOMapper.fuck(this.selectStyleXML, this.selectStyle);
			
			if (field == null)
			{
				field = new TextField;
				field.type = TextFieldType.INPUT;
				//field.antiAliasType = AntiAliasType.ADVANCED;
				//field.gridFitType = GridFitType.SUBPIXEL
				field.x = field.y = gap;
				
				XMLVOMapper.fuck(beforeInputStyleXML, style);
				field.defaultTextFormat = (style as LabelStyle).getTextFormat();
				field.text = defaultTxt;
				
				field.width = this.w - gap * 2;
				field.height = this.h - gap * 2;
				this.h = field.textHeight + gap * 2;
				
				this.updateFieldSize();
				
				/*if (this.w > this.defalutW)
					this.defalutW = this.w;*/
				
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
			
			defaultStyle.width = this.selectStyle.width = w;
			defaultStyle.height = this.selectStyle.height = h;
			
			drawHoverShape();
			drawFrame();
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
			updateFieldSize();
		}
		
		/**
		 */		
		private function updateFieldSize():void
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
				
				drawFrame();
				
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
				
				drawFrame();
				
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			
			drawHoverShape();
		}
		
		/**
		 */		
		private function drawFrame():void
		{
			frame.graphics.clear();
			
			if (this.ifSlected)
				StyleManager.drawRectOnShape(frame, this.selectStyle, this);
			else
				StyleManager.drawRectOnShape(frame, this.defaultStyle, this);
		}
		
		/**
		 */		
		private var ifOverMaxWidth:Boolean = false;
		
		/**
		 */		
		private function drawHoverShape():void
		{
			hoverShape.graphics.clear();
			hoverShape.graphics.beginFill(uint(selectStyle.getFill.color), Number(selectStyle.getFill.alpha));
			
			if (this.ifSlected)
				hoverShape.graphics.drawRect(0, 0, selectStyle.width, h);
			else
				hoverShape.graphics.drawRect(0, 0, this.defaultStyle.width, h);
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