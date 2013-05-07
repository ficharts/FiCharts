package com.dataGrid 
{
	import com.fiCharts.utils.RexUtil;
	
	import flash.display.Shape;
	import flash.text.TextFormat;
	
	/**
	 */
    public class Column extends Object
    {
		/**
		 */		
		public var textFormat:TextFormat = new TextFormat("Arial", 12, 0x555555, false, false);
		
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
		public function get ifHasData():Boolean
		{
			var result:Boolean = false;
			
			for each (var item:CellData in this.data)
			{
				if (item && RexUtil.ifTextNull(item.label) == false)
				{
					result = true;
					break;
				}
			}
			
			return result;
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
				if (item)
				{
					item.label = "";
					item.shape.graphics.clear();
				}
			}
			
			this.data.length = 0;
			this.dataField = null;
			this.dataType = 'field';
		}
		
		/**
		 * 此列数据的类型, 决定数值的验证方式
		 */		
		public var dataType:String = "field"

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
