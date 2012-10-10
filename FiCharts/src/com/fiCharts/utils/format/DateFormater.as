package com.fiCharts.utils.format
{
	public class DateFormater
	{
		public function DateFormater()
		{
		}
		
		/**
		 */		
		public static function stringDateToYearString(value:String, format:String):String
		{
			var date:Date = stringToDate(value, format);
			return dateToString(date, 'YYYY');
		}
		
		/**
		 */		
		public static function stringDateToMonthString(value:String, format:String):String
		{
			var date:Date = stringToDate(value, format);
			return formatTime(date.getMonth() + 1) + '/' + dateToString(date, 'YYYY');
		}
		
		/**
		 */		
		public static function stringDateToDayString(value:String, format:String):String
		{
			var date:Date = stringToDate(value, format);
			
			return formatTime(date.getDate()) + '/' + formatTime(date.getMonth() + 1)
		}
			
		/**
		 * 将一个字符串类型的时间转换为仅剩小时分格式；
		 */		
		public static function stringDateToTimeString(value:String, format:String):String
		{
			return dateToTimeString(stringToDate(value, format));
		}
		
		/**
		 * 将一个字符串类型的时间转换为仅剩分秒类型；
		 */		
		public static function stringDateToMinuetString(value:String, format:String):String
		{
			var date:Date = stringToDate(value, format);
			
			return formatTime(date.getMinutes()) + " 00'";
		}
		
		/**
		 */		
		public static function dateToTimeString(date:Date):String
		{
			return formatTime(date.getHours()) + ":" + formatTime(date.getMinutes());
		}
		
		/**
		 */		
		public static function timeStringToDate(date:Date, timeString:String):void
		{
			var fullTime:Array = timeString.split(":");
			
			if (fullTime.length == 2)
				date.setHours(fullTime[0], fullTime[1]);
		}
		
		/**
		 */		
		private static function formatTime(value:Number):String
		{
			if (value < 10)
				return "0" + value.toString();
			
			return value.toString();
		}
		
		/**
		 */		
		public static function stringToDate(valueString:String, inputFormat:String):Date
		{
			var mask:String
			var temp:String;
			
			var secondString:String = "";
			var minString:String = "";
			var hourString:String = ""
			var dateString:String = "";
			var monthString:String = "";
			var yearString:String = "";
			
			var j:int = 0;
			
			var n:int = inputFormat.length;
			for (var i:int = 0; i < n; i++,j++)
			{
				temp = "" + valueString.charAt(j);
				mask = "" + inputFormat.charAt(i);
				
				if (mask == "M")
				{
					if (isNaN(Number(temp)) || temp == " ")
						j--;
					else
						monthString += temp;
				}
				else if (mask == "D")
				{
					if (isNaN(Number(temp)) || temp == " ")
						j--;
					else
						dateString += temp;
				}
				else if (mask == 'h')
				{
					if (isNaN(Number(temp)) || temp == " ")
						j--;
					else
						hourString += temp;
				}
				else if (mask == 'm')
				{
					if (isNaN(Number(temp)) || temp == " ")
						j--;
					else
						minString += temp;
				}
				else if (mask == 's')
				{
					if (isNaN(Number(temp)) || temp == " ")
						j--;
					else
						secondString += temp;
				}
				else if (mask == "Y")
				{
					yearString += temp;
				}
				else if (!isNaN(Number(temp)) && temp != " ")
				{
					return null;
				}
			}
			
			temp = "" + valueString.charAt(inputFormat.length - i + j);
			if (!(temp == "") && (temp != " "))
				return null;
			
			var monthNum:Number = Number(monthString);
			var dayNum:Number = Number(dateString);
			var yearNum:Number = Number(yearString);
			
			var hourNum:Number = Number(hourString);
			var minNum:Number = Number(minString);
			var secondNum:Number = Number(secondString);
			
			//if (isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
			//	return null;
			
			if (dayNum == 0)
				dayNum = 1;
			
			if (yearNum == 0)
				yearNum = 2010;
			
			if (monthNum == 0)
				monthNum = 1;
			
			if (yearString.length == 2 && yearNum < 70)
				yearNum+=2000;
			
			var newDate:Date = new Date(yearNum, monthNum - 1, dayNum, hourNum, minNum, secondNum);
			
			if (dayNum != newDate.getDate() || (monthNum - 1) != newDate.getMonth())
				return null;
			
			return newDate;
		}
		
		/**
		 * 
		 * @param value
		 * @param outputFormat
		 * @return 
		 * 
		 */		
		public static function dateToString(value:Date, outputFormat:String):String
		{
			if (!value)
				return "";
			
			var date:String = String(value.getDate());
			if (date.length < 2)
				date = "0" + date;
			
			var month:String = String(value.getMonth() + 1);
			if (month.length < 2)
				month = "0" + month;
			
			var hour:String = String(value.getHours());
			if (hour.length < 2)
				hour = "0" + hour;
			
			var min:String = String(value.getMinutes());
			if (min.length < 2)
				min = "0" + min;
			
			var second:String = String(value.getSeconds());
			if (second.length < 2)
				second = "0" + second;
			
			var year:String = String(value.getFullYear());
			
			var output:String = "";
			var mask:String;
			
			// outputFormat will be null if there are no resources.
			var n:int = outputFormat != null ? outputFormat.length : 0;
			for (var i:int = 0; i < n; i++)
			{
				mask = outputFormat.charAt(i);
				
				if (mask == "M")
				{
					output += month;
					i++;
				}
				else if (mask == "D")
				{
					output += date;
					i++;
				}
				else if (mask == "h")
				{
					output += hour;
					i++;
				}
				else if (mask == "m")
				{
					output += min;
					i++;
				}
				else if (mask == "s")
				{
					output += second;
					i++;
				}
				else if (mask == "Y")
				{
					if (outputFormat.charAt(i+2) == "Y")
					{
						output += year;
						i += 3;
					}
					else
					{
						output += year.substring(2,4);
						i++;
					}
				}
				else
				{
					output += mask;
				}
			}
			
			return output;
		}
	}
}