package com.biaomei.edit.chart
{
	/**
	 */	
	public class LineProxy extends SeriesProxy
	{
		public function LineProxy()
		{
			super();
		}
		
		/**
		 */		
		override public function getXML():XML
		{
			return <{this.type} xField={this.xField} yField={this.yField} name={name} labelDisplay='normal'/>
		}
	}
}