package edit.chart
{
	public class PieProxy extends SeriesProxy
	{
		public function PieProxy()
		{
			super();
		}
		
		/**
		 * 根据来自模版的XML文件设置序列的字段
		 */		
		override public function setFieldsByXML(sXML:XML):void
		{
			xField = sXML.@xField;
			yField = sXML.@yField;
			this.reName(sXML.@name);
			
			setColumnDataField();
		}
		
		
		/**
		 * 根据序列类型和字段列序号动态组合出字段
		 */		
		override public function setField(type:String, startIndex:uint, endIndex:uint):void
		{
			xField = ChartProxy.SHARE_FIELD;
			yField = type + startIndex;
			
			//this.name = "序列" + this.startColumnIndex;
			
			setColumnDataField();
		}
		
		/**
		 */		
		override public function getXML():XML
		{
			return <{this.type} labelField={this.xField} valueField={this.yField} name={name}/>
		}
	}
}