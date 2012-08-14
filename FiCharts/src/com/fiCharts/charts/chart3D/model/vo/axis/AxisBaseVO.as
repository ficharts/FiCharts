package com.fiCharts.charts.chart3D.model.vo.axis
{
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.charts.chart3D.baseClasses.LocationVOBase;
	import com.fiCharts.utils.graphic.StyleManager;

	public class AxisBaseVO extends LocationVOBase
	{
		// Direction.
		public static const HORIZONTAL_AXIS : String = "horizontalAxis";
		public static const VERTICAL_AXIX : String = "verticalAixs";
		
		/**
		 */		
		public static const NORMAL:String = "normal";
		public static const WRAP:String = "wrap";
		public static const ROTATION:String = "rotation";
		
		/**
		 */		
		public function AxisBaseVO()
		{
		}
		
		/**
		 * 为坐标轴数据更新做好准备；
		 */		
		public function redyToUpdateData():void
		{
			
		}
		
		/**
		 * 更新坐标轴数据
		 */		
		public function updateData(value:Vector.<Object>):void
		{
			
		}
		
		/**
		 * 数据更新结束
		 */		
		public function dataUpdated():void
		{
			
		}
		
		/**
		 * 根据新的尺寸信息和数据分割坐标轴单位
		 */		
		public function generateAxisLabelVO():void
		{
			
		}
		
		/**
		 */		
		public function layoutHorizontalLabels():void
		{
			
		}
		
		/**
		 */		
		public function layoutVerticalLabels():void
		{
			
		}
		
		/**
		 */		
		protected var ifDataChanged:Boolean = false;
		
		/**
		 */		
		private var _direction:String;
		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * @param value
		 * @return 
		 */		
		public function valueToSize(value:Object):Number
		{
			var resultSize:uint;
			
			return resultSize;
		}
		
		/**
		 */		
		private var _unitSize:Number = 0;
		
		public function get unitSize():Number
		{
			return _unitSize;
		}
		
		public function set unitSize(value:Number):void
		{
			_unitSize = value;
		}
		
		/**
		 *  Width or height of this axis.
		 */		
		private var _length:Number;

		public function get size():Number
		{
			return _length;
		}

		public function set size(value:Number):void
		{
			if (_length != value)
			{
				_length = value;
				_ifLengthChanged = true;				
			}
		}
		
		private var _ifLengthChanged:Boolean = false;

		/**
		 */
		public function get ifLengthChanged():Boolean
		{
			return _ifLengthChanged;
		}

		/**
		 * @private
		 */
		public function set ifLengthChanged(value:Boolean):void
		{
			_ifLengthChanged = value;
		}

		
		/**
		 */		
		private var _labels:Vector.<AxisLabelVO>;

		public function get labels():Vector.<AxisLabelVO>
		{
			return _labels;
		}

		public function set labels(value:Vector.<AxisLabelVO>):void
		{
			_labels = value;
		}
		
		/**
		 */		
		public function get ticks():Vector.<Number>
		{
			return _ticks;
		}
		
		protected var _ticks:Vector.<Number>;
		
		/**
		 * 标签起始位置到标签的距离； 
		 */		
		private var _gutter:uint = 10;

		public function get gutter():uint
		{
			return _gutter;
		}

		public function set gutter(value:uint):void
		{
			_gutter = value;
		}
		
		/**
		 * 标签偏离坐标轴的距离， 因为下背景底部具有一定的高度所以标签需要向下偏移一定距离； 
		 */		
		private var _labelOffSet:uint = 0;

		public function get labelOffSet():uint
		{
			return _labelOffSet;
		}

		public function set labelOffSet(value:uint):void
		{
			_labelOffSet = value;
		}
		
		/**
		 */		
		protected var _disPlayName:String
		public function set displayName(value:String) : void
		{
			_disPlayName = value;
		}
		
		/**
		 */		
		public function get displayName():String
		{
			if (_disPlayName == null)
				return this.title;
			else
				return _disPlayName;
		}

		/**
		 */		
		private var _name:String;

		public function get title():String
		{
			return _name;
		}

		public function set title(value:String):void
		{
			_name = value;
		}
		
		/**
		 * 标签的布局方式：正常， 换行， 旋转；
		 */
		private var _labelLayout:String = "normal";

		public function get labelLayout():String
		{
			return _labelLayout;
		}

		public function set labelLayout(value:String):void
		{
			_labelLayout = value;
		}
		
		
		//---------------------------------------
		//
		// 数据格式化
		//
		//---------------------------------------
		
		public function formatXValue(value:Object):String
		{
			return null;
		}
		
		public function formatYValue(value:Object):String
		{
			return null;
		}
		
		private var _dataFormatter:ChartDataFormatter;
		
		/**
		 */
		public function get dataFormatter():ChartDataFormatter
		{
			return _dataFormatter;
		}
		
		/**
		 * @private
		 */
		public function set dataFormatter(value:ChartDataFormatter):void
		{
			_dataFormatter = value;
		}
		
		/**
		 */		
		private var _id:String;

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 * 当存在两个纵轴时，每个纵轴的标签颜色与其对应的序列色一致；
		 */		
		private var _labelColor:Object;
		
		public function get labelColor():Object
		{
			return _labelColor;
		}
		
		public function set labelColor(value:Object):void
		{
			_labelColor = value;
		}
	}
}