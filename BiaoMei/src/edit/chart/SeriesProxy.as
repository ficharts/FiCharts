package edit.chart
{
	import com.dataGrid.CellData;
	import com.dataGrid.Column;
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.greensock.TweenLite;
	
	import edit.IconBtn;
	import edit.chartTypeBox.ChartTypePanel;
	
	import fl.motion.easing.Back;
	import fl.transitions.easing.Bounce;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 每个序列默认映射两列表格数据，位置与index有关
	 * 
	 * 气泡图等特殊图表类型映射更多列数据， 序列头决定了
	 * 
	 * 图表类型及其属性
	 */	
	public class SeriesProxy extends Sprite
	{
		public function SeriesProxy()
		{
			blueDel;
		}
		
		/**
		 */		
		public function shake():void
		{
			TweenLite.from(headerHolder, 0.5, {y: this.headHeight / 2 - 5, ease: Bounce.easeIn});
		}
		
		/**
		 */		
		public function del():void
		{
			this.mouseChildren = this.mouseEnabled = false;
			
			TweenLite.to(headerHolder, 0.5, {alpha: 0, scaleX: 0, scaleY: 0, onComplete: _del});
		}
		
		/**
		 * 验证数据列的数据有效性，用于表格先有数据，
		 * 
		 * 添加/改变序列时验证数据的有效性
		 */		
		public function verifyFieldData(verifyFun:Function):void
		{
			verifyFun(this.startColumnIndex);
		}
		
		/**
		 * 将指定行的数据字段赋给统一对象
		 */		
		public function upPutDataItem(item:Object, i:uint):void
		{
			var xColumn:Column = columns[0];
			var yColumn:Column = columns[1];
			
			if (i < xColumn.rowLen && i < yColumn.rowLen)
			{
				if (xColumn.data[i] == null || yColumn.data[i] == null)
					return;
				
				var xValue:String, yValue:String;
				
				xValue = xColumn.data[i].label;
				yValue = yColumn.data[i].label;
				
				if (!RexUtil.ifTextNull(xValue) && !RexUtil.ifTextNull(yValue))
				{
					if (yColumn.data[i].ifVerified) // 
					{
						item[this.xField] = xValue;
						item[this.yField] = filterNumValue(yValue);
					}
				}
			}
		}
		
		/**
		 * 获得序列的数据节点数，通常xField列数据
		 */		
		public function getDataLen():uint
		{
			return this.columns[0].rowLen;
		}
		
		/**
		 * 根据来自模版的XML文件设置序列的字段
		 */		
		public function setFieldsByXML(sXML:XML):void
		{
			xField = sXML.@xField;
			yField = sXML.@yField;
			
			setColumnDataField();
		}
		
		/**
		 * 根据序列类型和字段列序号动态组合出字段
		 */		
		public function setField(type:String, startIndex:uint, endIndex:uint):void
		{
			xField = ChartProxy.SHARE_FIELD;
			yField = type + startIndex;
			
			setColumnDataField();
		}
		
		/**
		 */		
		protected function setColumnDataField():void
		{
			var xColumn:Column = columns[0];
			var yColumn:Column = columns[1];
			
			xColumn.dataField = this.xField;
			yColumn.dataField = this.yField;
			
			xColumn.dataType = ChartProxy.FIELD;
			yColumn.dataType = ChartProxy.LINEAR;
		}
		
		/**
		 */		
		public function get zField():String
		{
			return _zField;
		}

		public function set zField(value:String):void
		{
			_zField = value;
		}
		
		/**
		 */		
		public function render():void
		{
			this.x = this.getX();
			this.y = this.getY();

			// 这样做是为了实现动画效果时从中心点开始
			//--------------------------------------
			this.addChild(headerHolder);
			headerHolder.addChild(header);
			
			var tx:Number = headWidth / 2;
			var ty:Number = headHeight / 2;
			
			headerHolder.x = tx;
			headerHolder.y = ty;
			
			header.x = - tx;
			header.y = - ty;
			
			//---------------------------------------
			
			header.graphics.clear();
			header.graphics.beginFill(0x2494E6, 0.8);
			header.graphics.drawRect(1, headHeight - 3,  headWidth - 2, 3);
			header.graphics.endFill();
			
			header.graphics.beginFill(0xDDDDDD, 0.2);
			header.graphics.drawRect(1, 0, headWidth - 2, this.headHeight);
			header.graphics.endFill();
			
			delBtn.x = (headWidth - this.chartSize) / 2;
			delBtn.y = (headHeight - this.chartSize) / 2;
			delBtn.init(ChartTypePanel.getChartBitmapByType(type), 'blueDel', 'blueDel', 20, 20);
			delBtn.addEventListener(MouseEvent.CLICK, deleteThisHandler, false, 0, true);
			delBtn.render();
			header.addChild(delBtn);
			
			TweenLite.from(headerHolder, 0.5, {alpha: 0, scaleX:0, scaleY:0, ease: Back.easeOut});
		}
		
		/**
		 */		
		private var header:Sprite = new Sprite;
		
		/**
		 */		
		private var headerHolder:Sprite = new Sprite;
		
		/**
		 */		
		private function deleteThisHandler(evt:MouseEvent):void
		{
			this.del();
		}
		
		/**
		 */		
		private function _del():void
		{
			var seriesDelEvt:ChartEvent = new ChartEvent(ChartEvent.DELETE_SERIES);
			seriesDelEvt.seriesItem = this;
			
			this.dispatchEvent(seriesDelEvt);
		}
		
		/**
		 */		
		private var delBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		public var startColumnIndex:uint = 0;
		
		/**
		 */		
		public var endColumnIndex:uint = 0;
		
		/**
		 */		
		private function getX():Number
		{
			return this.columns[1].x;
		}
		
		/**
		 */		
		private function getY():Number
		{
			return - headHeight;
		}
		
		/**
		 */		
		private function get chartSize():uint
		{
			return 20;
		}
		
		
		/**
		 */		
		private function get headHeight():Number
		{
			return 35;
		}
		
		/**
		 */		
		private function get headWidth():Number
		{
			var lastColumn:Column = columns[columns.length - 1];
			
			return lastColumn.x + lastColumn.width - getX();
		}
		
		/**
		 * 计算出序列的浅醉后缀
		 */		
		public function checkPrefixAndSuffix():void
		{
			var yColumn:Column = columns[1];
			for each (var item:CellData in yColumn.data)
			{
				if (item && item.ifVerified)
				{
					var formatter:Array = item.label.split(item.label.match(/-?\d+\.?\d*/g)[0]);
					
					if (formatter.length == 2)
					{
						yPreffix = formatter[0];
						ySuffix = formatter[1];
					}
					else
					{
						if (item.label.indexOf(formatter[0]) == 0)
							yPreffix = formatter[0];
						else
							ySuffix = formatter[0];
					}
					
					break;
				}
			}
		}
		
		/**
		 * Y值前缀
		 */		
		public var yPreffix:String = '';
		
		/**
		 * Y值后缀
		 */		
		public var ySuffix:String = '';
		
		/**
		 * 将字符串中属于数字类型的值剥离出来 
		 */		
		protected function filterNumValue(value:String):String
		{
			var result:String;
			
			if (RexUtil.ifHasNumValue(value))
			{
				return value.match(/-?\d+\.?\d*/g)[0]
			}
			else
			{
				return value;
			}
			
			return result;
		}
		
		/**
		 */		
		public function getXML():XML
		{
			return <{this.type} xField={this.xField} yField={this.yField} name={name}/>
		}
		
		/**
		 * 序列序号 
		 */		
		private var _index:uint = 0;
		
		/**
		 * 序列类型
		 */		
		private var _type:String;
		
		/**
		 */		
		private var _xField:String;
		
		/**
		 */		
		private var _yField:String;
		
		/**
		 */		
		private var _name:String = '';
		
		/**
		 */		
		private var _columns:Vector.<Column> = new Vector.<Column>;

		/**
		 */		
		public function get type():String
		{
			return _type;
		}

		/**
		 */		
		public function set type(value:String):void
		{
			_type = value;
		}

		/**
		 * 
		 */
		public function get xField():String
		{
			return _xField;
		}

		/**
		 * @private
		 */
		public function set xField(value:String):void
		{
			_xField = value;
		}

		public function get yField():String
		{
			return _yField;
		}

		public function set yField(value:String):void
		{
			_yField = value;
		}
		
		/**
		 */		
		private var _zField:String;

		/**
		 */
		override public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		override public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 第一列是共有列
		 */
		public function get columns():Vector.<Column>
		{
			return _columns;
		}

		/**
		 * @private
		 */
		public function set columns(value:Vector.<Column>):void
		{
			_columns = value;
		}
		
		/**
		 */		
		public function clear():void
		{
			this.columns.length = 0;	
		}

	}
}