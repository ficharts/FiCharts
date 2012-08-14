package com.fiCharts.charts.chart2D.pie
{
	import com.fiCharts.charts.common.ChartDataFormatter;
	
	public class PieDataFormatter extends ChartDataFormatter
	{
		public function PieDataFormatter()
		{
			super();
		}
		
		/**
		 */		
		public function formatLabel(value:Object):String
		{
			return this.labelPrefix + value + this.labelSuffix;
		}
		
		/**
		 */		
		public function formatValue(value:Object):String
		{
			var result:Number = Number(value);
			if (result >= 0)
				return valuePrefix.concat(formatter.formatNumber(result), valueSuffix);
			else
				return "-".concat(valuePrefix, formatter.formatNumber(- result), valueSuffix);
		}
		
		/**
		 */		
		private var _valuePrefix:String = '';
		
		public function get valuePrefix():String
		{
			return _valuePrefix;
		}
		
		public function set valuePrefix(value:String):void
		{
			_valuePrefix = value;
		}
		
		/**
		 */		
		private var _valueSuffix:String = '';
		
		public function get valueSuffix():String
		{
			return _valueSuffix;
		}
		
		public function set valueSuffix(value:String):void
		{
			_valueSuffix = value;
		}
		
		/**
		 */		
		private var _labelPrefix:String = '';
		
		public function get labelPrefix():String
		{
			return _labelPrefix;
		}
		
		public function set labelPrefix(value:String):void
		{
			_labelPrefix = value;
		}
		
		/**
		 */		
		private var _labelSuffix:String = '';
		
		public function get labelSuffix():String
		{
			return _labelSuffix;
		}
		
		public function set labelSuffix(value:String):void
		{
			_labelSuffix = value;
		}
	}
}