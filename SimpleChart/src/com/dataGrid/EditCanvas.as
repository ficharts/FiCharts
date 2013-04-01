package com.dataGrid 
{
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	/**
	 * 单元格数据的绘制与编辑
	 */
    public class EditCanvas extends Sprite
    {
		/**
		 */		
        public var columns:Vector.<Column>;
        public var rows:Vector.<Row>;
      
		/**
		 */		
        public var w:Number = 0;
        public var h:Number = 0;
		
		/**
		 */		
        private var newColumnIndex:int = 0;
        private var newRowIndex:int = 0;
		
		/**
		 */		
        public var currentColumn:Column;
        public var currentRow:Row;
		
		/**
		 */		
        public var currentColumnIndex:int = -1;
        public var currentRowIndex:int = -1;
		
		/**
		 * 文本画布，你看到的图表数据其实都是单元格的截图
		 */		
        private var textCanvas:Sprite = new Sprite;
		
		/**
		 */		
		private var cellUI:CellUI = new CellUI;

		/**
		 */		
        public function EditCanvas()
        {
			this.textCanvas.mouseEnabled = textCanvas.mouseChildren =  false;
            this.addChild(this.textCanvas);
            this.addChild(this.cellUI);
			
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

		/**
		 */		
        private function init(event:Event):void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.downHandler, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 0, true);
			
            this.doubleClickEnabled = true;
            this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleHandler, false, 0, true);
			
            stage.doubleClickEnabled = true;
            stage.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleHandler, false, 0, true);
        }

		/**
		 */		
        private function doubleHandler(event:Event):void
        {
            this.readyToTex();
            this.cellUI.setTxtAndHover(this.cellData.label);
        }

		/**
		 */		
        private function get cellData():CellData
        {
            return this.currentColumn.getCellData(this.currentRowIndex);
        }

		/**
		 */		
        private function downHandler(event:Event):void
        {
            PerformaceTest.start();
			
            this.findNewCell();
			
            if (this.ifNewCell)
                this.swtichCell();
			
            PerformaceTest.end("Down单元格选取");
        }

		/**
		 */		
        private function swtichCell() : void
        {
            this.cellUI.leave();
            this.drawCurCell();
            this.moveToNewCell();
        }

		/**
		 */		
        private function get ifNewCell() : Boolean
        {
            if (this.newColumnIndex == this.currentColumnIndex && this.newRowIndex == this.currentRowIndex)
                return false;
			else
				return true;
        }

		/**
		 */		
        private function findNewCell() : void
        {
            var column:Column = null;
            var row:Row = null;
            var i:uint = 0;
			
            for each (column in this.columns)
            {
                if (parent.mouseX >= column.x && parent.mouseX <= column.x + column.width)
                {
                    this.newColumnIndex = i;
                    break;
                }
				
                i = i + 1;
            }
			
            i = 0;
            for each (row in this.rows)
            {
                if (parent.mouseY >= row.y && parent.mouseY <= row.y + row.height)
                {
                    this.newRowIndex = i;
                    break;
                }
				
                i = i + 1;
            }
        }

		/**
		 */		
        private function moveToNewCell() : void
        {
            this.currentColumnIndex = this.newColumnIndex;
            this.currentRowIndex = this.newRowIndex;
			
            this.currentColumn = this.columns[this.currentColumnIndex];
            this.currentRow = this.rows[this.currentRowIndex];
			
            this.graphics.clear();
            this.graphics.lineStyle(2, 0, 1);
            this.graphics.drawRect(this.currentColumn.x, this.currentRow.y, this.currentColumn.width, this.currentRow.height);
			
            this.cellUI.moveTo(this.currentColumn.x, this.currentRow.y, this.currentColumn.width, this.currentRow.height);
            this.cellUI.setTxtAndHover(this.currentColumn.getCellData(this.currentRowIndex).label);
        }

		/**
		 * 渲染当前单元格
		 */		
        private function drawCurCell() : void
        {
            if (currentColumn && this.currentRow)
				drawAndSaveCell(currentColumn, currentRowIndex, currentRow);
        }
		
		/**
		 * 渲染指定单元格
		 */		
		public function renderCell(column:Column, rowIndex:int, row:Row, label:String):void
		{
			cellUI.setTxt(label);
			drawAndSaveCell(column, rowIndex, row);
		}
		
		/**
		 * 绘制并保存单元格数据
		 */		
		public function drawAndSaveCell(column:Column, rowIndex:int, row:Row):void
		{
			var bmd:BitmapData = BitmapUtil.drawBitData(this.cellUI);
			var shape:Shape = column.saveCellData(cellUI.label, rowIndex);
			
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(bmd);
			shape.graphics.drawRect(0, 0, bmd.width, bmd.height);
			
			shape.x = column.x;
			shape.y = row.y;
			
			this.textCanvas.addChild(shape);
		}
		
		/**
		 */		
        private function keyDownHandler(event:KeyboardEvent):void
        {
            if (this.currentRow == null || currentColumn == null)
                return;
			
            switch(event.keyCode)
            {
                case Keyboard.ENTER:
                {
					downCell();
                    break;
                }
				case Keyboard.DOWN:
				{
					downCell();
					break;
				}
                case Keyboard.DELETE:
                {
                    this.clearCell();
                    break;
                }
                case Keyboard.RIGHT:
                {
                    this.newColumnIndex += 1;
                    if (this.newColumnIndex >= this.columns.length)
                        this.newColumnIndex = this.columns.length - 1;
					
                    this.swtichCell();
                    break;
                }
                case Keyboard.LEFT:
                {
                    this.newColumnIndex -= 1;
					
                    if (this.newColumnIndex < 0)
                        this.newColumnIndex = 0;
					
                    this.swtichCell();
					
                    break;
                }
                case Keyboard.UP:
                {
                    this.newRowIndex -= 1;
					
					if (newRowIndex < 0)
						newRowIndex = 0;
					
                    this.swtichCell();
					
                    break;
                }
                default:
                {
                    if (this.cellUI.visible == false)
                    {
						this.readyToTex();
						this.cellUI.setTxtAndHover();
                    }
					
                    break;
                }
            }
			
        }
		
		/**
		 */		
		private function downCell():void
		{
			this.newRowIndex += 1;
			if (this.newRowIndex >= rows.length)
				newRowIndex = rows.length - 1;
			
			this.swtichCell();
		}

		/**
		 */		
        private function clearCell():void
        {
			var cell:CellData = cellData;
			
			cell.label = "";
			cell.shape.graphics.clear();
			cellUI.setTxtAndHover();
        }

		/**
		 */		
        private function readyToTex() : void
        {
            var shape:Shape = this.cellData.shape;
			
            if (this.textCanvas.contains(shape))
            {
                shape.graphics.clear();
                this.textCanvas.removeChild(shape);
            }
			
			if (this.currentColumn.ifNumContents)
				cellUI.restrictNum();
			else
				cellUI.notRestrict();
			
			
            this.cellUI.beforTex();
        }
    }
}
