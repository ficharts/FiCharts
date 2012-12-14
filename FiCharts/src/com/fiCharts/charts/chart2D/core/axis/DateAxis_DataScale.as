package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.Zoom;
	import com.fiCharts.utils.Map;
	import com.fiCharts.utils.format.DateFormater;
	
	/**
	 */	
	public class DateAxis_DataScale extends LinearAxis_DataScale implements IAxisPattern, IDateAxisPattern
	{
		/**
		 */		
		public function DateAxis_DataScale(value:AxisBase)
		{
			super(value);
		}
		
		
		/**
		 */		
		private var _output:XML = <out>
									<ymd>YYYY年/MM月/DD日</ymd>
									<ym>YYYY年/MM月</ym>
									<y>YYYY年</y>
									<m>MM月</m>
									<d>DD日</d>
									<h>hh:00</h>
									<hm>hh:mm:00</hm>
									<hms>hh:mm:ss</hms>
								  </out>;
		
		/**
		 * 输出格式
		 */
		public function get output():String
		{
			return _output.toString();
		}
		
		/**
		 * @private
		 */
		public function set output(value:String):void
		{
			_output = XML(value);
		}
		
		/**
		 */		
		override public function beforeRender():void
		{
			super.beforeRender();
			
			labelVOsMap.clear();
			labelValuesMap.clear();
		}
		
		/**
		 * 缓存下已经构建了的label数据，因为大量的label被构建很耗性能
		 */		
		override protected function createLabelsData():void
		{
			if (labelVOsMap.containsKey(dateAxis.uintAmount))
			{
				axis.labelVOes.length = axis.labelUIs.length = axis.labelValues.length = 0;
				dateAxis.labelVOes = (labelVOsMap.getValue(dateAxis.uintAmount) as Vector.<AxisLabelData>).concat();	
				dateAxis.labelValues = (labelValuesMap.getValue(dateAxis.uintAmount) as Array).concat();
			}
			else
			{
				axis.createLabelsData(dataScaleProxy.sourceDataRange.max, dataScaleProxy.sourceDataRange.min);
				labelVOsMap.put(dateAxis.uintAmount, axis.labelVOes.concat());
				labelValuesMap.put(dateAxis.uintAmount, axis.labelValues.concat());
			}
		}
		
		/**
		 *  
		 */		
		private var labelVOsMap:Map = new Map();
		
		/**
		 */		
		private var labelValuesMap:Map = new Map;
		
		/**
		 */		
		private function get dateAxis():DateAxis
		{
			return this._axis as DateAxis;
		}
		
		/**
		 */		
		override public function toNormalPattern():void
		{
			if (axis.normalPattern)
				axis.curPattern = axis.normalPattern;
			else
				axis.curPattern = new DateAxis_Normal(dateAxis);
		}
		
		/**
		 */
		public function dateTimeToString(value:Object):String
		{
			dateAxis.dateForTransform.time = Number(value);
			var ifDayStart:Boolean = ifDayDepart(dateAxis.dateForTransform);
			
			if (dateAxis.lastValidUnits == "minutes")
			{
				// 分
				if (ifDayStart)
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.ymd);
				else
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.hm);
			}
			else if (dateAxis.lastValidUnits == "hours")
			{
				// 小时，分
				if (ifDayStart)
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.ymd);
				else
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.h);
			}
			else if (dateAxis.lastValidUnits == "days")
			{
				//几月几日
				if (dateAxis.dateForTransform.date == 1)
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.ym);
				else
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.d);
			}
			else if (dateAxis.lastValidUnits == "months")
			{
				// 某年某月
				if (dateAxis.dateForTransform.month == 0 && dateAxis.dateForTransform.date == 1)
					return  DateFormater.dateToString(dateAxis.dateForTransform, _output.ym);
				else
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.m);
			}
			else if (dateAxis.lastValidUnits == "years")
			{
				// 年
				return DateFormater.dateToString(dateAxis.dateForTransform, _output.y);
			}
			else
			{// 秒
				if (ifDayStart)
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.ymd);
				else
					return DateFormater.dateToString(dateAxis.dateForTransform, _output.hms);
			}
			
			
			return null;
		}
		
		/**
		 * 
		 */		
		private function ifDayDepart(date:Date):Boolean
		{
			if (date.hours == 0 && date.minutes == 0 && date.seconds == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
		/**
		 */		
		override public function toZoomPattern():void
		{
		}
		
		/**
		 */		
		override public function getPercentBySourceData(data:Object):Number
		{
			return getPercentByData(dateAxis.stringDateToDateTimer(data));
		}
		
	}
}