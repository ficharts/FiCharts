package com.dataGrid 
{
	import com.fiCharts.utils.StageUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	
	/**
	 * 如果用户先输入数据，在选择图表类型，就有可能导致
	 * 
	 * 有些已有数据格式与序列不符，需要容错处理；
	 * 
	 * 同样，在每次数据输入后也需要做容错验证；
	 * 
	 * 容错主要针对数字类型的列，如果数据有问题则，图表预览不可操作 
	 */	
	
	/**
	 * 表格，表格的行数应该可以自动添加和删除，适应内容
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
			StageUtil.initApplication(this, init);
        }
		
		/**
		 */		
		private function init():void
		{
			this.editCanvas.columns = this.columns;
			this.editCanvas.rows = this.rows;
			
			this.editCanvas.w = this.gridW;
			this.editCanvas.h = this.gridH;
			
			addChild(this.grid);
			addChild(this.editCanvas);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
			
			this.addEventListener(DataGridEvent.DATA_CHNAGED, dataChanged, false, 0, true);
			this.addEventListener(DataGridEvent.ADD_ROW, addRowHandler, false, 0, true);
		}
		
		/**
		 */		
		private function addRowHandler(evt:DataGridEvent):void
		{
			this.gridH += grid.defaultCellH;
			this.grid.render(this.columns, this.rows);
			renderBG();
			
			this.dispatchEvent(new DataGridEvent(DataGridEvent.UPDATA_SEIZE));
		}
		
		/**
		 * 验证数据列的内容
		 * 
		 * 数据验证有两种，一种是用户输入数据是的实时验证；
		 * 
		 * 一种是现有数据的情况下，添加序列后需要重新验证属于其的数据列
		 */		
		public function verifyColumnData(columnIndex:uint):void
		{
			var column:Column = this.columns[columnIndex];
			var data:Vector.<CellData> = column.data;
			var ifNeedVerify:Boolean = editCanvas.ifNeedVerify(column);
			
			for each(var cellData:CellData in data)
				this.editCanvas.vertifyCellData(ifNeedVerify, cellData);
		}
		
		/**
		 * 单元格数据改变
		 */		
		private function dataChanged(evt:Event):void
		{
			ifDataChanged = true;
		}
		
		/**
		 */		
		public var ifDataChanged:Boolean = false;
		
		/**
		 */		
		private function rollOverHandler(evt:MouseEvent):void
		{
			editCanvas.ifActivation = true;
			
			if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, unSelectedHandler);
		}
		
		/**
		 */		
		private function rollOutHandler(evt:MouseEvent):void
		{
			editCanvas.ifActivation = false;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, unSelectedHandler, false, 0, true);
		}
		
		/**
		 */		
		private function unSelectedHandler(evt:MouseEvent):void
		{
			editCanvas.unSelectCell();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, unSelectedHandler);
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
		public function enable():void
		{
			mouseChildren = this.mouseEnabled = true;
		}
		
		/**
		 */		
		public function disEnable():void
		{
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		/**
		 */		
		public function get ifHasData():Boolean
		{
			var result:Boolean = false;
			
			for each(var column:Column in this.columns)
			{
				if (column.ifHasData)
				{
					result = true;
					break;
				}
			}
			
			return result;
		}
		
		/**
		 */		
		public function getDataFields():Array
		{
			var result:Array = [];
			var columnIndex:uint = 0;
			for each (var column:Column in columns)
			{
				if(column.dataField)
					result.push(column.dataField);
				else
					result.push("field" + columnIndex);
					
				columnIndex += 1;
			}
			
			return result;
		}
		
		/**
		 */
		public function get data():Array
		{
			var value:Array = [];
			var item:Object;
			var columnIndex:uint = 0;
			
			for (var rowIndex:uint = 0; rowIndex < rows.length; rowIndex ++)
			{
				item = {};
				columnIndex = 0;
				for each(var column:Column in this.columns)
				{
					if(column.dataField)
					{
						if (rowIndex < column.data.length && column.data[rowIndex])
							item[column.dataField] = column.data[rowIndex].label;
					}
					else
					{
						if (rowIndex < column.data.length && column.data[rowIndex])
							item["field" + columnIndex] = column.data[rowIndex].label;
					}
					
					columnIndex += 1;
				}
				
				value.push(item);
			}
			
			return value;
		}
		
		/**
		 * 清空表格的数据
		 */		
		public function clear():void
		{
			if (soruceData)
			{
				soruceData.length = 0;
				soruceData = null;
			}
			
			var index:uint = 0;
			for each (var column:Column in this.columns)
			{
				column.clear();
				column.dataField = "field" + index;
				
				index += 1;
			}
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
			
			renderBG();
		}
		
		/**
		 *  绘制白色背景
		 */		
		private function renderBG():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, gridW, gridH);
		}
		
		/**
		 * 
		 * 如果用户已经输入了数据，图表模板选择后只是更新模板内的数据
		 * 
		 * 在编辑页面改变图表类型时，数据不变
		 * 
		 */		
        public function render():void
        {
			if (ifDataChanged)
			{
				editCanvas.hideCellUI();
				
				var row:Row;
				var cellData:CellData;
				
				var columnIndex:int = 0;
				var rowIndex:uint = 0;
				var field:String;
				
				// 数据量大于表格行数，需要添加行
				if (this.soruceData.length > this.rows.length)
				{
					var rows:uint = this.soruceData.length - this.rows.length;
					
					this.gridH += grid.defaultCellH * rows;
					this.grid.render(this.columns, this.rows);
					renderBG();
					
					this.dispatchEvent(new DataGridEvent(DataGridEvent.UPDATA_SEIZE));
				}
				
				for each(var item:Object in this.soruceData)
				{
					for (columnIndex = 0; columnIndex < this.columns.length; columnIndex ++)
					{
						field = columns[columnIndex].dataField;
						
						if (field)
						{
							if (item[field] == null)
								item[field] = "";
							
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
        public function set gridH(value:Number):void
        {
            this.grid.h = value;
        }
		
		/**
		 */		
		public function fillColumnBG(index:uint = 0):void
		{
			this.graphics.beginFill(0xEEEEEE, 0.5);
			this.graphics.drawRect(0, 0, this.columns[index].width, this.gridH);
		}
		
		/**
		 */		
		public function setColumnTextFormat(index:uint, format:TextFormat):void
		{
			columns[index].textFormat = format;
		}
		

    }
}
