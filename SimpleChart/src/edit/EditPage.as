package edit
{
	import com.dataGrid.DataGrid;
	
	import flash.display.Sprite;
	
	/**
	 * 图表数据和配置编辑页
	 */	
	public class EditPage extends Sprite implements IPage
	{
		public function EditPage(main:SimpleChart)
		{
			super();
			
			addChild(dataGrid);
			this.main = main;
		}
		
		/**
		 */		
		private var main:SimpleChart;
		
		/**
		 */		
		public function createNewChart(tem:XML):void
		{
			var data:Array = [];
			
			dataGrid.data = data;
			dataGrid.render();
		}
		
		/**
		 */		
		public function changeChart(tem:XML):void
		{
			
		}
		
		/**
		 */		
		public function prePage():void
		{
			
		}
		
		/**
		 */		
		public function nextPage():void
		{
			
		}
		
		/**
		 * 创建并分配序列头
		 * 
		 * 数据输入按照配置数据映射，输出时进行数据分组，并重新分配
		 * 
		 * 序列的数据字段
		 */		
		private function setSeriesHeads():void
		{
			var series:SeriesHead;
			var index:uint = 0;
			
			for each (var sXML:XML in configXML.series.children())
			{
				series = new SeriesHead;
				series.type = sXML.name().toString();
				
				series.xField = sXML.@xField;
				series.yField = sXML.@yField;
				
				series.xDataType = this.xAxisType;
				series.yDataType = this.yAxisType;
				
				series.index = index;
				series.columns = this.dataGrid.columns.slice(index * 2, (index + 1) * 2);
				series.setColumnDataField();
				this.series.push(series);
			}
		}
		
		
		/**
		 * 动态获取图表的配置文件
		 */		
		private function getSeriesConfig():XML
		{
			var result:XML = configXML.copy();
			result.series = <series/>
			
			for each (var seriesH:SeriesHead in this.series)
			result.series.appendChild(seriesH.getXML());
			
			return result;
		}
		
		/**
		 * 动态获取图表的数据
		 */		
		private function getChartData():Array
		{
			var result:Array = [];
			
			for each (var seriesH:SeriesHead in this.series)
				result = result.concat(seriesH.getData());
			
			return result;
		}
		
		/**
		 */		
		private function init() : void
		{
			dataGrid.preRender();
			setSeriesHeads();
		}
		
		/**
		 */			
		private var series:Vector.<SeriesHead> = new Vector.<SeriesHead>;
		
		/**
		 */		
		private function get xAxisType():String
		{
			return configXML.axis.x.@type;
		}
		
		/**
		 */		
		private function get yAxisType():String
		{
			return configXML.axis.y.@type;
		}
		
		/**
		 */		
		private var dataGrid:DataGrid = new DataGrid;
		
		
		/**
		 * 表格宽度
		 */		
		private var _gridW:Number = 0;
		
		/**
		 * 表格高度
		 */		
		private var _girdH:Number = 0;
		
		/**
		 */
		public function get girdH():Number
		{
			return _girdH;
		}
		
		/**
		 * @private
		 */
		public function set girdH(value:Number):void
		{
			_girdH = value;
		}
		
		/**
		 */
		public function get gridW():Number
		{
			return _gridW;
		}
		
		/**
		 * @private
		 */
		public function set gridW(value:Number):void
		{
			_gridW = value;
		}
		
		/**
		 */		
		private var configXML:XML = <config title='2010年度销售状况' ySuffix="万" subTitle='呈上升趋势'>
										<axis>
											<x type="field" title="月份"/>
											<y type="linear" title="销售额"/>
										</axis>
										<series>
											<line xField='label' yField='value' labelDisplay='normal'/>
										</series>
									</config>
	}
}