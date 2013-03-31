package 
{
	import com.dataGrid.DataGrid;
	import com.fiCharts.utils.StageUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 */	
	public class SChart extends Sprite
	{
		private var dataGrid:DataGrid;
		
		/**
		 */		
		public function SChart()
		{
			this.dataGrid = new DataGrid();
			StageUtil.initApplication(this, this.init);
		}
		
		/**
		 */		
		private var chart:Chart2D = new Chart2D;
		
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
		private function init() : void
		{
			addChild(dataGrid);
			
			dataGrid.preRender();
			setSeriesHeads();
			
			var arr:Array = [{label:"无敌", value:253},
							{label:"B", value:236},
							{label:"无c", value:325},
							{label:"无f", value:11},
							{label:"无e", value:896},
							{label:"无", value:36},
							{label:"无g", value:78},
							{label:"无h", value:625},
							{label:"无i", value:82},
							{label:"无j", value:333},
							{label:"无k", value:653},
							{label:"无l", value:258},]
			
				
			dataGrid.data = arr;
			dataGrid.render();
			
			chart.x = 200;
			chart.width = 800;
			chart.height = 500;
			this.addChild(chart);
			
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, rollOutHandler, false, 0, true);
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
		 */			
		private var series:Vector.<SeriesHead> = new Vector.<SeriesHead>;
		
		/**
		 */		
		private function rollOutHandler(evt:MouseEvent):void
		{
			chart.setConfigXML(getSeriesConfig().toString());
			chart.setDataArry(getChartData());
			chart.render();
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
