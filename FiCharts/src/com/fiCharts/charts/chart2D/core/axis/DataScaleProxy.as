package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.model.Zoom;

	/**
	 * 仅有数据缩放坐标轴才用到此类，记录坐标数据总范围,当前数据范围；
	 * 
	 * 由数据映射的刻度位置尺寸之间的关系
	 */	
	public class DataScaleProxy
	{
		public function DataScaleProxy()
		{
		}
		
		/**
		 */		
		public function adjustZoomFactor(model:Zoom, size:Number):void
		{
			var rate:Number = sourceDataLen / size;
			
			model.maxScale = Math.ceil(rate / maxScaleRate);
		}
		
		/**
		 */		
		private var maxScaleRate:Number = 0.01
		
		/**
		 * 根据数据节点的密度，过滤出当前数据节点；
		 * 
		 * 坐标轴和序列不需要渲染所有数据节点，应根据不同的密度区间动态分配当前数据
		 * 
		 * 节点，这样既可以兼容大数据量，又可以看到完美的局部；
		 * 
		 */		
		public function updateCurDataItems(startPerc:Number, endPerc:Number, axis:AxisBase, scale:IAxisPattern):void
		{
			var rate:Number = (endPerc - startPerc) * sourceDataLen / axis.size;
			
			if (rate > maxRate)
			{
				step = Math.ceil(rate / maxRate );
			}
			else
			{
				step = 1;
			}
			
			if (ifStepChanged)
			{
				setCurDataItemByStep(scale, axis);
				ifStepChanged = false;
			}
		}
		
		/**
		 */		
		private function set step(value:uint):void
		{
			if (_step != value)
			{
				_step = value;
				ifStepChanged = true;
			}
		}
		
		/**
		 */		
		private function get step():uint
		{
			return _step;
		}
		
		/**
		 */		
		private var ifStepChanged:Boolean = false;
		
		/**
		 */		
		private var _step:uint = 0;
		
		/**
		 */		
		private function setCurDataItemByStep(axisPattern:IAxisPattern, axis:AxisBase):void
		{
			axisPattern.udpateIndexOfCurSourceData(step);
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.RATE_SERIES_DATA_ITEMS, 0, 0, step));
			axis.upateDataStep(step);
		}
		
		/**
		 * 当前数据节点的最大排位
		 */		
		public var maxIndex:uint = 0;
		
		/**
		 * 此值越小，图表渲染效率越高，数据粒度越稀，只有低于此粒度才用原始数据渲染
		 */		
		private var maxRate:Number = 0.3;
		
		/**
		 *  设定坐标轴的原始数据
		 * 
		 */		
		public function setSourceData(source:Array):void
		{
			sourceData = source;
			sourceDataLen = sourceData.length;
		}
		
		/**
		 */		
		private var sourceData:Array
		
		/**
		 * 原始数据的数量 
		 */		
		public var sourceDataLen:uint = 0;
		
		
		
		
		
		
		
		
		
		/**
		 * 每次渲染或者数据缩放后需重新计算尺寸关系
		 */		
		public function setFullSizeAndOffsize(axis:AxisBase):void
		{
			fullSize = axis.size / (currentDataRange.max - currentDataRange.min) * confirmedSrcValueDis;
			offsetSize = (currentDataRange.min - sourceDataRange.min) / confirmedSrcValueDis * fullSize;
			
			axis.unitSize = fullSize / (this.maxIndex + 1);
			minScrollPos = offsetSize + axis.size - fullSize;
			currentScrollPos = 0;
		}
		
		/**
		 */		
		private var _currentSourceData:Array = [];

		/**
		 */
		public function get currentSourceData():Array
		{
			return _currentSourceData;
		}

		/**
		 * @private
		 */
		public function set currentSourceData(value:Array):void
		{
			_currentSourceData = value;
		}
		
		/**
		 */		
		public function percentToPos(perc:Number, axis:AxisBase):Number
		{
			var position:Number;
			
			if (confirmedSrcValueDis)
				position = perc * fullSize - offsetSize + this.currentScrollPos;
			else
				position = 0;
			
			if (axis.inverse)
				position = fullSize - position;
			
			return position;
		}
		
		/**
		 */		
		public function posToPercent(pos:Number, axis:AxisBase):Number
		{
			var perc:Number;
			var position:Number = pos;
			
			if (axis.inverse)
				position = fullSize - position;
			
			perc = (offsetSize + position - currentScrollPos) / fullSize;
			
			return perc;
		}

		/**
		 * 仅用于数字类型的数据
		 */		
		public function getPercentByData(value:Number):Number
		{
			return (value - this.sourceDataRange.min) / confirmedSrcValueDis;
		}
		
		/**
		 */		
		public function scrollData(offset:Number):void
		{
			currentScrollPos += offset;
			if (currentScrollPos > offsetSize)
				currentScrollPos = offsetSize;
			else if (currentScrollPos < minScrollPos)
				currentScrollPos = minScrollPos;
		}
		
		/**
		 * 当前数据区域相对于总数据区域换算得来的
		 * 
		 * 坐标轴总长度
		 */		
		public var fullSize:Number = 0;
		
		/**
		 * 坐标轴当前滚动偏移量
		 */		
		public var currentScrollPos:Number = 0;
		
		/**
		 * 坐标轴最小滚动位置（向左移动最大量）
		 */		
		public var minScrollPos:Number = 0;
		
		/**
		 * 让当前的数据区域恰好处于可视范围坐标轴就需造假，
		 * 
		 * 把根据数据计算得来的坐标移位，这也是滚动的最大向右量
		 */		
		public var offsetSize:Number = 0;
		
		/**
		 */		
		public var currentDataRange:DataRange = new DataRange;
		
		/**
		 * 校正后的原始数据，也就是总数据范围差值
		 */		
		public var confirmedSrcValueDis:Number = 0;
		
		/**
		 * 经过校正后的原始数据范围，原始数据不一定与坐标刻度和谐匹配，需校正；
		 */		
		public var sourceDataRange:DataRange = new DataRange;
		
		
		
	}
}