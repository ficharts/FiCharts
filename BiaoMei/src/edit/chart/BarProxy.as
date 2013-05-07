package edit.chart
{
	import com.dataGrid.Column;
	import com.fiCharts.utils.RexUtil;
	
	import edit.EditPage;

	/**
	 */	
	public class BarProxy extends SeriesProxy
	{
		public function BarProxy()
		{
			super();
		}
		
		/**
		 * 将指定行的数据字段赋给统一对象
		 */		
		override public function upPutDataItem(item:Object, i:uint):void
		{
			var xColumn:Column = columns[1];
			var yColumn:Column = columns[0];
			
			if (i < xColumn.rowLen && i < yColumn.rowLen)
			{
				if (xColumn.data[i] == null || yColumn.data[i] == null)
					return;
				
				var xValue:String, yValue:String;
				
				xValue = xColumn.data[i].label;
				yValue = yColumn.data[i].label;
				
				if (!RexUtil.ifTextNull(xValue) && !RexUtil.ifTextNull(yValue))
				{
					if (xColumn.data[i].ifVerified) // 
					{
						item[this.xField] = filterNumValue(xValue);
						item[this.yField] = yValue;
					}
				}
			}
		}
		
		/**
		 */		
		override public function verifyFieldData(verifyFun:Function):void
		{
			verifyFun(this.startColumnIndex);
		}
		
		/**
		 */		
		override public function getDataLen():uint
		{
			return this.columns[0].rowLen;
		}
		
		/**
		 */		
		override public function setFieldsByXML(sXML:XML):void
		{
			xField = sXML.@xField;
			yField = sXML.@yField
			
			setColumnDataField();
		}
		
		/**
		 * 根据序列类型和字段列序号动态组合出字段
		 */		
		override public function setField(type:String, startIndex:uint, endIndex:uint):void
		{
			xField = type + startIndex;
			yField = ChartProxy.SHARE_FIELD;
			
			setColumnDataField();
		}
		
		/**
		 */		
		override protected function setColumnDataField():void
		{
			var xColumn:Column = columns[1];
			var yColumn:Column = columns[0];
			
			xColumn.dataField = this.xField;
			yColumn.dataField = this.yField;
			
			xColumn.dataType = ChartProxy.LINEAR;
			yColumn.dataType = ChartProxy.FIELD;
		}
		
	}
}