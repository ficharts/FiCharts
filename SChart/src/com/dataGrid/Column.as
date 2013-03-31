package com.dataGrid 
{
	import flash.display.Shape;

	/**
	 */
    public class Column extends Object
    {
		/**
		 * 限制输入类型
		 */		
		public var ifNumContents:Boolean = false;
		
		/**
		 */		
        private var _x:Number = 0;
		
		/**
		 */		
        private var _width:Number = 0;
		
		
		/**
		 * 行数
		 */		
		public function get rowLen():uint
		{
			return data.length;
		}

		/**
		 */		
        public function Column()
        {
            this._data = new Vector.<CellData>;
        }
		
		/**
		 * 清空 所有数据节点
		 */		
		public function clear():void
		{
			for each (var item:CellData in this.data)
			{
				item.label = "";
				item.shape.graphics.clear();
			}
			
			this.data.length = 0;
		}

		/**
		 */		
        public function getCellData(rowIndex:uint):CellData
        {
            var cellData:CellData = null;
			
            if (rowIndex < this.data.length)
            {
                cellData = this.data[rowIndex];
				
                if (cellData == null)
					cellData =  this.data[rowIndex] = new CellData();
            }
            else
            {
                this.data.length = rowIndex;
				cellData = this.data[rowIndex] = new CellData();
            }
			
            return cellData;
        }

		/**
		 */		
        public function saveCellData(label:String, rowIndex:uint):Shape
        {
            var celData:CellData = this.getCellData(rowIndex);
            celData.label = label;
			
            return celData.shape;
        }

		/**
		 */		
        public function get x():Number
        {
            return this._x;
        }

		/**
		 */		
        public function set x(param1:Number):void
        {
            this._x = param1;
        }

		/**
		 */		
        public function get width():Number
        {
            return this._width;
        }

		/**
		 */		
        public function set width(value:Number):void
        {
            this._width = value;
        }

		/**
		 */		
        public function get data():Vector.<CellData>
        {
            return this._data;
        }

		/**
		 */		
        public function set data(value:Vector.<CellData>):void
        {
            this._data = value;
        }
		
		/**
		 */		
		private var _data:Vector.<CellData>;
		
		/**
		 */
		public function get dataField():String
		{
			return _field;
		}
		
		/**
		 * @private
		 */
		public function set dataField(value:String):void
		{
			_field = value;
		}
		
		/**
		 */		
		private var _field:String = null;

    }
}
