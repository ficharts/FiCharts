package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.utils.XMLConfigKit.IEditableObject;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;

	public class AxisModel implements IEditableObject
	{
		/**
		 */		
		public static const START_AXIS_CREATION:String = 'startAxisCreation';
		
		/**
		 */		
		public static const CREATE_LEFT_AXIS:String = 'createLeftAxis';
		public static const CREATE_RIGHT_AXIS:String = 'createRightAxis'
			
		/**
		 */			
		public static const CREATE_TOP_AXIS:String = 'createTopAxis';
		public static const CREATE_BOTTOM_AXIS:String ='createBottomAxis';
		
		/**
		 */		
		public function AxisModel()  
		{
		}
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			this._horizontalAxis = new Vector.<AxisBase>;
			this._verticalAxis = new Vector.<AxisBase>;
			
			XMLVOLib.dispatchCreation(START_AXIS_CREATION, this);
		}
		
		/**
		 */		
		public function propertiesUpdated(xml:* = null):void
		{
			
		}
		
		/**
		 */		
		public function created():void
		{
			changed = true;
		}
		
		/**
		 */		
		public var changed:Boolean = false;
		
		/**
		 */
		public function get xAxis():XAxis
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set xAxis(value:XAxis):void
		{
			horizontalAxis.push(value.axis);
		}
		
		/**
		 */
		public function get x():XAxis
		{
			return null;
		}

		public function set x(value:XAxis):void
		{
			horizontalAxis.push(value.axis);;
		}

		/**
		 */
		public function get yAxis():YAxis
		{
			return null;
		}

		public function set yAxis(value:YAxis):void
		{
			verticalAxis.push(value.axis);
		}
		
		/**
		 */
		public function get y():YAxis
		{
			return null;
		}
		
		public function set y(value:YAxis):void
		{
			verticalAxis.push(value.axis);;
		}
		
		/**
		 */		
		private var _horizontalAxis:Vector.<AxisBase>;

		/**
		 */
		public function get horizontalAxis():Vector.<AxisBase>
		{
			return _horizontalAxis;
		}

		/**
		 */		
		private var _verticalAxis:Vector.<AxisBase>;

		/**
		 */
		public function get verticalAxis():Vector.<AxisBase>
		{
			return _verticalAxis;
		}

	}
}