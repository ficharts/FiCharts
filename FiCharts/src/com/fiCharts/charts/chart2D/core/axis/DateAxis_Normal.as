package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.DataScale;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.format.DateFormater;
	
	/**
	 */	
	public class DateAxis_Normal extends LinearAxis_Normal implements IAxisPattern, IDateAxisPattern 
	{
		/**
		 */		
		public function DateAxis_Normal(axis:DateAxis)
		{
			super(axis);
		}
		
		/**
		 */		
		private var _output:String = 'YYYY/MM/DD';
		
		/**
		 * 输出格式
		 */
		public function get output():String
		{
			return _output;
		}
		
		/**
		 * @private
		 */
		public function set output(value:String):void
		{
			_output = value;
		}
		
		/**
		 */		
		override public function toNormalPattern():void
		{
		}
		
		/**
		 */		
		private function get dateAxis():DateAxis
		{
			return _axis as DateAxis;
		}
		
		/**
		 */		
		override public function toDataResizePattern():void
		{
			if (dateAxis.dataScalePattern)
				dateAxis.curPattern = dateAxis.dataScalePattern;
			else
				dateAxis.curPattern = new DateAxis_DataScale(dateAxis);
		}
		
		/**
		 */
		public function dateTimeToString(value:Object):String
		{
			if (!RexUtil.ifTextNull(dateAxis.output))
			{
				dateAxis.dateForTransform.time = Number(value);
				
				return DateFormater.dateToString(dateAxis.dateForTransform, dateAxis.output);
			}
			
			dateAxis.dateForTransform.time = Number(value);
			
			if (dateAxis.confirmedSourceValueDis > DateAxis.MILLISECONDS_IN_MINUTE && 
				dateAxis.confirmedSourceValueDis <= DateAxis.MILLISECONDS_IN_HOUR)
			{
				// 秒
				return DateFormater.formatTime(dateAxis.dateForTransform.getMinutes()) + " 00'";
			}
			else if (dateAxis.confirmedSourceValueDis > DateAxis.MILLISECONDS_IN_HOUR && 
				dateAxis.confirmedSourceValueDis <= DateAxis.MILLISECONDS_IN_DAY)
			{
				// 小时，分
				return DateFormater.formatTime(dateAxis.dateForTransform.getHours()) + ":" + DateFormater.formatTime(dateAxis.dateForTransform.getMinutes());
			}
			else if (dateAxis.confirmedSourceValueDis > DateAxis.MILLISECONDS_IN_DAY && 
				dateAxis.confirmedSourceValueDis <= DateAxis.MILLISECONDS_IN_MONTH)
			{
				//几月几日
				return DateFormater.formatTime(dateAxis.dateForTransform.getDate()) + '/' + DateFormater.formatTime(dateAxis.dateForTransform.getMonth() + 1)
			}
			else if (dateAxis.confirmedSourceValueDis > DateAxis.MILLISECONDS_IN_MONTH && 
				dateAxis.confirmedSourceValueDis <= DateAxis.MILLISECONDS_IN_YEAR)
			{
				// 某年某月
				return DateFormater.formatTime(dateAxis.dateForTransform.getMonth() + 1) + '/' + DateFormater.dateToString(dateAxis.dateForTransform, 'YYYY');
			}
			else if (dateAxis.confirmedSourceValueDis > DateAxis.MILLISECONDS_IN_YEAR)
			{
				// 年
				return DateFormater.dateToString(dateAxis.dateForTransform, 'YYYY');
			}
			
			return null;
		}
	}
}