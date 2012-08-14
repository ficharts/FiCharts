package com.fiCharts.charts.chart3D.baseClasses
{
	import com.fiCharts.charts.chart3D.model.vo.axis.AxisBaseVO;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	
	import flash.events.EventDispatcher;

	public interface ISeries
	{
		
		/**
		 *  Register this to chart.
		 */		
		function register(parent:IMultiSeriesRegister, series:ISeries):void;
		function unRegister(parent:IMultiSeriesRegister, series:ISeries):void;	
		
		/**
		 */		
		function get amountOfThisSeries():int;
		function set amountOfThisSeries(value:int):void;
		
		/**
		 * Index of this series of the same type, from 0 to "amountOfThisSeries" - 1;
		 */		
		function get indexOfThisSeries():int;
		function set indexOfThisSeries(value:int):void;
		
		/**
		 *  Data source.
		 */		
		function get dataProvider():Vector.<Object>;
		function set dataProvider(value:Vector.<Object>):void;
		
		/**
		 *  Data vos generated from data source.
		 */		
		function get seriesItemVOes():Vector.<SeriesDataItemVO>;
		function set seriesItemVOes(value:Vector.<SeriesDataItemVO>):void;
		
		/**
		 *  Transform seriesItemVOes x y values to x y size.
		 *  将节点的值转化为坐标尺寸；
		 */		
		function transformValueToSize():void;
		
		function get columnRenderVOes():Vector.<IItemRenderVO>
		function set columnRenderVOes(value:Vector.<IItemRenderVO>):void
			
		/**
		 * @return 
		 */		
		function createItemRenders():void;
			
		function get horizontalAxis():AxisBaseVO;
		function set horizontalAxis(value:AxisBaseVO):void;
			
		function get verticalAxis():AxisBaseVO;
		function set verticalAxis(value:AxisBaseVO):void;
			
		function get xField():String;
		function set xField(v:String):void;
			
		function get yField():String;
		function set yField(value:String):void;
		
		function get colorField():String;
		function set colorField(value:String):void;
			
		function get color():Object;
		function set color(value:Object):void;
		
		/**
		 * 序列的数据改变时更新坐标轴的数据；
		 */		
		function updateAxisValueRange():void;
		
		/**
		 */		
		function get zSize():int;
		function set zSize(value:int):void;
		
		function get seriesName():String;
		function set seriesName(value:String):void;
		
		function generateXLabelForItem(value:Object):String;
		function generateYLabelForItem(value:Object):String;
		
		function get verticalAxisID():String;
		function set verticalAxisID(value:String):void;
	}
}