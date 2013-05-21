package com.dataGrid 
{
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.greensock.TweenLite;
	
	import edit.chart.ChartProxy;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
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
		private var textFrame:Shape = new Shape;
		
		/**
		 */		
		private var cellUI:CellUI = new CellUI;

		/**
		 */		
        public function EditCanvas()
        {
            this.addChild(this.textCanvas);
			addChild(labelLayer);
			
			labelLayer.mouseEnabled = false;
			labelLayer.addChild(textBG);
			labelLayer.addChild(curTextCanvas);
			
			labelLayer.addChild(this.cellUI);
			
			labelLayer.addChild(textFrame);
			
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }
		
		/**
		 */		
		private var labelLayer:Sprite = new Sprite;
		
		/**
		 */		
		private var curTextCanvas:Shape = new Shape;
		
		/**
		 */		
		private var textBG:Shape = new Shape;

		/**
		 */		
        private function init(event:Event):void
        {
			// 绘制这个是为了双击进入文本编辑无干扰，否则第一次双击摸个单元格时不生效
			textCanvas.graphics.clear();
			textCanvas.graphics.beginFill(0, 0);
			textCanvas.graphics.drawRect(0, 0, w, h);
			
			this.textCanvas.mouseEnabled = textCanvas.mouseChildren = false;
			
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.downHandler, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 0, true);
			
            this.doubleClickEnabled = true;
            this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleHandler, false, 0, true);
			
			this.addEventListener(Event.CHANGE, textInputHandler, false, 0, true);
        }
		
		/**
		 * 文本输入的工程中文本框动态绘制
		 */		
		private function textInputHandler(evt:Event):void
		{
			drawTexOnSelect(true);
		}
		
		/**
		 */		
		public var ifActivation:Boolean = false;

		/**
		 */		
        private function doubleHandler(event:Event):void
        {
			if (ifActivation)
			{
				this.readyToTex();
				this.cellUI.setTxtAndHover(this.cellData.label);
				
				drawTexOnSelect(true);
			}
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
			if (ifActivation)
			{
				// 当前选中的是正在编辑的文本框，此时不切换
				if (event.target is TextField  && cellUI.visible == true)
					return;
				
				this.findNewCell();
				
				if (this.ifNewCell)
					this.swtichCell();
			}
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
			
			cellUI.setTextFormat(currentColumn.textFormat);
            this.cellUI.setTxt(this.currentColumn.getCellData(this.currentRowIndex).label);
			this.cellUI.moveTo(getCellX(currentColumn), getCellY(currentRow), this.currentColumn.width, this.currentRow.height);
			
			drawTexOnSelect(true, true);
        }
		
		/**
		 */		
		private function getCellX(column:Column):Number
		{
			return column.x + 2;
		}
		
		/**
		 */		
		private function getCellY(row:Row):Number
		{
			return row.y + (row.height - cellUI.fieldHeight) / 2;
		}
		
		/**
		 * 绘制当前选中的单元格内容
		 */		
		private function drawTexOnSelect(ifCheck:Boolean = false, ifDrawText:Boolean = false):void
		{
			textFrame.graphics.clear();
			textFrame.graphics.lineStyle(2, 0x4EA6EA, 1);
			
			var w:Number = currentColumn.width;
			
			if (ifCheck && w < cellUI.width)
				w = cellUI.width;
			
			textFrame.graphics.drawRect(this.currentColumn.x, this.currentRow.y, w, this.currentRow.height);
			textFrame.graphics.endFill();
			
			textBG.graphics.clear();
			textBG.graphics.beginFill(0xFFFFFF);
			textBG.graphics.drawRect(this.currentColumn.x, this.currentRow.y, w, this.currentRow.height);
			textBG.graphics.endFill();
			
			curTextCanvas.graphics.clear();
			
			if (ifDrawText)
			{
				var bmd:BitmapData = cellUI.getBmd();
				BitmapUtil.drawBitmapDataToShape(bmd, curTextCanvas, bmd.width, bmd.height, 
					getCellX(currentColumn), getCellY(currentRow), false);
			}
			
			TweenLite.killTweensOf(textFrame, true);
			TweenLite.from(textFrame, 0.3, {alpha: 0.5});
		}
		
		/**
		 * 当点击非表格区域时，取消当前单元格选择
		 */		
		public function unSelectCell():void
		{
			textFrame.graphics.clear();
			textBG.graphics.clear();
			curTextCanvas.graphics.clear();
			
			this.cellUI.leave();
			this.drawCurCell();
			
			currentColumn = null;
			currentRow = null;
			currentColumnIndex = currentRowIndex = - 1;
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
			cellUI.setTextFormat(column.textFormat);
			cellUI.setTxt(label);
			drawAndSaveCell(column, rowIndex, row);
		}
		
		/**
		 * 绘制并保存单元格数据
		 */		
		public function drawAndSaveCell(column:Column, rowIndex:int, row:Row):void
		{
			var bmd:BitmapData = cellUI.getBmd();
			var shape:Shape = column.saveCellData(cellUI.label, rowIndex);
			
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(bmd, null, false);
			shape.graphics.drawRect(0, 0, column.width - 5, row.height);
			
			currentColumn = column;
			shape.x = getCellX(column);
			shape.y = getCellY(row);
			
			this.textCanvas.addChild(shape);
			
			vertifyCellData(ifNeedVerify(column), column.getCellData(rowIndex));
		}
		
		/**
		 * 以行为依据，验证此行内输入数据时是否合理，不合理的
		 * 
		 * 数据会被标示出
		 */		
		public function vertifyCellData(ifNeedVerify:Boolean, curData:CellData):void
		{
			if (curData)
			{
				if (ifNeedVerify)
				{
					if (RexUtil.ifHasNumValue(curData.label))
					{
						curData.shape.filters = null;
						curData.ifVerified = true;
					}
					else
					{
						curData.shape.filters = [new GlowFilter(0xFF0000, 1, 2, 2, 2, 3, true)];
						curData.ifVerified = false;
					}
				}
				else
				{
					curData.ifVerified = true;
				}
			}
			
		}
		
		/**
		 * 指定的序列是否需要被验证数据
		 */		
		public function ifNeedVerify(column:Column):Boolean
		{
			if (column.dataType == ChartProxy.LINEAR)
				return true;
			else
				return false;
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
				case Keyboard.TAB:
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
			
			// 行不够了，需要再增添, 一次增添一行，总行数
			// 暂时不做限制
			if (this.newRowIndex >= rows.length)
			{
				//最大高度限制
				if (this.height >= maxHeight)
				{
					newRowIndex = rows.length;
					return;
				}
				
				this.dispatchEvent(new DataGridEvent(DataGridEvent.ADD_ROW));
				this.swtichCell();
			}
			else
			{
				this.swtichCell();
			}
		}
		
		/**
		 */		
		public var maxHeight:uint = 2000;

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
		 * 文本进入编辑状态
		 */		
        private function readyToTex() : void
        {
            var shape:Shape = this.cellData.shape;
			
            if (this.textCanvas.contains(shape))
            {
                shape.graphics.clear();
                this.textCanvas.removeChild(shape);
            }
			
			cellUI.setTextFormat(this.currentColumn.textFormat);
            this.cellUI.beforTex();
        }
		
		/**
		 * 再刷新表格数据时，可能当前单元格处于选中状态
		 * 
		 * 背景可视，要先将其背景隐藏
		 */		
		public function hideCellUI():void
		{
			cellUI.leave();
		}
    }
}
