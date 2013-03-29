package 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 */	
    public class CellUI extends Sprite
    {
        private var field:TextField;

        public function CellUI()
        {
            this.field = new TextField();
            this.visible = false;
			
            addChild(this.field);
        }

		/**
		 */		
        public function get label() : String
        {
            return this.field.text;
        }
		
		/**
		 */		
        public function beforTex() : void
        {
            stage.focus = this.field;
            this.visible = true;
            this.field.background = true;
        }

		/**
		 */		
        public function leave() : void
        {
            this.visible = false;
            stage.focus = stage;
            this.field.background = false;
        }

		/**
		 */		
        public function text(value:String = "") : void
        {
            this.field.text = value;
			
            var index:* = this.field.getCharIndexAtPoint(this.field.mouseX, this.field.mouseY);
            this.field.setSelection(index, index);
			
            if (index == -1)
                this.field.setSelection((this.text.length + 1), (this.text.length + 1));
        }

		/**
		 */		
        public function moveTo(x:Number, y:Number, w:Number, h:Number) : void
        {
            this.x = x;
            this.y = y;
			
            this.field.width = w;
            this.field.height = h;
			
            this.field.type = TextFieldType.INPUT;
            this.field.defaultTextFormat = new TextFormat("微软雅黑", 14, 0x333333);
            this.field.defaultTextFormat.align = "left";
            this.field.backgroundColor = 0xFFFFFF;
        }

    }
}
