package edit.chart
{
	import com.dataGrid.Column;
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.Map;
	import com.fiCharts.utils.RexUtil;
	
	import edit.chartTypeBox.ChartTypePanel;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class ChartProxy extends Sprite
	{
		/**
		 * 组合图表会共享同一个字段列，这个列有着相同的字段名 
		 */		
		public static const SHARE_FIELD:String = "shareField";
		
		/**
		 */		
		public static const LINEAR:String = "linear";
		
		/**
		 */		
		public static const FIELD:String = "field";
		
		/**
		 */		
		public static const DATE:String = "date";
		
		/**
		 */		
		public function ChartProxy()
		{
			// 不同序列的类定义
			LineProxy;
			ColumnProxy;
			PieProxy;
			AreaProxy;
			BarProxy;
			MarkerProxy;
			BubbleProxy;
			StackedColumnProxy;
			StackedBarProxy;
			
			seriesClassMap.put(ChartTypePanel.LINE, "edit.chart.LineProxy");
			seriesClassMap.put(ChartTypePanel.COLUMN, "edit.chart.ColumnProxy");
			seriesClassMap.put(ChartTypePanel.PIE, "edit.chart.PieProxy");
			seriesClassMap.put(ChartTypePanel.AREA, "edit.chart.AreaProxy");
			seriesClassMap.put(ChartTypePanel.BAR, "edit.chart.BarProxy");
			seriesClassMap.put(ChartTypePanel.MARKER, "edit.chart.MarkerProxy");
			seriesClassMap.put(ChartTypePanel.BUBBLE, "edit.chart.BubbleProxy");
			seriesClassMap.put(ChartTypePanel.STACKED_COLUMN, "edit.chart.StackedColumnProxy");
			seriesClassMap.put(ChartTypePanel.STACKED_BAR, "edit.chart.StackedBarProxy");
			
			
			this.addEventListener(ChartEvent.DELETE_SERIES, deleteSeriesHandler, false, 0, true);
		}
		
		/**
		 * 根据序列类型，获得列的默认数
		 */		
		public function getColumnLenByChartType(type:String):uint
		{
			if (type == ChartTypePanel.BUBBLE)
				return 2;
			else
				return 1;
		}
		
		/**
		 * 根据图表类型获取序列对象
		 */		
		public function getSeriesByType(type:String):SeriesProxy
		{
			var chart:SeriesProxy = ClassUtil.getObjectByClassPath(seriesClassMap.getValue(type)) as SeriesProxy;
			chart.type = type;
			
			return chart;
		}
		
		/**
		 */		
		private var seriesClassMap:Map = new Map;
		
		
		/**
		 * 重设图表的配置信息
		 */		
		public function reset():void
		{
			this.clearSeries();
			this.hTitle = this.vTitle = this.title = '';
		}
		
		/**
		 * 采用模板后，序列和表格列的字段需要更新为正式值，
		 * 
		 * 避免与后继添加的序列字段不匹配
		 */		
		public function resetDataFields():void
		{
			for each (var item:SeriesProxy in this.series)
				item.setField(item.type, item.startColumnIndex, item.endColumnIndex);
		}
		
		
		
		//----------------------------------------------
		//
		//
		// 添加和改变序列类型
		//
		//
		//----------------------------------------------
		
		/**
		 * 判断是否可以添加序列进来
		 * 
		 * 线、柱、散点、气泡、堆积图可自由混合添加，只要空间够
		 */		
		public function ifCanAddSeries(type:String):Boolean
		{
			//饼图存在时，不能加入其他任何类型；
			if (ifHasPieSeries)
				return false;
			
			//其它类型存在时不能加入饼图
			if(this.ifHasSeries() && type == ChartTypePanel.PIE)
				return false;
			
			//条形图存在时，只能加入条形图和堆积条形图；其他图存在时不能加入条形图
			if (ifHasBarSeries)
			{
				if (type == ChartTypePanel.BAR || type == ChartTypePanel.STACKED_BAR)
					return true;
				else
					return false;
			}
			else if (ifHasSeries())//此时只有一般的图表类型
			{
				if (type == ChartTypePanel.BAR || type == ChartTypePanel.STACKED_BAR)
					return false;
				else
					return true;
			}
			else // 此时还未添加任何序列
			{
				return true;
			}
		}
		
		/**
		 * 
		 * 此时已存在了序列
		 * 
		 * 是否可以改变当前序列类型
		 * 
		 * 首先字段数要匹配
		 * 
		 * 多序列下条形与其他类型不可共存
		 * 
		 * 同类型不可以替换
		 */		
		public function ifCanChangeSeries(newType:String, startIndex:uint, endIndex:uint):Boolean
		{
			var targetSeries:SeriesProxy;
			
			for each (var item:SeriesProxy in this.series)
			{
				//找到
				if (startIndex >= item.startColumnIndex && endIndex <= item.endColumnIndex)
				{
					targetSeries = item;
					break;					
				}
			}
			
			if (targetSeries)
			{
				// 相同类型
				if (newType == targetSeries.type)
					return false;
				
				// 防止汽包图被其他图日，只要能日进去就糟糕了
				if (targetSeries.type == ChartTypePanel.BUBBLE)
					return false;
				
				// 仅有一个序列的情况下随便换
				if (this.series.length == 1)
				{
					return true;
				}
				else//此时尽可能是多个条形序列，或者多个自由序列
				{
					if (newType == ChartTypePanel.PIE)
					{
						return false;
					}
					else if (newType == ChartTypePanel.BAR || newType == ChartTypePanel.STACKED_BAR)
					{
						if (this.ifHasBarSeries)
							return true;
						else
							return false;
					}
					else
					{
						if (ifHasBarSeries)
						{
							if (this.series.length == 1)
								return true;
							else
								return false;
						}
						// 此时是自由序列的组合
						return true;
					}
				}
			}
			else
			{
				return false;
			}
		}
		
		/**
		 */		
		public function addSeries(item:SeriesProxy):void
		{
			series.push(item);	
			
			item.render();
			this.addChild(item);
			
			if (item.type == ChartTypePanel.PIE)
				ifHasPieSeries = true;
			else if (item.type == ChartTypePanel.BAR || item.type == ChartTypePanel.STACKED_BAR)
				ifHasBarSeries = true;
			
			seriesChanged = true;
		}
		
		/**
		 */		
		private function deleteSeriesHandler(evt:ChartEvent):void
		{
			evt.stopPropagation();
			
			var item:SeriesProxy = evt.seriesItem;;
			var index:uint = this.series.indexOf(item);
			
			_deleteSeries(item, index);
		}
		
		/**
		 */		
		public function deleteSeries(startIndex:uint, endIndex:uint):SeriesProxy
		{
			var targetSeries:SeriesProxy;
			var i:uint = 0;
			
			for each (var item:SeriesProxy in this.series)
			{
				//找到
				if (startIndex == item.startColumnIndex && endIndex == item.endColumnIndex)
				{
					targetSeries = item;
					break;					
				}
				
				i ++;
			}
			
			if (targetSeries)
			{
				_deleteSeries(targetSeries, i);
				
				return targetSeries;
			}
			
			return null;
		}
		
		/**
		 * 根据序列所占列范围获取序列
		 */		
		public function getSeriesByIndexRange(startIndex:uint, endIndex:uint):SeriesProxy
		{
			var targetSeries:SeriesProxy;
			for each (var item:SeriesProxy in this.series)
			{
				//找到
				if (startIndex == item.startColumnIndex && endIndex == item.endColumnIndex)
				{
					targetSeries = item;
					break;					
				}
			}
			
			return targetSeries;
		}
		
		/**
		 */		
		private function _deleteSeries(item:SeriesProxy, index:uint):void
		{
			if (item)
			{
				item.clear();
				
				if (this.series.length == 1)
				{
					clearSeries();
				}
				else // 此时只可能为多个自由序列
				{
					this.series.splice(index, 1);
					this.removeChild(item);
				}
				
				if (item.type == ChartTypePanel.PIE)
				{
					this.ifHasPieSeries = false;
				}
				
				checkIfHasBarSeries();
				
				seriesChanged = true;
			}
		}
		
		/**
		 * 检测是否含有条形图或者条形堆积图 
		 */		
		private function checkIfHasBarSeries():void
		{
			ifHasBarSeries = false;
			
			for each (var item:SeriesProxy in this.series)
			{
				if (item.type == ChartTypePanel.BAR || item.type == ChartTypePanel.STACKED_BAR)
				{
					this.ifHasBarSeries = true;
					break;
				}
			}
		}
		
		/**
		 */			
		public var seriesChanged:Boolean = false;	
		
		/**
		 */		
		public var ifHasPieSeries:Boolean = false;
		
		/**
		 */		
		public var ifHasBarSeries:Boolean = false;
		
		/**
		 */		
		public function ifHasSeries():Boolean
		{
			if (this.series.length)
				return true;
			else
				return false;
		}
		
		/**
		 * 清空所有序列
		 */		
		public function clearSeries():void
		{
			while(this.numChildren)
				this.removeChildAt(0);
			
			series.length = 0;
			ifHasPieSeries = ifHasBarSeries = false;
			
			seriesChanged = true;
		}
		
		/**
		 * 序列的总长度
		 */		
		public function get len():uint
		{
			return series.length;
		}
		
		/**
		 */		
		private var _series:Vector.<SeriesProxy> = new Vector.<SeriesProxy>;
		
		/**
		 */
		public function get series():Vector.<SeriesProxy>
		{
			return _series;
		}
		
		/**
		 * @private
		 */
		public function set series(value:Vector.<SeriesProxy>):void
		{
			_series = value;
		}
		
		
		
		
		
		
		
		//-------------------------------------------------
		//
		//
		//  配置文件
		//
		//
		//--------------------------------------------------
		

		/**
		 */		
		private var _hAxisType:String = "field";
		
		/**
		 */		
		private var _vAxisType:String = "linear";
		
		/**
		 */		
		private var _title:String = '';
		
		public function get vAxisType():String
		{
			return _vAxisType;
		}

		public function set vAxisType(value:String):void
		{
			_vAxisType = value;
		}

		public function get hAxisType():String
		{
			return _hAxisType;
		}

		public function set hAxisType(value:String):void
		{
			_hAxisType = value;
		}

		public function get vTitle():String
		{
			return _vTitle;
		}

		public function set vTitle(value:String):void
		{
			_vTitle = value;
		}

		public function get hTitle():String
		{
			return _hTitle;
		}

		public function set hTitle(value:String):void
		{
			_hTitle = value;
		}

		/**
		 */
		public function get title():String
		{
			return _title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			_title = value;
		}
		
		/**
		 */		
		private var _hTitle:String = "";
		
		/**
		 */		
		private var _vTitle:String = "";

		/**
		 */		
		public function setConfig(value:XML):void
		{
			if (value.hasOwnProperty("@title"))
				this.title = value.@title;
			else
				this.title = '';
			
			if (value.hasOwnProperty("axis"))
			{
				this.hAxisType = value.axis.x.@type;
				this.vAxisType = value.axis.y.@type;
				
				if (value.axis.x.hasOwnProperty("@title"))
					this.hTitle = value.axis.x.@title;
				else
					hTitle = '';
				
				if (value.axis.y.hasOwnProperty("@title"))
					this.vTitle = value.axis.y.@title;
				else
					vTitle = '';
			}
		}
		
		/**
		 * 获取基于模板的配置文件
		 */		
		public function getConfigXML():XML
		{
			var result:XML = <config title={this.title}>
							 </config>;
			
			checkPrefixAndSuffix(result);
			checkAxis(result);
			getSeriesConfigXML(result);
			
			if (this.len > 1 || (series.length && !RexUtil.ifTextNull(this.series[0].name)))
				result.appendChild(<legend enable='true'/>);
			
			return result;
		}
		
		/**
		 * 设置坐标轴的配置文件
		 */		
		private function checkAxis(config:XML):void
		{
			var axis:XML;
			
			if (this.ifHasPieSeries)
			{
				
			}
			else if (this.ifHasBarSeries)
			{
				axis = <axis>
						 <x type={ChartProxy.LINEAR} title={this.hTitle}/>
						 <y type={ChartProxy.FIELD} title={this.vTitle}/>
					   </axis>;
				
				config.appendChild(axis);
			}
			else
			{
				axis = <axis>
						 <x type={ChartProxy.FIELD} title={this.hTitle}/>
						 <y type={ChartProxy.LINEAR} title={this.vTitle}/>
					   </axis>;
				
				config.appendChild(axis);
			}
		}
		
		/**
		 */		
		public function checkPrefixAndSuffix(config:XML):void
		{
			// 临时先取第一个序列为基准，得出整体数据特质
			for each (var seriesProxy:SeriesProxy in this.series)
			{
				if (seriesProxy)
				{
					seriesProxy.checkPrefixAndSuffix();
					
					yPreffix = seriesProxy.yPreffix;
					ySuffix = seriesProxy.ySuffix;
					
					xPreffix = seriesProxy.xPreffix;
					xSuffix = seriesProxy.xSuffix;
					
					break;
				}
			}
			
			config.@yPreffix = yPreffix;
			config.@ySuffix = ySuffix;
			
			config.@xPreffix = xPreffix;
			config.@xSuffix = xSuffix;
		}
		
		/**
		 * Y值前缀
		 */		
		public var yPreffix:String = '';
		
		/**
		 * Y值后缀
		 */		
		public var ySuffix:String = '';
		
		/**
		 * Y值前缀
		 */		
		public var xPreffix:String = '';
		
		/**
		 * Y值后缀
		 */		
		public var xSuffix:String = '';
		
		/**
		 * 动态获取图表的配置文件
		 */		
		private function getSeriesConfigXML(chartConfig:XML):XML
		{
			chartConfig.series = <series/>
			
			// 此处序排序，把线放到最前面，其次是散点、气泡，最后是柱体；
			var lines:Array = []; 
			
			var markers:Array = [];
			var bubbles:Array = [];
			var areas:Array = [];
			var columns:Array = [];
			var result:Array = [];
			var stackedColumns:Array = [];
			var stackedBars:Array = [];
			
			for each (var seriesH:SeriesProxy in this.series)
			{
				if (seriesH.type == ChartTypePanel.LINE)
				{
					lines.push(seriesH);
				}
				else if (seriesH.type == ChartTypePanel.MARKER)
				{
					markers.push(seriesH);
				}
				else if (seriesH.type == ChartTypePanel.BUBBLE)
				{
					bubbles.push(seriesH);
				}
				else if (seriesH.type == ChartTypePanel.AREA)
				{
					areas.push(seriesH);
				}
				else if (seriesH.type == ChartTypePanel.COLUMN)
				{
					columns.push(seriesH);
				}
				else if (seriesH.type == ChartTypePanel.STACKED_COLUMN)
				{
					stackedColumns.push(seriesH);
				}
				else if (seriesH.type == ChartTypePanel.STACKED_BAR)
				{
					stackedBars.push(seriesH);
				}
				else // 此时为饼图或者条形图
				{
					result.push(seriesH);
				}
			}
			
			result = result.concat(lines);
			result = result.concat(markers);
			result = result.concat(bubbles);
			result = result.concat(areas);
			result = result.concat(columns);
			
			var item:SeriesProxy;
			var stackedColumnXML:XML;
			if (stackedColumns.length)
			{
				stackedColumnXML = <stackedColumn>
										</stackedColumn>;
				for each (item in stackedColumns)
					stackedColumnXML.appendChild(<stack xField={item.xField} yField={item.yField} name={item.name}/>);
			}
			
			var stackedBarXML:XML;
			if (stackedBars.length)
			{
				stackedBarXML = <stackedBar>
								</stackedBar>;
				for each (item in stackedBars)
				stackedBarXML.appendChild(<stack xField={item.xField} yField={item.yField} name={item.name}/>);
			}
			
			for each (item in result)
				chartConfig.series.appendChild(item.getXML());
				
			if (stackedColumnXML)
				chartConfig.series.appendChild(stackedColumnXML);
			
			if (stackedBarXML)
				chartConfig.series.appendChild(stackedBarXML);
				
			return chartConfig;
		}
		
	}
}