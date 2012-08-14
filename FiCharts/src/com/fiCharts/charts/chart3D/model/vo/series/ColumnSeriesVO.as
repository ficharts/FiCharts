package com.fiCharts.charts.chart3D.model.vo.series
{
	import com.fiCharts.charts.chart3D.ManagerFor3D;
	import com.fiCharts.charts.chart3D.baseClasses.IItemRenderVO;
	import com.fiCharts.charts.chart3D.baseClasses.IMultiSeriesRegister;
	import com.fiCharts.charts.chart3D.baseClasses.ISeries;
	import com.fiCharts.charts.chart3D.model.vo.axis.AxisBaseVO;
	import com.fiCharts.charts.chart3D.model.vo.axis.LinearAxisVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.CubeVO;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.Point3D;
	
	import flash.events.EventDispatcher;

	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public class ColumnSeriesVO implements ISeries
	{
		public function ColumnSeriesVO()
		{
		}
		
		/**
		 */		
		public function generateXLabelForItem(value:Object):String
		{
			/*if (horizontalAxis.displayName)
				return horizontalAxis.displayName + ':' + this.horizontalAxis.formatXValue(value);
			else*/
				return horizontalAxis.formatXValue(value)
		}
		
		/**
		 */		
		public function generateYLabelForItem(value:Object):String
		{
			/*if (verticalAxis.displayName)
				return verticalAxis.displayName + ':' + this.verticalAxis.formatYValue(value);
			else*/
				return this.verticalAxis.formatYValue(value);
		}
		
		/**
		 */		
		public function register(parent:IMultiSeriesRegister, series:ISeries):void
		{
			parent.addColumnSeries(this);
		}
		
		/**
		 */		
		public function unRegister(parent:IMultiSeriesRegister, series:ISeries):void
		{
			parent.removeColumnSeries(this);
		}
		
		/**
		 */		
		private var _indexOfThisSeries:int;

		public function get indexOfThisSeries():int
		{
			return _indexOfThisSeries;
		}

		public function set indexOfThisSeries(value:int):void
		{
			_indexOfThisSeries = value;
		}

		/**
		 */		
		private var _numberOfShisSeries:int;

		public function get amountOfThisSeries():int
		{
			return _numberOfShisSeries;
		}

		public function set amountOfThisSeries(value:int):void
		{
			_numberOfShisSeries = value;
		}
		
		/**
		 */		
		private var _name:String = "";

		public function get seriesName():String
		{
			return _name;
		}

		public function set seriesName(value:String):void
		{
			_name = value;
		}
		
		/**
		 *  zSize of column. 
		 */		
		private var _zSize:int;

		public function get zSize():int
		{
			return _zSize;
		}

		public function set zSize(value:int):void
		{
			_zSize = value;
		}
		
		/**
		 * 创建柱体的渲染VO
		 */		
		public function createItemRenders():void
		{
			columnRenderVOes = new Vector.<IItemRenderVO>();
			var seriesDataItem:SeriesDataItemVO;
			var columnRenderVO:ColumnVO;
			
			for each (seriesDataItem in seriesItemVOes)
			{
				columnRenderVO = new ColumnVO();
				columnRenderVO.itemVO = seriesDataItem;
				columnRenderVO.color = seriesDataItem.color;
				
				columnRenderVO.location3D = new Point3D();
				columnRenderVOes.push(columnRenderVO);
			}
		}
		
		/**
		 * 将节点的值转化为坐标尺寸， 柱体的位置与尺寸都取整， 从源头限制柱体的布局信息；
		 */		
		public function transformValueToSize():void
		{
			var columnRenderVO:ColumnVO;
			var location:Point3D;
			for each (columnRenderVO in columnRenderVOes)
			{
				columnRenderVO.itemVO.x = horizontalAxis.valueToSize(columnRenderVO.itemVO.xValue);
				columnRenderVO.itemVO.y = verticalAxis.valueToSize(columnRenderVO.itemVO.yValue);
				
				location = columnRenderVO.location3D;
				location.x = Math.round(getXCoordinate(columnRenderVO));
				location.z = 0;
				columnRenderVO.xSize = Math.round(partColumnWidth);
				columnRenderVO.zSize = Math.round(zSize);
				setColumnPositonAndHeight(columnRenderVO);
			}
		}
		
		/**
		 * 根据节点的取值设定柱体的方向及尺寸坐标信息；
		 */		
		private function setColumnPositonAndHeight(columnRenderVO:ColumnVO):void
		{
			var yCoordinate:Number = Math.round(columnRenderVO.itemVO.y);
			
			columnRenderVO.location3D.y = Math.round(verticalAxis.valueToSize(baseYCoorDinate));
			columnRenderVO.ySize = Math.abs(yCoordinate - columnRenderVO.location3D.y);
				
			if (columnRenderVO.itemVO.yValue >= 0)// Y轴正方向
				columnRenderVO.direction = ColumnVO.COLUMN_UP;
			else // Y轴负方向
				columnRenderVO.direction = ColumnVO.LOLUMN_DOWN; 
		}
		
		/**
		 * 柱体的基准起始坐标， 用来计算柱体的起始位置；
		 */		
		private function get baseYCoorDinate():Number
		{
			var result:Number;
			var axis:LinearAxisVO = this.verticalAxis as LinearAxisVO;
			
			if (axis.maximum > 0 && axis.minimum >= 0)// 非负值
			{
				result = axis.minimum;
			}
			else if (axis.minimum < 0 && axis.maximum <= 0)// 非正值
			{
				result = axis.maximum;	
			}
			else// 介于负值与正值之间
			{
				result = 0;
			}
			
			return result;
		}
		
		/**
		 */		
		private var _dataProvider:Vector.<Object>;

		public function get dataProvider():Vector.<Object>
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Vector.<Object>):void
		{
			_dataProvider = value;
		}
		
		/**
		 */		
		public function updateAxisValueRange():void
		{
			horizontalAxis.updateData(xValues);
			verticalAxis.updateData(yValues);
		}
		
		/**
		 *  X value collection of data items .
		 * 
		 * @return 
		 */		
		private function get xValues():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			
			for each (var item:SeriesDataItemVO in seriesItemVOes)
			{
				result.push(item.xValue);
			}
			
			return result;
		}
		
		/**
		 *  Y value collection of data items
		 * 
		 * @return 
		 */		
		private function get yValues():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			
			for each (var item:SeriesDataItemVO in seriesItemVOes)
			{
				result.push(item.yValue);
			}
			
			return result;
		}
		
		/**
		 */		
		private var _seriesItemVOes:Vector.<SeriesDataItemVO>;

		public function get seriesItemVOes():Vector.<SeriesDataItemVO>
		{
			return _seriesItemVOes;
		}

		public function set seriesItemVOes(value:Vector.<SeriesDataItemVO>):void
		{
			_seriesItemVOes = value;
		}
		
		/**
		 */		
		private var _seriesItemRenders:Vector.<IItemRenderVO>;

		public function get columnRenderVOes():Vector.<IItemRenderVO>
		{
			return _seriesItemRenders;
		}

		public function set columnRenderVOes(value:Vector.<IItemRenderVO>):void
		{
			_seriesItemRenders = value;
		}
		
		private var _horizontalAxis:AxisBaseVO;
		public function get horizontalAxis():AxisBaseVO
		{
			return _horizontalAxis;
		}
		
		/**
		 *  individual aixs.
		 * @param v
		 */
		public function set horizontalAxis(value:AxisBaseVO):void
		{
			_horizontalAxis = value;
			_horizontalAxis.direction = AxisBaseVO.HORIZONTAL_AXIS;
		}
		
		/**
		 */
		private var _verticalAxis:AxisBaseVO;
		public function get verticalAxis():AxisBaseVO
		{
			return _verticalAxis;
		}
		
		public function set verticalAxis(value:AxisBaseVO):void
		{
			_verticalAxis = value;
			_verticalAxis.direction = AxisBaseVO.VERTICAL_AXIX;
		}

		/**
		 */		
		private var _xField : String;
		public function get xField():String
		{
			return _xField;
		}
		
		public function set xField(v:String):void
		{
			_xField = v;
		}
		
		/**
		 */		
		private var _yField : String 
		public function get yField():String
		{
			return _yField;
		}
		
		public function set yField(v:String):void
		{
			_yField = v;
		}
		
		/**
		 */		
		private var _colorField:String = "color";

		public function get colorField():String
		{
			return _colorField;
		}

		public function set colorField(value:String):void
		{
			_colorField = value;
		}
		
		/**
		 */		
		private var _color:Object;

		public function get color():Object
		{
			return _color;
		}

		public function set color(value:Object):void
		{
			_color = StyleManager.getUintColor(value);
		}
		
		
		
		
		//------------------------------------------------
		//
		// 柱体的尺寸位置计算
		//
		//-------------------------------------------------
		
		/**
		 */		
		private function getXCoordinate(item:ColumnVO):Number
		{
			var startX:Number = item.itemVO.x - columnGoupWidth / 2;
			return startX + indexOfThisSeries * (partColumnWidth + columnGroupInnerSpaceUint);
		}
		
		/**
		 */		
		private function get partColumnWidth():Number
		{
			return (columnGoupWidth - columnGroupInnerSpace) / amountOfThisSeries
		}
		
		/**
		 * 出去两边空隙后得到的柱体群总宽度；
		 */		
		private function get columnGoupWidth():Number
		{
			return horizontalAxis.unitSize - columnGroupOuterSpaceUint * 2;
		}
		
		/**
		 * 单元柱体群内部总间隙;
		 */		
		private function get columnGroupInnerSpace():Number
		{
			return columnGroupInnerSpaceUint * (amountOfThisSeries - 1);
		}
		
		/**
		 * 柱体群内部的单元间隙，个数为群柱体个数 - 1；
		 */		
		private function get columnGroupInnerSpaceUint():Number
		{
			return  horizontalAxis.unitSize * .05;
		}
		
		/**
		 * 柱体群外单元空隙，每个柱体群有两个此间隙；
		 */
		public function get columnGroupOuterSpaceUint():Number
		{
			return horizontalAxis.unitSize * .1;
		}
		
		private var _axisID:String;

		public function get verticalAxisID():String
		{
			return _axisID;
		}

		public function set verticalAxisID(value:String):void
		{
			_axisID = value;
		}

	}
}