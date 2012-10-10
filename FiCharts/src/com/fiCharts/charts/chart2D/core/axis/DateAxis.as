package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.format.DateFormater;
	
	/**
	 */
	public class DateAxis extends LinearAxis
	{
		/**
		 * Constructor.
		 */
		public function DateAxis()
		{
			super();
			
			millisecondsP = "milliseconds";
			secondsP = "seconds";
			minutesP = "minutes";
			hoursP = "hours";
			dateP = "date";
			dayP = "day";
			monthP = "month";
			fullYearP = "fullYear";         
		}
		
		/**
		 */		
		private var _input:String = 'YYYY/MM/DD';

		/**
		 * 输入格式
		 */
		public function get input():String
		{
			return _input;
		}

		/**
		 * @private
		 */
		public function set input(value:String):void
		{
			_input = value;
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
		 * 将传进来的字符串转化为时间对象，然后再将时间对象转化为毫秒数值；
		 */
		override public function pushValues(values:Vector.<Object>):void
		{
			var dateTimers:Vector.<Object> = new Vector.<Object>;
			for each (var item:String in values)
				dateTimers.push(stringDateToDateTimer(item));
			
			super.pushValues(dateTimers);
		}
		
		/**
		 */		
		override public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
				
			
			DateFormater
			
			//TODO
			return seriesDataFeature;
		}
		
		/**
		 */
		override public function dataUpdated():void
		{
			sourceValues.sort(Array.NUMERIC);
			
			var temMin:Number;
			var temMax:Number;

			if (!isNaN(assignedMinimum))
				temMin = assignedMinimum;
			
			if (!isNaN(assignedMaximum))
				temMax = assignedMaximum;

			// 没有设置最大最小值时则从系统数据获取；
			var autoGen:Boolean = isNaN(assignedMinimum) || isNaN(assignedMaximum);

			if (autoGen)
			{
				// 单值的情况；
				if (sourceValues.length == 1)
				{
					temMin = temMax = sourceValues.pop();
					if (temMax > 0)
						temMin = 0;
					else if (temMax < 0)
						temMax = 0;
				}
				else // 多值的情况
				{
					temMin = sourceValues.shift();
					temMax = sourceValues.pop();
				}
			}

			this.sourceMax = temMax;
			this.sourceMin = temMin; 
				
			this.label.layout = this.labelDisplay;
			
			if (label.layout == LabelStyle.NONE)
				label.enable = false;
			else 
				label.enable = true;
			
			changed = true;
		}
		
		/**
		 * 渲染之前调用；
		 */		
		override public function updateAxis():void
		{
			if (changed)
			{
				//最小单位值
				var minUintValue:Number = 0;
				var lastValidUnits:String = units;
				var minD:Date = new Date(sourceMax);
				var maxD:Date = new Date(sourceMin);
				var minMilli:Number = sourceMax;
				var maxMilli:Number = sourceMin;
				var units:String = "years";
				var valueDis:Number;
				var miniInternal:Number;
				var lastValidMin:Number;
				var lastValidMax:Number;
				
				while (units != null)
				{
					computedInterval = toMilli(1, units);
					
					minD.setTime(sourceMin);
					roundDateDown(minD, units);
					minMilli = minD.getTime();
					
					maxD.setTime(sourceMax);
					roundDateUp(maxD, units);
					maxMilli = maxD.getTime();
					
					valueDis = maxMilli - minMilli;// 临时差值；
					miniInternal = toMilli(1, getMiniInternalUint(valueDis));
					
					if (computedInterval >= miniInternal)
					{
						lastValidMin = minMilli;
						lastValidMax = maxMilli;
						lastValidUnits = units;
					}
					else
					{
						break;
					}
						
					units = UNIT_PROGRESSION[units];
				}
				
				_minimum  = lastValidMin;
				_maximum = lastValidMax;
				interval = toMilli(1, lastValidUnits);
				
				labelsData = new Vector.<AxisLabelData>;
				var labelValue:String;
				var uintAmount:uint = Math.ceil(valueDis / interval) + 1;
				var startDate:Date = new Date();
				var currenDate:Date = new Date;
				var labelData:AxisLabelData;
				
				startDate.setTime(_minimum);
				
				for (var i:uint = 0; i < uintAmount; i ++)
				{
					labelData = new AxisLabelData;
					currenDate.setTime(_minimum);
					 switch (lastValidUnits)
					 {
						 case "seconds":
						 {
							currenDate.setSeconds(startDate.getSeconds() + i)
							break;
						 }
						 case "hours":
						 {
							currenDate.setHours(startDate.getHours()+ i)
							break;
						 }
						 case "days":
						 {
							 currenDate.setDate(startDate.getDate()+ i)
							 break;
						 }
						 case "minutes":
						 {
							 currenDate.setMinutes(startDate.getMinutes()+ i)
							 break;
						 }
						 case "years":   
						 {
							currenDate.setFullYear(startDate.getFullYear()+ i)
							break;
						 }
						 case 'months':
						 {
							 currenDate.setMonth(startDate.getMonth()+ i)
							 break;
						 }
					 }
					 
					 labelData.value = dateTimerToLabel(currenDate);
					 labelsData.push(labelData);
				}
				
				unitSize = size / labelAmount;
			}
		}
		
		/**
		 */		
		override public function getXLabel(value:Object):String
		{
			return dataFormatter.formatXString(formatDate(value));
		}
		
		/**
		 */		
		override public function getYLabel(value:Object):String
		{
			return dataFormatter.formatYString(formatDate(value));
		}
		
		/**
		 * 将原始的字符串类型的时间转换为合理的时间显示格式；
		 */		
		private function formatDate(value:Object):String
		{
			if (!RexUtil.ifTextNull(output))
			{
				return DateFormater.dateToString(DateFormater.stringToDate(value.toString(), this.input), this.output);
			}
			
			if (valueDis > MILLISECONDS_IN_MINUTE && valueDis <= MILLISECONDS_IN_HOUR)
			{
				return DateFormater.stringDateToMinuetString(String(value), this.input);
			}
			else if (valueDis > MILLISECONDS_IN_HOUR && valueDis <= MILLISECONDS_IN_DAY)
			{
				return DateFormater.stringDateToTimeString(String(value), this.input);
			}
			else if (valueDis > MILLISECONDS_IN_DAY && valueDis <= MILLISECONDS_IN_MONTH)
			{
				return DateFormater.stringDateToDayString(String(value), this.input);
			}
			else if (valueDis > MILLISECONDS_IN_MONTH && valueDis <= MILLISECONDS_IN_YEAR)
			{
				return DateFormater.stringDateToMonthString(String(value), this.input);
			}
			else if (valueDis > MILLISECONDS_IN_YEAR)
			{
				return DateFormater.stringDateToYearString(String(value), this.input);
			}
			
			return value.toString();
		}
		
		/**
		 * 根据当前的时间跨度计算出合理的单元单位；
		 */		
		private function getMiniInternalUint(dis:Number):String
		{
			if (Math.floor(dis / MILLISECONDS_IN_YEAR) >= miniUnitCount)
			{
				return 'years'
			}
			else if (Math.floor(dis / MILLISECONDS_IN_MONTH) >= miniUnitCount)
			{
				return 'months';
			}
			else if (Math.floor(dis / MILLISECONDS_IN_DAY) >= miniUnitCount)
			{
				return 'days'
			}
			else if (Math.floor(dis / MILLISECONDS_IN_HOUR) >= miniUnitCount)
			{
				return 'hours'
			}
			else if (Math.floor(dis / MILLISECONDS_IN_MINUTE) >= miniUnitCount)
			{
				return 'minutes';
			}
			else
			{
				return 'seconds';
			}
		}
		
		/**
		 * 
		 */		
		private var miniUnitCount:uint = 2;
		
		/**
		 */
		override public function valueToX(value:Object):Number
		{
			return valueToSize(value);
		}

		/**
		 */		
		override public function valueToY(value:Object):Number
		{
			return - valueToSize(value);
		}
		
		/**
		 */
		override protected function valueToSize(value:Object):Number
		{
			var position:Number;
			var timeValue:Number = stringDateToDateTimer(value);
			position = (timeValue - minimum) / valueDis * size;

			if (this.inverse)
				position = this.size - position;
				
			return position;
		}
		
		/**
		 * 将毫秒类型的时间对象转化为时间轴上的字符串标签；
		 */		
		private function dateTimerToLabel(value:Object):String
		{
			var date:Date = new Date();
			date.setTime(value);
			return DateFormater.dateToString(date, this.input);;
		}
		
		/**
		 * 将字符串转换为毫秒类型的时间；
		 */
		private function stringDateToDateTimer(value:Object):Number
		{
			var date:Date = DateFormater.stringToDate(value.toString(), this.input);
			return date.getTime();
		}
		
		/**
		 */		
		private function roundDateUp(d:Date,units:String):void
		{
			switch (units)
			{
				case "seconds":
					if (d[millisecondsP] > 0)
					{
						d[secondsP] = d[secondsP] + 1;
						d[millisecondsP] = 0;
					}
					break;
				case "minutes":
					if (d[secondsP] > 0 || d[millisecondsP] > 0)
					{
						d[minutesP] = d[minutesP] + 1;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
					}
					break;
				case "hours":
					if (d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = d[hoursP] + 1;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
					}
					break;
				case "days":
					if (d[hoursP] > 0 ||
						d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = 0;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
						d[dateP] = d[dateP] + 1;                                        
					}
					break;
				d[hoursP] = 0;
				d[minutesP] = 0;
				d[secondsP] = 0;
				d[millisecondsP] = 0;
				break;          
				case "weeks":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					if (d[dayP] != 0)
						d[dateP] = d[dateP] + (7 - d[dayP]);
					break;          
				case "months":
					if (d[dateP] > 1 ||
						d[hoursP] > 0 ||
						d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = 0;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
						d[dateP] = 1;
						d[monthP] = d[monthP] + 1;
					}
					break;
				case "years":
					if (d[monthP] > 0 ||
						d[dateP] > 1 ||
						d[hoursP] > 0 ||
						d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = 0;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
						d[dateP] = 1;
						d[monthP] = 0;
						d[fullYearP] = d[fullYearP] + 1;
					}
					break;
			}                                                                           
		}
		private function roundDateDown(d:Date,units:String):void
		{
			switch (units)
			{
				case "seconds":
					d[secondsP] = 0;
					break;
				case "minutes":
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					break;
				case "hours":
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					break;
				case "days":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					break;
				case "weeks":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					if (d[dayP] != 0)
						d[dateP] = d[dateP] - d[dayP];
					break;
				case "months":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					d[dateP] = 1;
					break;
				case "years":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					d[dateP] = 1;
					d[monthP] = 0;
					break;  
			}
		}
		
		/**
		 */		
		private function toMilli(v:Number, unit:String):Number
		{
			switch (unit)
			{
				case "milliseconds":
				{
					return v;
				}
					
				case "seconds":
				{
					return v * 1000;
				}
					
				case "minutes":
				{
					return v * MILLISECONDS_IN_MINUTE;
				}
					
				case "hours":
				{
					return v * MILLISECONDS_IN_HOUR;
				}
					
				case "weeks":
				{
					return v * MILLISECONDS_IN_WEEK;
				}
					
				case "months":
				{
					return v * MILLISECONDS_IN_MONTH;
				}
					
				case "years":
				{
					return v * MILLISECONDS_IN_YEAR;
				}
					
				case "days":
				default:
				{
					return v * MILLISECONDS_IN_DAY;
				}
			}
		}
		
		/**
		 *  @private
		 */
		private var millisecondsP:String;
		
		/**
		 *  @private
		 */
		private var secondsP:String;
		
		/**
		 *  @private
		 */
		private var minutesP:String;
		
		/**
		 *  @private
		 */
		private var hoursP:String;
		
		/**
		 *  @private
		 */
		private var dateP:String;
		
		/**
		 *  @private
		 */
		private var dayP:String;
		
		/**
		 *  @private
		 */
		private var monthP:String;
		
		/**
		 *  @private
		 */
		private var fullYearP:String;
		
		/**
		 *  @private
		 */
		private static const MILLISECONDS_IN_MINUTE:Number = 1000 * 60;
		
		/**
		 *  @private
		 */
		private static const MILLISECONDS_IN_HOUR:Number = 1000 * 60 * 60;
		
		/**
		 *  @private
		 */
		private static const MILLISECONDS_IN_DAY:Number = 1000 * 60 * 60 * 24;
		
		/**
		 *  @private
		 */
		private static const MILLISECONDS_IN_WEEK:Number = 1000 * 60 * 60 * 24 * 7;
		
		/**
		 *  @private
		 */
		private static const MILLISECONDS_IN_MONTH:Number = 1000 * 60 * 60 * 24 * 30;
		
		/**
		 *  @private
		 */
		private static const MILLISECONDS_IN_YEAR:Number = 1000 * 60 * 60 * 24 * 365;
		
		/**
		 */		
		private var UNIT_PROGRESSION:Object =
		{
			milliseconds: null,
			seconds: "milliseconds",
			minutes: "seconds",
			hours: "minutes",
			days: "hours",
			weeks: "days",
			months: "weeks",
			years: "months"
		};

		/**
		 */
		override protected function get type():String
		{
			return AxisBase.DATE_AXIS;
		}
	}
}