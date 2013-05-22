package edit.chart
{
	import com.dataGrid.Column;
	import com.fiCharts.utils.RexUtil;
	
	import edit.EditPage;
	
	import flash.globalization.Collator;

	/**
	 */	
	public class BubbleProxy extends SeriesProxy
	{
		public function BubbleProxy()
		{
			super();
		}
		
		/**
		 * 将指定行的数据字段赋给统一对象
		 */		
		override public function upPutDataItem(item:Object, i:uint):void
		{
			var xColumn:Column = columns[0];
			var yColumn:Column = columns[1];
			var zColumn:Column = columns[2];
			
			if (i < xColumn.rowLen && i < yColumn.rowLen && i < zColumn.rowLen)
			{
				if (xColumn.data[i] == null || yColumn.data[i] == null || zColumn.data[i] == null)
					return;
				
				var xValue:String, yValue:String, zValue:String;
				
				xValue = xColumn.data[i].label;
				yValue = yColumn.data[i].label;
				zValue = zColumn.data[i].label;
				
				if (!RexUtil.ifTextNull(xValue) && !RexUtil.ifTextNull(yValue) && !RexUtil.ifTextNull(zValue))
				{
					if (yColumn.data[i].ifVerified && zColumn.data[i].ifVerified) // 
					{
						item[this.xField] = xValue;
						item[this.yField] = filterNumValue(yValue);
						item[this.zField] = filterNumValue(zValue);
					}
				}
			}
		}
		
		
		/**
		 */		
		override public function verifyFieldData(verifyFun:Function):void
		{
			verifyFun(this.startColumnIndex);
			verifyFun(this.endColumnIndex);
		}
		
		/**
		 */		
		override public function setFieldsByXML(sXML:XML):void
		{
			xField = sXML.@xField
			yField = sXML.@yField;
			zField = sXML.@zField;
			
			this.reName(sXML.@name)
			
			setColumnDataField();
		}
		
		/**
		 * 根据序列类型和字段列序号动态组合出字段
		 */		
		override public function setField(type:String, startIndex:uint, endIndex:uint):void
		{
			xField = ChartProxy.SHARE_FIELD;
			yField = type + startIndex;
			zField = type + endIndex;
			
			//this.name = "序列" + this.startColumnIndex;
			
			setColumnDataField();
		}
		
		/**
		 */		
		override protected function setColumnDataField():void
		{
			var xColumn:Column = columns[0];
			var yColumn:Column = columns[1];
			var zColumn:Column = columns[2];
			
			xColumn.dataField = this.xField;
			yColumn.dataField = this.yField;
			zColumn.dataField = this.zField;
			
			xColumn.dataType = ChartProxy.FIELD;
			yColumn.dataType = ChartProxy.LINEAR;
			zColumn.dataType = ChartProxy.LINEAR;
		}
		
		/**
		 */		
		override public function getXML():XML
		{
			return <{this.type} xField={this.xField} yField={this.yField} zField={this.zField} name={name}/>
		}
	}
}