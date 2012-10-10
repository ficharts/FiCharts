package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.ui.text.Label;
	import com.fiCharts.utils.MathUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;

	/**
	 */	
	public class LinearAxis extends AxisBase
	{
		/**
		 * Constructor.
		 */
		public function LinearAxis()
		{
			super();
		}
		
		/**
		 */		
		override public function getXLabel(value:Object):String
		{
			return dataFormatter.formatXNumber(value);
		}
		
		override public function getYLabel(value:Object):String
		{
			return dataFormatter.formatYNumber(value);
		}
		
		override public function getZLabel(value:Object):String
		{
			return dataFormatter.formatZNumber(value);
		}
		
		/**
		 * Push the values of axis and count the maxValue/minValue
		 * @param values
		 */
		override public function pushValues(values:Vector.<Object>):void
		{
			sourceValues = sourceValues.concat(values);
		}
		
		/**
		 */		
		override public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
			
			seriesData.sort(Array.NUMERIC);
			
			// 单值的情况；
			if (seriesData.length == 1)
			{
				seriesDataFeature.maxValue = seriesDataFeature.minValue = seriesData.pop();
			}
			else // 多值的情况
			{
				seriesDataFeature.minValue = seriesData.shift();
				seriesDataFeature.maxValue = seriesData.pop();
			}
			
			return seriesDataFeature;
		}
		
		/**
		 * 坐标轴是否自动调节最大值与最小值， 默认开启；
		 */		
		private var _autoAdjust:Boolean = true;

		/**
		 */
		public function get autoAdjust():Boolean
		{
			return _autoAdjust;
		}

		/**
		 * @private
		 */
		public function set autoAdjust(value:Boolean):void
		{
			_autoAdjust = value;
		}

		/**
		 * 确定最大最小值；
		 */		
		override public function dataUpdated():void
		{
			sourceValues.sort(Array.NUMERIC);
			
			var temMin:Number;
			var temMax:Number;
			
			if (!isNaN(assignedMinimum))
				temMin = assignedMinimum;
			else
				temMin = sourceValues.concat().shift();
			
			if (!isNaN(assignedMaximum))
				temMax = assignedMaximum;
			else
				temMax = sourceValues.concat().pop();
			
			// 单值的情况；
			if (sourceValues.length == 1)
				temMin = temMax = sourceValues.concat().pop();
			
			if (autoAdjust == false)
			{
				_maximum = temMax;
				_minimum = temMin;
					
				this.changed = false;
				return; 
			}
			
			//基于零点优先于最值设置；
			if (baseAtZero && temMin * temMax >= 0)
			{
				if (temMax > 0)
					temMin = 0;
				else if (temMax < 0)
					temMax = 0;
			}
			
			var powerOfTen:Number = Math.floor(Math.log(Math.abs(temMax - temMin)) / Math.LN10);
			var y_userInterval:Number;
			
			if (isNaN(_userInterval))
			{
				y_userInterval = Math.pow(10, powerOfTen);
				
				if (Math.abs(temMax - temMin) / y_userInterval < 4)
				{
					y_userInterval = y_userInterval / 5;
				}
			}
			else
			{
				y_userInterval = _userInterval;
			}
			
			sourceMax = _maximum = Math.round(temMax / y_userInterval) * y_userInterval == temMax ? temMax : (Math.floor(temMax / y_userInterval) + 1) * y_userInterval;
			sourceMin = _minimum = Math.floor(temMin / y_userInterval) * y_userInterval;
			
			interval = computedInterval = y_userInterval;
			
			super.dataUpdated();
		}
		
		/**
		 */		
		protected var sourceMax:Number;
		protected var sourceMin:Number;
		
		/**
		 * 设置最小刻度值和分割数， 渲染之前调用;
		 */		
		override public function updateAxis():void
		{
			if (changed)
			{
				//最小单位值
				var minUintValue:Number = 0;
				if (horiMinUintSize <= size)
					minUintValue = Math.max(horiMinUintSize / size * valueDis, valueDis / maxDepartLineAmount);
				else
					minUintValue = valueDis;
				
				var internalAmount:Number = this.valueDis / this.computedInterval;
				for (var amoutInternal:uint = 1; amoutInternal <= internalAmount; amoutInternal++)
				{
					interval = computedInterval * amoutInternal;
					if (interval >= minUintValue && interval <= valueDis)
						break;
				}
				
				// 调节恰到好处的最值，刚好满足均分 
				if (sourceMin * sourceMax < 0)
				{
					_maximum = sourceMin + Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
					
					if (ifExpend)
					{
						_maximum += interval;
						_minimum = sourceMin - interval;
					}
					/*else
					{
						_maximum += interval / 2;
						_minimum = sourceMin - interval / 2;
					}*/
				}
				else if (sourceMax > 0)
				{
					_maximum = sourceMin + Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
					
					if (ifExpend)
						_maximum += interval;
				}
				else if (sourceMax == 0)
				{
					//_maximum = sourceMin + Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
					
					_minimum = sourceMax - Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
					if (ifExpend)
						_minimum -= interval;
				}
				else 
				{
					_minimum = sourceMax - Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
					
					if (ifExpend)
						_minimum -= interval;
				}
				
				var labelData:AxisLabelData;
				labelsData = new Vector.<AxisLabelData>;
				
				//// Flash 中数字计算精度有偏差, 防止与最值及其相近的值蒙混过关
				var maxValue:Number = _maximum + interval - interval / 100000;
				for (var i:Number = _minimum; i < maxValue; i += interval)
				{
					labelData = new AxisLabelData();
					labelData.value = i;
					labelsData.push(labelData);
				}
			}
		}
		
		/**
		 * 再启用数值显示的时候需要增多一个数据单元格以便放得下数值显示；
		 */		
		private var _ifExpend:Boolean = false;

		/**
		 */
		public function get ifExpend():Boolean
		{
			return _ifExpend;
		}

		/**
		 * @private
		 */
		public function set ifExpend(value:Boolean):void
		{
			_ifExpend = value;
		}


		/**
		 * temp value
		 */
		protected var assignedMinimum:Number;
		protected var assignedMaximum:Number;

		/**
		 * 最大单元格数量；
		 */
		protected var maxDepartLineAmount:uint = 10;

		/**
		 * 轴步长
		 * (可由用户设置)
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

		/**
		 * 计算步长
		 * (自动计算出的步长)
		 */
		protected var computedInterval:Number;

		/**
		 *  Axis has it's own data model different from default data value.
		 *  For example, date axis's axis data format is Number,
		 *  but it's data value is String like '2009-01-01'.
		 */
		protected function axisValueToX(value:Object):Number
		{
			return axisValueToSize(value);
		}

		protected function axisValueToY(value:Object):Number
		{
			return - axisValueToSize(value);
		}
		
		/**
		 */
		protected function axisValueToSize(value:Object):Number
		{
			var position:Number;
			
			if (valueDis)
				position = getValuePercent(value) * size;
			else
				position = 0;
			
			if (this.inverse)
				position = this.size - position;

			return position;
		}
		
		/**
		 */		
		private function getValuePercent(value:Object):Number
		{
			if (value == null)
				return 0;
			else
				return (Number(value) - minimum) / valueDis;
		}

		/**
		 * @param value
		 * @return
		 */
		override public function valueToX(value:Object):Number
		{
			return axisValueToX(value);
		}

		/**
		 */
		override public function valueToY(value:Object):Number
		{
			return axisValueToY(value);
		}
		
		/**
		 */		
		override public function valueToZ(value:Object):Number
		{
			return this.getValuePercent(value);
		}

		/**
		 */
		override protected function get type():String
		{
			return AxisBase.LINER_AXIS;
		}

		/**
		 */
		protected function get valueDis():Number
		{
			return (maximum - minimum);
		}

		/**
		 */
		protected var _minimum:Number = 0;

		public function get minimum():Number
		{
			return _minimum;
		}

		public function set minimum(v:Number):void
		{
			assignedMinimum = v;
		}

		/**
		 */
		protected var _maximum:Number = 0;

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(v:Number):void
		{
			assignedMaximum = v;
		}

		/**
		 *  An opposite value indicate labels distance.
		 *  This value is from o to 1, for example, .1 indicate this axis will contain 10 labels.
		 */
		private var _interval:Number = .2;

		public function get interval():Number
		{
			return _interval;
		}

		/**
		 */
		public function set interval(v:Number):void
		{
			_interval = v;
		}

		/**
		 */
		private var _baseAtZero:Boolean = true;

		public function get baseAtZero():Object
		{
			return _baseAtZero;
		}

		public function set baseAtZero(v:Object):void
		{
			_baseAtZero = XMLVOMapper.boolean(v);
		}
	}
}