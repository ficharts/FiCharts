package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;

	/**
	 * 
	 * 字符类型的坐标轴， 数据节点均匀分部
	 * 
	 * @author wallen
	 * 
	 */	
	public class FieldAxis extends AxisBase
	{
		public function FieldAxis()
		{
			super();
		}
		
		/**
		 */		
		override public function percentToPos(per:Number):Number
		{
			return this.currentScrollPos - this.offsetSize + this.fullSize * per;
		}
		
		/**
		 */		
		override public function posToPercent(pos:Number):Number
		{
			var perc:Number;
			var position:Number = pos;
			
			if (this.inverse)
				position = this.fullSize - position;
			
			perc = (offsetSize + position - this.currentScrollPos) / fullSize;
			
			return perc;
		}
		
		/**
		 */		
		override public function getDataPercent(value:Object):Number
		{
			var result:Number = this.sourceValues.indexOf(value) / this.confirmedSourceValueRange;
			
			if (result < 0)
				result = 0;
			
			if (result > 1)
				result = 1;
			
			return result;
		}
		
		override public function dataScrolled(dataRange:DataRange):void
		{
			var offPerc:Number = this.currentScrollPos / this.fullSize;
			var min:Number = Math.floor(this.currentDataRange.min - offPerc * confirmedSourceValueRange);
			var max:Number = Math.ceil(currentDataRange.max - offPerc * confirmedSourceValueRange);
			
			this.dispatchEvent(new DataResizeEvent(DataResizeEvent.RESIZE_BY_INDEX, 
				min, max));
			
			dataRange.min = min / confirmedSourceValueRange;
			dataRange.max = max / confirmedSourceValueRange;
		}
		
		/**
		 * 字符类型数据节点均匀分布， 根据位置就可划定数值范围
		 */		
		override public function dataResized(start:Number, end:Number):void
		{
			getCurrentDataRange(start, end);
			createLabelsData();
			setFullSizeAndOffsize();
			
			minScrollPos = offsetSize + size - this.fullSize;
			this.labelUIsCanvas.x = currentScrollPos = 0;// 数据缩放后尺寸有了新的关系
			
			this.dispatchEvent(new DataResizeEvent(DataResizeEvent.RESIZE_BY_INDEX, 
				currentDataRange.min, currentDataRange.max));
			
			changed = true;
		}
		
		/**
		 */		
		override public function renderSeries(start:Number, end:Number):void
		{
			var len:uint = this.sourceValues.length - 1;
			var min:Number, max:Number;
			min = Math.floor(start * len);
			max =  Math.ceil(end * len);
			
			this.dispatchEvent(new DataResizeEvent(DataResizeEvent.RESIZE_BY_INDEX, 
				min, max));
		}
		
		/**
		 */		
		private function getCurrentDataRange(start:Number, end:Number):void
		{
			var len:uint = this.sourceValues.length - 1;
			
			currentDataRange.min = Math.floor(start * len);
			currentDataRange.max = Math.ceil(end * len);
		}
		
		/**
		 */		
		override public function getXLabel(value:Object):String
		{
			return dataFormatter.formatXString(value);
		}
		
		override public function getYLabel(value:Object):String
		{
			return dataFormatter.formatYString(value);
		}

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
			var result:Number = unitSize * .5 + 
				(sourceValues.indexOf(value.toString()) - this.sourceDataRange.min) * unitSize
				 - this.offsetSize + this.currentScrollPos;
			
			if (inverse)
				return size - result;
			
			return result;
		}
		
		/**
		 */		
		override protected function adjustHoriTicks():void
		{
			if (ifTickCenter)
			{
				ticks.unshift(0);
				ticks.push(size);
			}
			else
			{
				if (this.inverse)
					ticks.forEach(shiftRight);
				else
					ticks.forEach(shiftLeft);
				
				ticks.push(size);
			}
		}
		
		/**
		 */		
		private function shiftLeft(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item - unitSize * .5;
		}
		
		/**
		 */		
		private function shiftRight(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item + unitSize * .5;
		}
		
		/**
		 */		
		override protected function adjustVertiTicks():void
		{
			if (ifTickCenter)
			{
				ticks.unshift(0);
				ticks.push(- size);
			}
			else
			{
				if (this.inverse)
					ticks.forEach(shiftUp);
				else
					ticks.forEach(shiftDown);
				
				ticks.push(- size);
			}
		}
		
		/**
		 */		
		private function shiftDown(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item + unitSize * .5;
		}
		
		/**
		 */		
		private function shiftUp(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item - unitSize * .5;
		}
		
		/**
		 * 标签是否与刻度线对齐，默认不对齐，标签位于两个刻度线的中间；
		 */		
		private var _ifTickCenter:Boolean = false;

		/**
		 */
		public function get ifTickCenter():Object
		{
			return _ifTickCenter;
		}

		/**
		 * @private
		 */
		public function set ifTickCenter(value:Object):void
		{
			_ifTickCenter = XMLVOMapper.boolean(value);
		}

		/**
		 */		
		override public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
			
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
		 */
		override public function pushValues(values:Vector.<Object>):void
		{
			for each (var item:String in values)
			{
				if (sourceValues.indexOf(item) == - 1)
					sourceValues.push(item);
			}
		}
		
		/**
		 * 
		 * 数据源与label节点一一对应；
		 * 
		 */		
		override public function beforeRender():void
		{
			if (changed)
			{
				currentDataRange.min = sourceDataRange.min = 0;
				currentDataRange.max = sourceDataRange.max = this.sourceValues.length - 1;
				confirmedSourceValueRange = sourceDataRange.max - sourceDataRange.min;
				
				createLabelsData();
				setFullSizeAndOffsize();
			}
		}
		
		/**
		 */		
		private function setFullSizeAndOffsize():void
		{
			fullSize = this.size / (currentDataRange.max - currentDataRange.min) * confirmedSourceValueRange;
			this.offsetSize = (currentDataRange.min - sourceDataRange.min) / confirmedSourceValueRange * fullSize;
			unitSize = fullSize / this.labelsData.length;
		}
		
		/**
		 */		
		private function createLabelsData():void
		{
			var labelData:AxisLabelData;
			labelsData = new Vector.<AxisLabelData>;
			for each (var value:String in sourceValues)
			{
				labelData = new AxisLabelData();
				labelData.value = value;
				labelsData.push(labelData);
			}
		}
		
	}
}