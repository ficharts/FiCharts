package edit
{
	import com.dataGrid.Column;
	import com.fiCharts.utils.RexUtil;

	/**
	 * 每个序列映射两列表格数据，位置与index有关
	 */	
	public class SeriesHead
	{
		public function SeriesHead()
		{
		}
		
		/**
		 */		
		public function ifNumberContents(type:String):Boolean
		{
			if (type == "field")
				return false;
			
			return true;
		}
			
		/**
		 */		
		public var xDataType:String;
		
		/**
		 */		
		public var yDataType:String;
		
		/**
		 */		
		public function getData():Array
		{
			var result:Array = [];
			var dataItem:Object;
			
			var xColumn:Column = columns[0];
			var yColumn:Column = columns[1];
			
			
			var xLen:uint = xColumn.rowLen;
			var yLen:uint = yColumn.rowLen;
			
			var len:uint = Math.min(xLen, yLen);
			var xValue:String, yValue:String;
			
			for (var i:uint = 0; i < len; i ++)
			{
				if (xColumn.data[i] == null || yColumn.data[i] == null)
					continue;
					
				xValue = xColumn.data[i].label;
				yValue = yColumn.data[i].label;
				
				if (!RexUtil.ifTextNull(xValue) && !RexUtil.ifTextNull(yValue))
				{
					dataItem = {};
					dataItem[outXField] = xValue;
					dataItem[outYField] = yValue;
					result.push(dataItem);
				}
			}
			
			return result;
		}
		
		/**
		 *  
		 */		
		public function getXML():XML
		{
			return <{this.type} xField={outXField} yField={outYField} name={name}/>
		}
		
		/**
		 */		
		public function get outXField():String
		{
			return this.xField + this.index;
		}
		
		/**
		 */		
		public function get outYField():String
		{
			return this.yField + index;
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
		public function get index():uint
		{
			return _index;
		}

		/**
		 * @private
		 */
		public function set index(value:uint):void
		{
			_index = value;
		}

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
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
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
		 * 将序列的地段信息分配到数据列上，进而
		 * 
		 * 生成列数据
		 */		
		public function setColumnDataField():void
		{
			var xColumn:Column = columns[0];
			var yColumn:Column = columns[1];
			
			xColumn.dataField = this.xField;
			yColumn.dataField = this.yField;
			
			xColumn.ifNumContents = ifNumberContents(this.xDataType);
			yColumn.ifNumContents = ifNumberContents(this.yDataType);
		}

	}
}