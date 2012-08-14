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
	public class YAxis implements IEditableObject
	{
		/**
		 */		
		private static var ifLeft:Boolean = true;
		
		/**
		 */		
		public static function update():void
		{
			ifLeft = true;
		}
		
		/**
		 */		
		public function YAxis()
		{
		}
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			// 没有设定坐标轴的位置时， 先左后右的顺序依次放置；
			if (!xml.hasOwnProperty('@position'))
			{
				if (ifLeft)
					xml.@position = 'left';
				else
					xml.@position = 'right';
				
				ifLeft = (ifLeft) ? false : true;
			}
			
			if (xml.hasOwnProperty('@type'))
				type = xml.@type;
			
			if (type == AxisBase.LINER_AXIS)
				axis = new LinearAxis;
			else if (type == AxisBase.FIELD_AXIS)
				axis = new FieldAxis;
			else
				axis = new DateAxis;
			
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.Y_AXIS_STYLE), axis);
			XMLVOMapper.fuck(xml, axis);
		}
		
		/**
		 */		
		private var _type:String = 'linear'
		
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
		private var _axis:AxisBase;

		/**
		 */
		public function get axis():AxisBase
		{
			return _axis;
		}

		/**
		 * @private
		 */
		public function set axis(value:AxisBase):void
		{
			_axis = value;
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
			if (axis.position == 'left')
				XMLVOLib.dispatchCreation(AxisModel.CREATE_LEFT_AXIS, axis);
			else
				XMLVOLib.dispatchCreation(AxisModel.CREATE_RIGHT_AXIS, axis);
		}
	}
}