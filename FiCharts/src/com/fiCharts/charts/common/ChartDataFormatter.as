package com.fiCharts.charts.common
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;

	/**
	 */	
	public class ChartDataFormatter
	{
		public function ChartDataFormatter()
		{
			// 显示小数点前面的0；
			formatter.leadingZero = true;
			
			//关闭群组；
			formatter.useGrouping = false;
			
			formatter.fractionalDigits = precision;
		}
		
		/**
		 */		
		public function formatXString(value:Object):String
		{
			return this.xPrefix.concat(value, xSuffix);
		}
		
		public function formatYString(value:Object):String
		{
			return this.yPrefix.concat(value, ySuffix);
		}
		
		/**
		 */		
		public function formatXNumber(value:Object):String
		{
			var result:Number = Number(value);
			if (result >= 0)
				return xPrefix + formatter.formatNumber(result) + xSuffix;
			else
				return "-".concat(xPrefix, formatter.formatNumber(- result), xSuffix);
		}
		
		/**
		 */		
		public function formatYNumber(value:Object):String
		{
			var result:Number = Number(value);
			if (result >= 0)
				return yPrefix.concat(formatter.formatNumber(result), ySuffix);
			else
				return "-".concat(yPrefix, formatter.formatNumber(- result), ySuffix);
		}
		
		/**
		 */		
		public function formatZNumber(value:Object):String
		{
			var result:Number = Number(value);
			if (result >= 0)
				return zPrefix.concat(formatter.formatNumber(result), zSuffix);
			else
				return "-".concat(zPrefix, formatter.formatNumber(- result), zSuffix);
		}
		
		/**
		 * 仅仅格式化数据， 设置小数点精确位;
		 */		
		public function precisionValue(value:Object):String
		{
			return formatter.formatNumber(Number(value));
		}
		
		/**
		 */		
		private var _precision:Number = 0;
		
		/**
		 */
		public function get precision():Number
		{
			return _precision;
		}
		
		/**
		 * @private
		 */
		public function set precision(value:Number):void
		{
			_precision = value;
			formatter.fractionalDigits = _precision;
		}
		
		/**
		 */		
		private var _useGrouping:Boolean = false;

		public function get useGrouping():Object
		{
			return _useGrouping;
		}

		public function set useGrouping(value:Object):void
		{
			_useGrouping = XMLVOMapper.boolean(value);
			formatter.useGrouping = _useGrouping			
		}

		/**
		 */		
		protected var formatter:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);
		
		/**
		 */		
		private var _xSuffix:String = "";
		
		public function get xSuffix():String
		{
			return _xSuffix;
		}
		
		public function set xSuffix(value:String):void
		{
			_xSuffix = value;
		}
		
		/**
		 */		
		private var _ySuffix:String = "";
		
		public function get ySuffix():String
		{
			return _ySuffix;
		}
		
		public function set ySuffix(value:String):void
		{
			_ySuffix = value;
		}
		
		/**
		 */		
		private var _zSuffix:String= ""

		public function get zSuffix():String
		{
			return _zSuffix;
		}

		public function set zSuffix(value:String):void
		{
			_zSuffix = value;
		}

		private var _xPrefix:String = "";
		
		/**
		 */
		public function get xPrefix():String
		{
			return _xPrefix;
		}
		
		/**
		 * @private
		 */
		public function set xPrefix(value:String):void
		{
			_xPrefix = value;
		}
		
		private var _yPrefix:String = "";
		
		public function get yPrefix():String
		{
			return _yPrefix;
		}
		
		public function set yPrefix(value:String):void
		{
			_yPrefix = value;
		}
		
		/**
		 */		
		private var _zPrefix:String = "";

		public function get zPrefix():String
		{
			return _zPrefix;
		}

		public function set zPrefix(value:String):void
		{
			_zPrefix = value;
		}

	}
}