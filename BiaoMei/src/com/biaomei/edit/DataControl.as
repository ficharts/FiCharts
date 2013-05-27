package com.biaomei.edit
{
	import com.biaomei.edit.chart.SeriesProxy;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

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
		
		/**
		 */		
		private var version:String = '1.0';
		
		/**
		 * 导出图表的配置和数据文件
		 */		
		public function exportData():void
		{
			var resultXML:XML = <bm version={version}/>;
			
			var chartConfigXML:XML = page.chartProxy.exportConfig();
			
			var fields:Array = page.dataGrid.getDataFields();
			var fieldName:String;
			var dataArry:Array = page.dataGrid.data;
			
			var dataXML:XML = <data/>
			var dataItemXML:XML;
			var fieldValue:String;
			for each (var item:Object in dataArry)
			{
				dataItemXML = <item/>
				for each (fieldName in fields)
				{
					fieldValue = item[fieldName];
					if (RexUtil.ifTextNull(fieldValue))
						dataItemXML.@[fieldName] = "";
					else
						dataItemXML.@[fieldName] = fieldValue;
					
				}
				
				dataXML.appendChild(dataItemXML);
			}
			
			resultXML.appendChild(chartConfigXML);
			resultXML.appendChild(dataXML);
			
			//trace(resultXML);
			
			// 保存文件
			var dataByteArray:ByteArray = new ByteArray();
			dataByteArray.writeUTFBytes(resultXML.toXMLString());
			dataByteArray.compress();
			
			var file:FileReference = new FileReference();
			file.save(dataByteArray, getFileName());
		}
		
		/**
		 */		
		private function getFileName():String
		{
			fileNameIndex += 1;
			
			return "biaomei" + fileNameIndex + ".bm";
		}
		
		/**
		 */		
		private var fileNameIndex:uint = 0;
		
		
		
		
		
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
			file.browse([new FileFilter("表魅文件(*.bm)", "*.bm", "bm" )]);
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
			file.data.uncompress();
			
			var fileXML:XML = XML(file.data.toString());
			page.configXML = XML(fileXML.config.toXMLString());
			
			page.dataGrid.clear();
			
			page.dataGrid.clear();
			page.chartProxy.reset();
			page.chartProxy.setConfig(page.configXML);
			page.upateTitlesData();
			
			if (page.configXML && page.configXML.hasOwnProperty("series") && page.configXML.series.children().length())
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
			
			var data:Array = [];
			if (fileXML.hasOwnProperty("data") && fileXML.data.children().length())
			{
				var dataItemVO:Object;
				for each (var dataItem:XML in fileXML.data.children())
				{
					dataItemVO = {};
					XMLVOMapper.pushXMLDataToVO(dataItem, dataItemVO);
					data.push(dataItemVO);
				}
			}
			
			page.dataGrid.data = data;
			page.dataGrid.render();
			
		}
		
		/**
		 */		
		private var file:FileReference = new FileReference;
		
		/**
		 */		
		private  var page:EditPage;
	}
}