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
			return this.yPrefix;
		}
		
		public function set valuePrefix(value:String):void
		{
			yPrefix = value;
		}
		
		/**
		 */		
		private var _valueSuffix:String = '';
		
		public function get valueSuffix():String
		{
			return this.ySuffix;
		}
		
		public function set valueSuffix(value:String):void
		{
			ySuffix = value;
		}
		
		/**
		 */		
		private var _labelPrefix:String = '';
		
		public function get labelPrefix():String
		{
			return this.xPrefix;
		}
		
		public function set labelPrefix(value:String):void
		{
			xPrefix = value;
		}
		
		/**
		 */		
		private var _labelSuffix:String = '';
		
		public function get labelSuffix():String
		{
			return this.xSuffix;
		}
		
		public function set labelSuffix(value:String):void
		{
			xSuffix = value;
		}
	}
}