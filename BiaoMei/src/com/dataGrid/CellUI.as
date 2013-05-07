package com.dataGrid 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * 动态单元格，全局仅有此一个
	 */	
    public class CellUI extends Sprite
    {
		/**
		 */		
        private var field:TextField = new TextField;

		/**
		 */		
        public function CellUI()
        {
			field.type = TextFieldType.INPUT;
			field.autoSize = TextFieldAutoSize.LEFT;
			//field.defaultTextFormat = new TextFormat("微软雅黑", 14, 0x333333);
			//field.defaultTextFormat.align = "left";
			
            this.visible = false;
			addChild(bg);
            addChild(field);
        }

		/**
		 */		
        public function get label():String
        {
            return this.field.text;
        }
		
		/**
		 */		
		public function restrictNum():void
		{
			field.restrict = "0-9 \\-\\ .";
		}
		
		/**
		 */		
		public function notRestrict():void
		{
			field.restrict = null;
		}
		
		/**
		 */		
        public function beforTex() : void
        {
            stage.focus = this.field;
            this.visible = true;
			bg.visible = true;
        }

		/**
		 */		
        public function leave() : void
        {
            this.visible = false;
            stage.focus = stage;
            bg.visible = false;
			
			this.dispatchEvent(new DataGridEvent(DataGridEvent.DATA_CHNAGED));
        }

		/**
		 * 设置单元格文本，并将光标定位到鼠标位置
		 */		
        public function setTxtAndHover(value:String = ""):void
        {
			setTxt(value);
			
            var index:int = this.field.getCharIndexAtPoint(this.field.mouseX, this.field.mouseY);
            this.field.setSelection(index, index);
			
			// 双击点超过字符范围时，光标停留在字符最后位置
            if (index == -1)
                this.field.setSelection((this.field.length), (this.field.length));
        }
		
		/**
		 */		
		public function setTxt(txt:String):void
		{
			this.field.text = txt;
		}
		
		/**
		 */		
		public function setTextFormat(format:TextFormat):void
		{
			field.defaultTextFormat = format;
		}

		/**
		 */		
        public function moveTo(x:Number, y:Number, w:Number, h:Number) : void
        {
            this.x = x;
            this.y = y;
			
            field.width = w;
            field.height = h;
			
			bg.graphics.clear()
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, w, h);
        }
		
		/**
		 */		
		private var bg:Shape = new Shape;

    }
}
