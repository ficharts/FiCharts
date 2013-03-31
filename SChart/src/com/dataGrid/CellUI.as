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
			field.defaultTextFormat = new TextFormat("微软雅黑", 14, 0x333333);
			field.defaultTextFormat.align = "left";
			
            this.visible = false;
			addChild(bg);
            addChild(field);
        }

		/**
		 */		
        public function get label() : String
        {
            return this.field.text;
        }
		
		/**
		 */		
		public function restrict():void
		{
			field.restrict = "0-9 \\-\\ .";
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
        }

		/**
		 * 设置单元格文本，并将光标定位到鼠标位置
		 */		
        public function setTxtAndHover(value:String = ""):void
        {
			setTxt(value);
			
            var index:int = this.field.getCharIndexAtPoint(this.field.mouseX, this.field.mouseY);
            this.field.setSelection(index, index);
			
            if (index == -1)
                this.field.setSelection((this.setTxtAndHover.length + 1), (this.setTxtAndHover.length + 1));
        }
		
		/**
		 */		
		public function setTxt(txt:String):void
		{
			this.field.text = txt;
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
