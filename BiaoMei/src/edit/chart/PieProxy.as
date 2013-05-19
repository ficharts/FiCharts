package edit.chart
{
	public class PieProxy extends SeriesProxy
	{
		public function PieProxy()
		{
			super();
		}
		
		/**
		 */		
		override public function getXML():XML
		{
			return <{this.type} labelField={this.xField} valueField={this.yField} name={name}/>
		}
	}
}