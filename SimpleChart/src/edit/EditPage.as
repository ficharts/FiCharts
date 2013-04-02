package edit
{
	import com.dataGrid.DataGrid;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 图表数据和配置编辑页
	 */	
	public class EditPage extends PageBase
	{
		public function EditPage(main:SimpleChart)
		{
			super();
			
			addChild(dataGrid);
			this.main = main;
			
			dataGrid.preRender();
		}
		
		/**
		 */		
		private function toReview(evt:MouseEvent):void
		{
			main.toChartPage(this.getSeriesConfig(), this.getChartData());
		}
		
		/**
		 */		
		private var main:SimpleChart;
		
		/**
		 */		
		public function createNewChart(config:XML):void
		{
			configXML = config; 
			
			var data:Array = [];
			var vo:Object;
			
			for each (var item:XML in configXML.data.children())
			{
				vo = new Object();
				XMLVOMapper.pushAppedXMLDataToVO(item, vo);
				data.push(vo);
			}
			
			delete configXML.data;
			
			creatSeriesHeads();
			dataGrid.data = data;
			dataGrid.render();
		}
		
		/**
		 */		
		public function changeChart(config:XML):void
		{
			
		}
		
		
		/**
		 * 创建并分配序列头
		 * 
		 * 数据输入按照配置数据映射，输出时进行数据分组，并重新分配
		 * 
		 * 序列的数据字段
		 */		
		private function creatSeriesHeads():void
		{
			var series:SeriesHead;
			var index:uint = 0;
			
			seriesHeads.length = 0;
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
				this.seriesHeads.push(series);
			}
		}
		
		/**
		 * 动态获取图表的配置文件
		 */		
		private function getSeriesConfig():XML
		{
			var result:XML = configXML.copy();
			result.series = <series/>
			
			for each (var seriesH:SeriesHead in this.seriesHeads)
				result.series.appendChild(seriesH.getXML());
			
			return result;
		}
		
		/**
		 * 动态获取图表的数据
		 */		
		private function getChartData():Array
		{
			var result:Array = [];
			
			for each (var seriesH:SeriesHead in this.seriesHeads)
				result = result.concat(seriesH.getData());
			
			return result;
		}
		
		/**
		 */			
		private var seriesHeads:Vector.<SeriesHead> = new Vector.<SeriesHead>;
		
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
		private var configXML:XML;
	}
}