package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.DateAxis;
	import com.fiCharts.charts.chart2D.core.axis.FieldAxis;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.utils.XMLConfigKit.IEditableObject;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class XAxis implements IEditableObject
	{
		/**
		 */		
		private static var ifBottom:Boolean = true;
		
		/**
		 */		
		public static function update():void
		{
			ifBottom = true;
		}
		
		/**
		 */		
		public function XAxis()
		{
		}
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			// 没有设定坐标轴的位置时， 先下后上的顺序依次放置；
			if (!xml.hasOwnProperty('@position'))
			{
				if (ifBottom)
					xml.@position = 'bottom';
				else
					xml.@position = 'top';
				
				ifBottom = (ifBottom) ? false : true;
			}
			
			if (xml.hasOwnProperty('@type'))
				type = xml.@type;
			
			if (type == AxisBase.LINER_AXIS)
				axis = new LinearAxis;
			else if (type == AxisBase.FIELD_AXIS)
				axis = new FieldAxis;
			else
				axis = new DateAxis;
			
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.X_AXIS_STYLE), axis);
			XMLVOMapper.fuck(xml, axis);
		}
		
		/**
		 */		
		private var _xAxis:AxisBase;

		/**
		 */
		public function get axis():AxisBase
		{
			return _xAxis;
		}

		/**
		 * @private
		 */
		public function set axis(value:AxisBase):void
		{
			_xAxis = value;
		}

		
		/**
		 */		
		private var _type:String = 'field'

		/**
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
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
			if (axis.position == 'top')
				XMLVOLib.dispatchCreation(AxisModel.CREATE_TOP_AXIS, axis);
			else
				XMLVOLib.dispatchCreation(AxisModel.CREATE_BOTTOM_AXIS, axis);
		}
	}
}