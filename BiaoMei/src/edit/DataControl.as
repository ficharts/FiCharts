package edit
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import edit.chart.SeriesProxy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;

	public class DataControl
	{
		/**
		 */		
		public function DataControl(page:EditPage)
		{
			this.page = page;
			
			file.addEventListener(Event.SELECT, selectedFile, false, 0, true);
			file.addEventListener(Event.COMPLETE, importDataComplete, false, 0, true);
		}
		
		
		
		
		
		//----------------------------------------------
		//
		//
		//  模板导入
		//
		//
		//----------------------------------------------
		
		/**
		 * 更新表格和图表配置数据;
		 */		
		internal function importChartDataTemplate():void
		{
			var curData:Array = [];
			var vo:Object;
			for each (var item:XML in page.configXML.data.children())
			{
				vo = new Object();
				XMLVOMapper.pushAppedXMLDataToVO(item, vo);
				curData.push(vo);
			}
			
			// 删除模板文件的数据节点，只用到配置部分；数据采用表格中的 
			delete page.configXML.data;
			
			page.dataGrid.data = curData;
			page.dataGrid.render();
			
			page.chartProxy.resetDataFields();
		}
		
		/**
		 * 保留表格数据，仅刷新图表配置
		 */		
		internal function importChartConfigTemplate():void
		{
			page.chartProxy.reset();
			page.chartProxy.setConfig(page.configXML);
			
			createSeriesByTemplate();
			
			page.resetTitles();
			page.upateTitlesData();
		}
		
		/**
		 * 根据模板创建并分配序列
		 * 
		 * 数据输入按照配置数据映射，输出时进行数据分组，并重新分配
		 * 
		 * 序列的数据字段
		 */		
		private function createSeriesByTemplate():void
		{
			var startColumnFieldIndex:uint = 1;
			var endColumnFileIndex:uint;
			
			var seriesColumnLen:uint;
			var series:SeriesProxy;
			var type:String;
			
			for each (var sXML:XML in page.configXML.series.children())
			{
				type = sXML.name().toString()
				series = page.chartProxy.getSeriesByType(type);
				
				seriesColumnLen = page.chartProxy.getColumnLenByChartType(type);
				endColumnFileIndex = startColumnFieldIndex + seriesColumnLen - 1;
				
				page.setSeriesColumns(series, startColumnFieldIndex, endColumnFileIndex);
				series.setFieldsByXML(sXML);
				page.chartProxy.addSeries(series);
				
				startColumnFieldIndex = endColumnFileIndex + 1;
			}
		}
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		//  数据导出
		//
		//
		//----------------------------------------------
		
		
		
		
		
		//----------------------------------------------
		//
		//
		//  数据导入
		//
		//
		//----------------------------------------------
		
		/**
		 */		
		internal function browseFileHandler(evt:MouseEvent):void
		{
			file.browse();
		}
		
		/**
		 */		
		private function selectedFile(evt:Event):void
		{
			file.load();
		}
		
		/**
		 */		
		private function importDataComplete(evt:Event):void
		{
			page.configXML = XML(file.data.toString());
			
			page.dataGrid.clear();
			page.chartProxy.reset();
			page.chartProxy.setConfig(page.configXML);
			page.upateTitlesData();
			
			if (page.configXML.hasOwnProperty("series") && page.configXML.series.children().length())
			{
				var newSeries:SeriesProxy;
				var type:String;
				for each (var item:XML in page.configXML.series.children())
				{
					type = item.name();
					newSeries = page.chartProxy.getSeriesByType(type);
					page.setSeriesColumns(newSeries, item.@startIndex, item.@endIndex);
					newSeries.setField();
					page.chartProxy.addSeries(newSeries);		
					newSeries.reName(item.@name);
				}
			}
		}
		
		/**
		 */		
		private var file:FileReference = new FileReference;
		
		/**
		 */		
		private  var page:EditPage;
	}
}