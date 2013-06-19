package com.fiCharts.ui.textInput
{
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.StageUtil;
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
	import com.fiCharts.ui.toolTips.ITipsSender;
	import com.fiCharts.ui.FiUI;
	
	/**
	 * 文本输入框
	 */	
	public class LabelInput extends FiUI implements IStyleUI, ITipsSender
	{
		public function LabelInput()
		{
			this.w = 50;
			this.h = 30;
			
			super();
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			hoverShape.visible = false;
			this.addChild(hoverShape);
			this.addChild(frame);
			this.addChild(this.canvas);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		}
		
		
		/**
		 */		
		public function setFocus():void
		{
			this._select();
			stage.focus = this.field;
		}
		
		/**
		 */		
		public function get hasText():Boolean
		{
			return !RexUtil.ifTextNull(this.text);
		}
		
		/**
		 */		
		public var ifWordwrap:Boolean = false;
		
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
			ifOver = true;
			
			hoverShape.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, select, false, 0, true);
		}
		
		/**
		 */		
		private var ifOver:Boolean = false;
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			ifOver = false;
			hoverShape.visible = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, select);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, unSelect, false, 0, true);
		}
		
		/**
		 */		
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			if (this.ifSlected)
			{
				// 此时回车是换行
				if (this.ifWordwrap && ifBreakLine == true)
					return;
				
				if (evt.keyCode == Keyboard.ENTER)
				{
					this.dispatchEvent(new LabelInputEvent(LabelInputEvent.ENTER_LEAVE));
					
					_unSelect();
				}
			}
		}
		
		/**
		 */		
		public var ifBreakLine:Boolean = true;
		
		/**
		 * 此时文本框被激活
		 */		
		private function select(evt:MouseEvent):void
		{
			if (ifOver)
			{
				_select();
			}
		}
		
		/**
		 */		
		private function _select():void
		{
			ifSlected = true;
			
			this.dispatchEvent(new Event(Event.SELECT));
			
			stage.focus = field;
			
			this.drawFrame();
			this.drawHoverShape();
			
			if (bgField)
				bgField.visible = false;
				
		}
		
		/**
		 */		
		private var ifSlected:Boolean = false;
		
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
			if (this.ifOver == false)
				_unSelect();
		}
		
		/**
		 */		
		private function _unSelect():void
		{
			if (ifSlected)
			{
				ifSlected = false;
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
		private function updateFieldSize():void
		{
			field.autoSize = TextFieldAutoSize.LEFT;
			
			if (this.ifWordwrap)
			{
				field.width = w - gap * 2;
				defaultStyle.width = selectStyle.width = w;
				
				h = field.textHeight + gap * 2;
				
				if (field.numLines > 1)
					h += 6;
				
				defaultStyle.height = this.selectStyle.height = h;
				
				drawFrame();
				drawHoverShape();
				
				if (field.numLines != currentNumline)
				{
					currentNumline = field.numLines;
					this.dispatchEvent(new Event(Event.RESIZE));
				}
				
				return;
			}
			
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
				
				defaultStyle.width = selectStyle.width = w = field.textWidth + gap * 2 + 6;
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
				
				defaultStyle.width = selectStyle.width = w = this.defalutW;
				field.width = this.defalutW - gap * 2;
				
				drawFrame();
				
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			
			drawHoverShape();
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
						this.selectStyle.width = this.defaultStyle.width = this.w = bgField.width + this.gap * 2;
						this.drawFrame();
						this.drawHoverShape();
					}
					
					field.autoSize = TextFieldAutoSize.NONE;
					this.field.width = this.w;
					this.dispatchEvent(new Event(Event.RESIZE));
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
		 * @private
		 */
		override public function set w(value:Number):void
		{
			defalutW = super.w = value;
		}
		
		/**
		 */		
		private var defalutW:Number = 20;

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
				field.autoSize = TextFieldAutoSize.LEFT;
				
				if (ifWordwrap)
				{
					field.multiline = true;
					field.wordWrap = true;
				}
				
				field.x = field.y = gap;
				
				XMLVOMapper.fuck(beforeInputStyleXML, style);
				
				field.defaultTextFormat = (style as LabelStyle).getTextFormat();
				field.text = defaultTxt;
				
				field.width = this.w - gap * 2;
				field.height = field.textHeight;
				this.h = field.textHeight + gap * 2;
				
				this.updateFieldSize();
				
				bgField = BitmapUtil.getBitmap(field);
				bgField.x = bgField.y = gap;
				this.canvas.addChild(bgField);
				
				XMLVOMapper.fuck(inputStyleXML, style);
				field.defaultTextFormat = (style as LabelStyle).getTextFormat();
				
				field.text = '';
				field.autoSize = TextFieldAutoSize.NONE;
				field.width = this.w - gap * 2;
				
				field.addEventListener(Event.CHANGE, inputHandler, false, 0, true);
				canvas.addChild(field);
			}
			
			defaultStyle.width = this.selectStyle.width = w;
			defaultStyle.height = this.selectStyle.height = h;
			
			drawHoverShape();
			drawFrame();
		}
		
		/**
		 */		
		private var canvas:Sprite = new Sprite;
		
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
		public function hideField():void
		{
			canvas.visible = false;
		}
		
		/**
		 */		
		public function showField():void
		{
			canvas.visible = true;
		}
		
		/**
		 */		
		private var currentNumline:uint = 1;
		
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
		public var defaultStyleXML:XML = <style radius="6">
											<fill color="FFFFFF" alpha='0'/>
											<border color='#eeeeee' thikness='1' alpha='0' pixelHinting='true'/>
										</style>
		/**
		 */		
		public var selectStyleXML:XML = <style radius="6">
											<fill color="EFEFEF" alpha='0.8'/>
											<border color='#DDDDDD' thikness='1' alpha='1' pixelHinting='true'/>
										</style>
			
			
											
	}
}