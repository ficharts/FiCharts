package com.dataGrid 
{
	import flash.display.Sprite;

	/**
	 */
    public class DataGrid extends Sprite
    {
		/**
		 */		
        public var columns:Vector.<Column> = new Vector.<Column>;
        private var rows:Vector.<Row> = new Vector.<Row>;
		
		/**
		 */		
        private var grid:Grid = new Grid;
        private var editCanvas:EditCanvas = new EditCanvas;

		/**
		 */		
        public function DataGrid()
        {
            this.editCanvas.columns = this.columns;
            this.editCanvas.rows = this.rows;
			
            this.editCanvas.w = this.gridW;
            this.editCanvas.h = this.gridH;
			
			addChild(this.grid);
            addChild(this.editCanvas);
        }
		
		/**
		 * 设置列的数据字段
		 */		
		public function setColumnFieds(fields:Array):void
		{
			var i:uint = 0;
			for (i = 0; i < fields.length; i ++)
				columns[i].dataField = fields[i];
		}
		
		/**
		 */
		public function get data():Array
		{
			var value:Array = [];
			var item:Object;
			for (var rowIndex:uint = 0; rowIndex < rows.length; rowIndex ++)
			{
				item = {};
				for each(var column:Column in this.columns)
				{
					if(column.dataField)
					{
						if (rowIndex < column.data.length && column.data[rowIndex])
							item[column.dataField] = column.data[rowIndex].label;
					}
				}
				
				value.push(item);
			}
			
			return value;
		}
		
		/**
		 */
		public function set data(value:Array):void
		{
			if (value != soruceData)
			{
				soruceData = value;
				ifDataChanged = true;				
			}
		}
		
		/**
		 */		
		private var soruceData:Array;
		
		/**
		 */		
		private var ifDataChanged:Boolean = false;
		
		
		/**
		 * 渲染背景网格，并创建行列/刷新行列
		 */		
		public function preRender():void
		{
			//先清空行列的数据内容，还原默认尺寸，然后绘制表格
			for each(var column:Column in this.columns)
			{
				column.clear();
				column.width = this.grid.defaultCellW;
			}
			
			for each(var row:Row in this.rows)
				row.height = grid.defaultCellH;
			
			this.grid.render(this.columns, this.rows);
		}
		
		/**
		 */		
        public function render():void
        {
			if (ifDataChanged)
			{
				var row:Row;
				var cellData:CellData;
				
				var columnIndex:int = 0;
				var rowIndex:uint = 0;
				var field:String;
				for each(var item:Object in this.soruceData)
				{
					for (columnIndex = 0; columnIndex < this.columns.length; columnIndex ++)
					{
						field = columns[columnIndex].dataField;
						if (field)
						{
							this.editCanvas.renderCell(columns[columnIndex], rowIndex, this.rows[rowIndex], item[field]);
						}
					}
					
					rowIndex ++;
				}
				
			}
        }

		/**
		 */		
        public function get gridW():Number
        {
            return this.grid.w;
        }

		/**
		 */		
        public function set gridW(value:Number):void
        {
            this.grid.w = value;
        }

		/**
		 */		
        public function get gridH():Number
        {
            return this.grid.h;
        }

		/**
		 */		
        public function set gridH(param1:Number):void
        {
            this.grid.h = param1;
        }

    }
}
