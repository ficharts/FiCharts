package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.utils.ArrayUtil;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.BitmapData;

	/**
	 * 
	 * 线性坐标轴，数据线性分布，坐标位置根据数据线性关系分布
	 * 
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
		override public function clone():AxisBase
		{
			var axis:LinearAxis = new LinearAxis;
			initClone(axis);
			
			return axis;
		}
		
		/**
		 * 原始数据序列化后的间距
		 */		
		internal  var confirmedSourceValueDis:Number = 0;
		
		/**
		 */		
		override internal function getNormalPatter():IAxisPattern
		{
			return new LinearAxis_Normal(this);
		}
		
		/**
		 */		
		override internal function getZoomPattern():IAxisPattern
		{
			return new LinearAxis_DataScale(this);
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
			var item:Number, i:uint = sourceValues.length;
			for each (item in values)
			{
				sourceValues[i] = item;
				i ++;				
			}
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
			ArrayUtil.removeDubItem(sourceValues);
			sourceValues.sort(Array.NUMERIC);
			
			if (!isNaN(assignedMinimum))
				sourceMin = assignedMinimum;
			else
				sourceMin = Number(sourceValues[0]);
			
			if (!isNaN(assignedMaximum))
				sourceMax = assignedMaximum;
			else
				sourceMax = Number(sourceValues[sourceValues.length - 1]);
			
			// 单值的情况；
			if (sourceValues.length == 1)
				sourceMin = sourceMax = Number(sourceValues[0]);
			
			if (autoAdjust == false)
			{
				_maximum = sourceMax;
				_minimum = sourceMin;
					
				this.changed = false;
				
				// 气泡图的控制气泡大小的轴无需渲染，原始刻度间距即为确认的间距
				sourceValueDis = _maximum - _minimum;
				return; 
			}
			
			//基于零点优先于最值设置；
			baseZero();
			
			sourceValueDis = sourceMax - sourceMin;
			
			super.dataUpdated();
		}
		
		/**
		 * 根据全局数据范围创建刻度数据
		 * 
		 * 不同模式的坐标轴数据都是通过这里构建
		 */		
		internal function createLabelsData(max:Number, min:Number):void
		{
			var labelData:AxisLabelData;
			labelVOes.length = labelUIs.length = labelValues.length = 0;
			
			//// Flash 中数字计算精度有偏差, 防止与最值及其相近的值蒙混过关
			var maxValue:Number = max + interval - interval / 100000;
			var j:uint = 0;
			// internal 会随当前数值范围而变， 数据缩放时需重新计算labelData
			for (var i:Number = min; i < maxValue; i += interval)
			{
				labelData = new AxisLabelData();
				labelData.value = i;
				labelVOes[j] = labelData;
				labelValues[j] = i;
				
				j ++;
			}
		}
		
		/**
		 */		
		internal var labelValues:Array = [];
		
		/**
		 * 与判定最大最小值
		 */		
		internal function preMaxMin(max:Number, min:Number):void
		{
			var preDataDis:Number = max - min;
			var powerOfTen:Number = Math.floor(Math.log(Math.abs(preDataDis)) / Math.LN10);
			var y_userInterval:Number;
			
			if (isNaN(_userInterval))
			{
				y_userInterval = Math.pow(10, powerOfTen);
				
				if (Math.abs(preDataDis) / y_userInterval < 4)
				{
					y_userInterval = y_userInterval / 5;
				}
			}
			else
			{
				y_userInterval = _userInterval;
			}
			
			_maximum = preMax = Math.round(max / y_userInterval) * y_userInterval == max ? max : (Math.floor(max / y_userInterval) + 1) * y_userInterval;
			_minimum = preMin = Math.floor(min / y_userInterval) * y_userInterval;
			
			preInterval = y_userInterval;
		}
		
		/**
		 * 核定，确定最大最小值
		 */		
		internal function confirmMaxMin(axisLen:Number):void
		{
			var preValueDis:Number = preMax - preMin;
			
			//最小单位值
			var minUintValue:Number = 0;
			if (temUintSize <= size)
				minUintValue = Math.max(temUintSize / axisLen * preValueDis, preValueDis / maxDepartLineAmount);
			else
				minUintValue = preValueDis;
			
			var internalAmount:Number = preValueDis / this.preInterval;
			for (var amoutInternal:uint = 1; amoutInternal <= internalAmount; amoutInternal++)
			{
				interval = preInterval * amoutInternal;
				if (interval >= minUintValue && interval <= preValueDis)
					break;
			}
			
			// 调节恰到好处的最值，刚好满足均分 
			if (preMin * preMax < 0)
			{
				_maximum = preMin + Math.ceil(preValueDis/ interval) * interval;
				
				if (ifExpend)
				{
					_maximum += interval;
					_minimum = preMin - interval;
				}
				/*else
				{
				_maximum += interval / 2;
				_minimum = sourceMin - interval / 2;
				}*/
			}
			else if (preMax > 0)
			{
				_maximum = preMin + Math.ceil(preValueDis/ interval) * interval;
				
				if (ifExpend)
					_maximum += interval;
			}
			else if (preMax == 0)
			{
				//_maximum = sourceMin + Math.ceil((sourceMax -  sourceMin)/ interval) * interval;
				
				_minimum = preMax - Math.ceil(preValueDis/ interval) * interval;
				if (ifExpend)
					_minimum -= interval;
			}
			else 
			{
				_minimum = preMax - Math.ceil(preValueDis/ interval) * interval;
				
				if (ifExpend)
					_minimum -= interval;
			}
			
		}
		
		/**
		 * 原始数据间距
		 */		
		internal var sourceValueDis:Number;
		
		/**
		 * 
		 * 原始值的最大最小值
		 */		
		internal var sourceMax:Number = 0;
		internal var sourceMin:Number = 0;
		
		/**
		 * 违背核定的最值
		 */		
		protected var preMax:Number;
		protected var preMin:Number;
		
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
		 * 初步计算得到的步长， 还需根据最小刻度尺寸才能计算出最终的步长  interval
		 */
		protected var preInterval:Number;

		/**
		 */		
		override protected function valueToSize(value:Object, index:uint):Number
		{
			return this.curPattern.valueToSize(value, index);
		}
		
		/**
		 * @param value
		 * @return
		 */
		override public function valueToX(value:Object, index:uint):Number
		{
			return valueToSize(value, index);
		}

		/**
		 */
		override public function valueToY(value:Object):Number
		{
			return - valueToSize(value, NaN);
		}
		
		/**
		 */		
		override public function valueToZ(value:Object):Number
		{
			return this.getDataPercent(value);
		}

		/**
		 */
		override protected function get type():String
		{
			return AxisBase.LINER_AXIS;
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
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************************
		 * 
		 * 
		 * 
		 * Y轴数据动态刷新处理
		 * 
		 * 
		 * 
		 ********************************************************/		
		
		override public function redayToUpdataYData():void
		{
			yScrollData.length = 0;
		}
		
		/**
		 */		
		private var yScrollData:Array = [];
		
		/**
		 * 
		 */		
		override public function pushYData(value:Vector.<Object>):void
		{
			var item:Object, i:Number = yScrollData.length;
			for each(item in value)
			{
				yScrollData[i] = item;
				i ++
			}
		}
		
		/**
		 */		
		override public function yDataUpdated():void
		{
			// 剔除重复数据，从小大大排序
			ArrayUtil.removeDubItem(yScrollData);
			yScrollData.sort(Array.NUMERIC);
			
			var min:Number = yScrollData.shift();
			var max:Number = yScrollData.pop();
			
			// 更大的数据范围
			if (max > this.maximum || min < this.minimum)
			{
				_updateYData(min, max);
			}
			else if ((maximum - minimum) / (max - min) > 3)
			{
				_updateYData(min, max);
			}
		}
		
		/**
		 */		
		private function _updateYData(min:Number, max:Number):void
		{
			changed = true;
			
			sourceMax = max;
			sourceMin = min;
			
			baseZero();
			
			preMaxMin(sourceMax, sourceMin);
			confirmMaxMin(size);
			
			//获得最值差，供后继频繁计算用
			confirmedSourceValueDis = maximum - minimum;
			
			appendLabelData();
			unitSize = size / labelVOes.length;
		}
		
		/**
		 * 
		 * 数据缩放时，y轴动态刷新的labelUI构建很耗费性能，要将这些已经被构建
		 * 
		 * 了的labelUI保存下来复用，降低性能开销；
		 * 
		 * 已经被构建了的labelVO和UI存储在统一地方，用的时候从中取出来即可
		 * 
		 */		
		private function appendLabelData():void
		{
			var labelData:AxisLabelData;
			labelVOes.length = labelUIs.length = 0;
			
			//// Flash 中数字计算精度有偏差, 防止与最值及其相近的值蒙混过关
			var maxValue:Number = maximum + interval - interval / 100000;
			var j:uint = 0, i:Number;
			var len:uint = sourceLabelVOs.length;
			// internal 会随当前数值范围而变， 数据缩放时需重新计算labelData
			for (i = minimum; i < maxValue; i += interval)
			{
				labelData = null;
				for (j = 0; j < len; j ++)
				{
					if (sourceLabelVOs[j].value == i)
					{
						labelData = sourceLabelVOs[j];
						
						labelVOes.push(labelData);
						labelUIs.push(sourceLabelUIs[j]);
						break;
					}
				}
				
				if (labelData)
				{
					continue;
				}
				else
				{// 
					labelData = new AxisLabelData();
					labelData.value = i;
					labelVOes.push(labelData);
					labelUIs.push(null);
				}
			}
		}
		
		/**
		 */		
		override protected function restoreLabel(vo:AxisLabelData, ui:BitmapData):void
		{
			sourceLabelVOs.push(vo);
			sourceLabelUIs.push(ui);
		}
		
		/**
		 */		
		internal var sourceLabelVOs:Vector.<AxisLabelData>;
		
		/**
		 */		
		internal var sourceLabelUIs:Array;
		
		/**
		 */		
		private function baseZero():void
		{
			if (baseAtZero && sourceMin * sourceMax >= 0)
			{
				if (sourceMax > 0)
					sourceMin = 0;
				else if (sourceMax < 0)
					sourceMax = 0;
				else if (sourceMin == 0 && sourceMax == 0)
					sourceMax = 100;
			}
		}
	}
}