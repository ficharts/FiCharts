package com.fiCharts.charts.common
{
	import flash.events.EventDispatcher;

	/**
	 */
	public class SeriesDataPoint extends EventDispatcher
	{
		public function SeriesDataPoint()
		{
		}
		
		/**
		 * 数据在元数据中的位置
		 */		
		private var _index:uint = 0;
		
		public function get index():uint
		{
			return _index;
		}
		
		public function set index(value:uint):void
		{
			_index = value;
		}
		
		/**
		 * 原始数据节点， 从XML数据映射而来；
		 */		
		private var _dataItem : Object;
		
		/**
		 */		
		public function get metaData():Object
		{
			return _dataItem;
		}

		public function set metaData(v:Object):void
		{
			_dataItem = v;
		}
		
		/**
		 */		
		private var _xValue : Object;
		public function get xValue():Object
		{
			return _xValue;
		}

		public function set xValue(v:Object):void
		{
			_xValue = v;
		}
		
		/**
		 */		
		private var _xVerifyValue:Object;

		public function get xVerifyValue():Object
		{
			return _xVerifyValue;
		}

		public function set xVerifyValue(value:Object):void
		{
			_xVerifyValue = value;
		}
		
		/**
		 */		
		private var _yVerifyValue:Object

		/**
		 * 
		 */
		public function get yVerifyValue():Object
		{
			return _yVerifyValue;
		}

		/**
		 * @private
		 */
		public function set yVerifyValue(value:Object):void
		{
			_yVerifyValue = value;
		}


		/**
		 */
		private var _yValue : Object;
		public function get yValue():Object
		{
			return _yValue;
		}

		public function set yValue(v:Object):void
		{
			_yValue = v;
		}
		
		private var _xLabel:String;

		public function get xLabel():String
		{
			return _xLabel;
		}

		public function set xLabel(value:String):void
		{
			_xLabel = value;
		}

		
		private var _yLabel:String;

		public function get yLabel():String
		{
			return _yLabel;
		}

		public function set yLabel(value:String):void
		{
			_yLabel = value;
		}
		
		private var _zValue:Object;

		public function get zValue():Object
		{
			return _zValue;
		}

		public function set zValue(value:Object):void
		{
			_zValue = value;
		}

		/**
		 */		
		private var _zLabel:String;

		public function get zLabel():String
		{
			return _zLabel;
		}

		public function set zLabel(value:String):void
		{
			_zLabel = value;
		}
		
		/**
		 */		
		private var _x : Number = 0;
		public function get x():Number
		{
			return _x;
		}

		public function set x(v:Number):void
		{
			_x = v;
		}

		/**
		 */
		private var _y : Number = 0; 
		public function get y():Number
		{
			return _y;
		}

		public function set y(v:Number):void
		{
			_y = v;
		}
		
		/**
		 */		
		private var _z:Number = 0;

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		/**
		 * 数据节点的坐标不一定等于渲染节点的坐标， 如柱状图；
		 */		
		private var _dataItemX:Number;

		public function get dataItemX():Number
		{
			return _dataItemX;
		}

		public function set dataItemX(value:Number):void
		{
			_dataItemX = value;
		}

		/**
		 */		
		private var _dataItemY:Number;

		public function get dataItemY():Number
		{
			return _dataItemY;
		}

		public function set dataItemY(value:Number):void
		{
			_dataItemY = value;
		}
		
		/**
		 *  数据节点的坐标不一定与渲染节点的坐标相同， 如柱状图；
		 * 
		 *  渲染节点的坐标系与数据节点坐标系不同， 两者具有偏差；
		 */		
		private var _offset:Number = 0;

		/**
		 */
		public function get offset():Number
		{
			return _offset;
		}

		/**
		 * @private
		 */
		public function set offset(value:Number):void
		{
			_offset = value;
		}

		/**
		 */		
		private var _color:uint;
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		/**
		 */		
		private var _seriesName:String = "";

		public function get seriesName():String
		{
			return _seriesName;
		}

		public function set seriesName(value:String):void
		{
			_seriesName = value;
		}
		
		/**
		 */		
		private var _xDisplayName:String;

		public function get xDisplayName():String
		{
			return _xDisplayName;
		}

		public function set xDisplayName(value:String):void
		{
			_xDisplayName = value;
		}

		/**
		 */		
		private var _yDisplayName:String;

		public function get yDisplayName():String
		{
			return _yDisplayName;
		}

		public function set yDisplayName(value:String):void
		{
			_yDisplayName = value;
		}
		
		/**
		 */		
		private var _zDisplayName:String;

		public function get zDisplayName():String
		{
			return _zDisplayName;
		}

		public function set zDisplayName(value:String):void
		{
			_zDisplayName = value;
		}
		
		/**
		 *  数值标签， 默认为 ${yLabel}, 条形图的为 ${xLabel}, 气泡图的为${zLabel}, 
		 * 
		 *  百分比图的为 ${zLabel}; 
		 */		
		private var _valueLabel:String;

		/**
		 */
		public function get valueLabel():String
		{
			return _valueLabel;
		}

		/**
		 * @private
		 */
		public function set valueLabel(value:String):void
		{
			_valueLabel = value;
		}

	}
}