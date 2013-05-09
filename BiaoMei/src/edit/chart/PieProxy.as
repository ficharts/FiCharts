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
		override protected function initLabelField():void
		{
			
		}
		
		/**
		 */		
		override public function renderNameField():void
		{
		}
		
		/**
		 */		
		override public function getXML():XML
		{
			return <{this.type} labelField={this.xField} valueField={this.yField} name={name}/>
		}
	}
}