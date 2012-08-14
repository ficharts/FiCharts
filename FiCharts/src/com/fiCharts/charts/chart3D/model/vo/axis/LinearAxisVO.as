package com.fiCharts.charts.chart3D.model.vo.axis
{
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.utils.MathUtil;
	
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;
	
	/**
	 */	
	public class LinearAxisVO extends AxisBaseVO
	{
		public function LinearAxisVO()
		{
			super();
		}
		
		/**
		 */		
		override public function formatXValue(value:Object):String
		{
			return dataFormatter.formatXNumber(value); 
		}
		
		override public function formatYValue(value:Object):String
		{
			return dataFormatter.formatYNumber(value);
		}
		
		
		
		//--------------------------------------------------------
		//
		// 生成坐标显示标签
		//
		//--------------------------------------------------------

		/**
		 */		
		override public function layoutHorizontalLabels() : void
		{
			this._ticks = new Vector.<Number>;
			for each (var labelVO:AxisLabelVO in this.labels)
			{
				labelVO.x = valueToSize(labelVO.value);
				labelVO.y = gutter + labelOffSet;
				_ticks.push(labelVO.x);
			}
		}
		
		/**
		 */		
		override public function layoutVerticalLabels() : void
		{
			this._ticks = new Vector.<Number>;
			for each (var labelVO:AxisLabelVO in this.labels)
			{
				labelVO.x = - gutter - labelOffSet;
				labelVO.y = - valueToSize(labelVO.value);
				_ticks.push(labelVO.y);
			}
		}
		
		
		
		//------------------------------------------------------
		//
		//  坐标数值范围确定及划单元尺寸划分
		//
		//------------------------------------------------------
		
		
		/**
		 */		
		override public function redyToUpdateData():void
		{
			dataValue = new Vector.<Object>();
		}
		
		/**
		 */		
		private var dataValue:Vector.<Object>;
		
		/**
		 * @param value
		 */		
		override public function updateData(value:Vector.<Object>) : void
		{
			dataValue = dataValue.concat(value);
		}
		
		/**
		 */		
		override public function dataUpdated():void
		{
			dataValue.sort(compareFunction);
			
			var temMin:Number;
			var temMax:Number;
			var margin:Number;
			
			if (!isNaN(assignedMinimum))
				temMin = assignedMinimum;
			if (!isNaN(assignedMaximum))
				temMax = assignedMaximum;
			
			// 没有设置最大最小值时则从系统数据获取；
			var autoGen:Boolean = isNaN(assignedMinimum) ||
				isNaN(assignedMaximum);
			
			if (autoGen)
			{
				// 单值的情况；
				if (dataValue.length == 1)
				{
					temMin = temMax = dataValue.pop();
					if (temMax > 0)
						temMin = 0;
					else if (temMax < 0)
						temMax = 0;
				}
				else// 多值的情况
				{
					temMin  = dataValue.shift();
					temMax = dataValue.pop();
				}
			}
			
			//基于零点优先于最值设置；
			if (baseAtZero)
			{
				if (temMax > 0)
					temMin = 0;
				else if (temMax < 0)
					temMax = 0;
			}
			
			var powerOfTen:Number =
				Math.floor(Math.log(Math.abs(temMax - temMin)) / Math.LN10)
			
			var temUserInterval:Number;
			
			if (isNaN(_userInterval))
			{
				temUserInterval = Math.pow(10, powerOfTen);
				
				if (Math.abs(temMax - temMin) / temUserInterval < 4)
					temUserInterval = temUserInterval / 5; 
			}
			else
			{
				temUserInterval = _userInterval;
			}
			
			sourceMax = this._maximum =
				Math.round(temMax / temUserInterval) * temUserInterval == temMax ?
				temMax :
				(Math.floor(temMax / temUserInterval) + 1) * temUserInterval;
			
			sourceMin = this._minimum = Math.floor(temMin / temUserInterval) * temUserInterval;
			
			this.interval = computedInterval = temUserInterval;
		}
		
		/**
		 */		
		private var sourceMax:Number;
		private var sourceMin:Number;
		
		/**
		 * 设置最小刻度值和分割数；
		 */		
		override public function generateAxisLabelVO():void
		{
			//最小单位值
			var minUintValue:Number = 0;
			if (minUintSize <= size)
				minUintValue = Math.max(minUintSize / size * valueRange, valueRange / maxDepartLineAmount);
			else
				minUintValue = valueRange;                                             
			
			var internalAmount:Number = this.valueRange / this.computedInterval;
			for (var amoutInternal:uint = 1; amoutInternal < internalAmount; amoutInternal ++)
			{
				interval = computedInterval * amoutInternal;
				if (interval >= minUintValue && interval <= valueRange)
					break;
			}
			
			// 调节恰到好处的最值，刚好满足均分 
			if (sourceMin * sourceMax < 0)
			{
				_maximum = sourceMin + Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
				_maximum += interval / 2;
				_minimum = sourceMin - interval / 2;
			}
			else if (sourceMax >= 0)
			{
				_maximum = sourceMin + Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
				_maximum += interval;
			}
			else 
			{
				_minimum = sourceMax - Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
				_minimum -= interval;
			}
			
			// 生成坐标标签；
			labels = new Vector.<AxisLabelVO>;
			var labelVO:AxisLabelVO;
			for (var i:Number = _minimum; i <= _maximum; i += interval)
			{
				labelVO = new AxisLabelVO();
				labelVO.value = i;
				labelVO.label = dataFormatter.formatYNumber(labelVO.value);
				labels.push(labelVO);
			}
			
			this.unitSize = size / labels.length;
		}
		
		/**
		 * 用户设置的最小刻度值；
		 */		
		private var _userInterval:Number;
		public function set userInterval(value:Number):void
		{
			_userInterval = value;	
		}
		
		public function get userInterval():Number
		{
			return _userInterval;
		}
		
		private var _interval : Number;
		public function get interval():Number
		{
			return _interval;
		}
		
		/**
		 * 根据最小刻度尺寸计算得出的单位刻度值；
		 */
		public function set interval(v:Number):void
		{
			_interval = v;
		}
		
		/**
		 * 最小单位刻度值； 
		 */		
		private  var computedInterval:Number;
		
		/**
		 * 最小刻度所占的距离长度；
		 */		
		private var minUintSize:uint = 30;
		
		/**
		 * 最大单元格数量；
		 */		
		private var maxDepartLineAmount:uint = 10;
		
		/**
		 */		
		private function compareFunction(small:Number, large:Number):int
		{
			if (small > large) return 1;
			else if (small < large) return - 1;
			return 0;
		}
		
		/**
		 * @param value
		 * @return 
		 */		
		override public function valueToSize(value:Object):Number
		{
			var resultSize:Number;
			
			if (valueRange)
				resultSize = ( Number( value ) - minimum ) / valueRange * size;
			else
				resultSize = 0;
			
			return resultSize;
		}
		
		/**
		 * @return 
		 */		
		protected function get valueRange():Number
		{
			return maximum - minimum;
		}
		
		/**
		 */		
		private var _minimum:Number = 0;
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			assignedMinimum = value;
		}
		
		/**
		 */
		private var _maximum:Number = 0;
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			assignedMaximum = value;
		}
		
		/**
		 */		
		private var assignedMinimum:Number;
		private var assignedMaximum:Number;
		
		/**
		 */		
		private var _baseAtZero:uint = 0;

		public function get baseAtZero():uint
		{
			return _baseAtZero;
		}

		public function set baseAtZero(value:uint):void
		{
			_baseAtZero = value;
		}

	}
}