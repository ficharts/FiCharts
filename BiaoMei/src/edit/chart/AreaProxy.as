package edit.chart
{
	public class AreaProxy extends SeriesProxy
	{
		public function AreaProxy()
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