package com.dataGrid 
{
	import flash.display.Shape;

	/**
	 * 背景网格
	 */	
    public class Grid extends Shape
    {
        private var _startColumnIndex:uint = 0;
        private var _startRowIndex:uint = 0;
		
        private var _w:Number = 840;
        private var _h:Number = 500;
		
        private var _defaultCellW:Number = 70;
        private var _defaultCellH:Number = 20;

		/**
		 */		
        public function Grid()
        {
        }

		/**
		 */		
        public function render(columns:Vector.<Column>, rows:Vector.<Row>) : void
        {
            var column:Column = null;
            var row:Row = null;
			
            var columnLen:int = columns.length;
            var rowLen:int = rows.length;
			
            var temW:Number = 0;
            var temH:Number = 0;
			
            var index:uint = 0;
			
            this.graphics.clear();
            this.graphics.lineStyle(1, 0xDEDEDE, 1);
            this.graphics.drawRect(0, 0, this.w, this.h);
			
            index = this.startColumnIndex;
			
            while (temW < this.w)
            {
                if (index >= columnLen)
					column = columns[index] = new Column();
                else
                    column = columns[index];
				
				column.x = temW;
				column.width = this.defaultCellW;
                temW = column.x + column.width;
				
                if (temW < this.w)
                {
                    this.graphics.moveTo(temW, 0);
                    this.graphics.lineTo(temW, this.h);
                }
				
                index = index + 1;
            }
			
			
            index = this.startRowIndex;
            while (temH < this.h)
            {
                if (index >= rowLen)
					row = rows[index] = new Row();
                else
                    row = rows[index];
				
				
				row.y = temH;
				row.height = this.defaultCellH;
                temH = row.y + row.height;
				
                if (temH < this.h)
                {
                    this.graphics.moveTo(0, temH);
                    this.graphics.lineTo(this.w, temH);
                }
				
                index = index + 1;
            }
        }

		/**
		 */		
        public function get startColumnIndex():uint
        {
            return this._startColumnIndex;
        }

		/**
		 */		
        public function set startColumnIndex(value:uint):void
        {
            this._startColumnIndex = value;
        }

		/**
		 */		
        public function get startRowIndex():uint
        {
            return this._startRowIndex;
        }

		/**
		 */		
        public function set startRowIndex(value:uint):void
        {
            this._startRowIndex = value;
        }

		/**
		 */		
        public function get w():Number
        {
            return this._w;
        }

		/**
		 */		
        public function set w(value:Number):void
        {
            this._w = value;
        }

		/**
		 */		
        public function get h():Number
        {
            return this._h;
        }

		/**
		 */		
        public function set h(value:Number):void
        {
            this._h = value;
        }

		/**
		 */		
        public function get defaultCellW():Number
        {
            return this._defaultCellW;
        }

		/**
		 */		
        public function set defaultCellW(param1:Number):void
        {
            this._defaultCellW = param1;
        }

		/**
		 */		
        public function get defaultCellH():Number
        {
            return this._defaultCellH;
        }

		/**
		 */		
        public function set defaultCellH(value:Number):void
        {
            this._defaultCellH = value;
        }

    }
}
