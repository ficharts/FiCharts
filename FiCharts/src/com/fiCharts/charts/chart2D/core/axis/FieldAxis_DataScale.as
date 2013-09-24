package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.model.Zoom;
	import com.fiCharts.charts.chart2D.core.series.DataIndexOffseter;
	import com.fiCharts.utils.PerformaceTest;

	/**
	 * 具有数据缩放功能的字符型轴
	 */	
	public class FieldAxis_DataScale implements IAxisPattern
	{
		/**
		 */		
		public function FieldAxis_DataScale(axis:FieldAxis)
		{
			this.axis = axis;
		}
		
		/**
		 */		
		public function hideDataRender():void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.HIDE_DATA_RENDER));
		}
		
		/**
		 * 找到离鼠标位置最近的点
		 * 
		 * 这里是以全局坐标来判定节点位置
		 */		
		public function updateTipsData():void
		{
			var evt:DataResizeEvent = new DataResizeEvent(DataResizeEvent.UPDATE_TIPS_BY_INDEX);
			
			var curPerc:Number = posToPercent(axis.mouseX);
			evt.start = Math.floor(curPerc * dataScaleProxy.sourceDataLen);
			evt.end =  Math.ceil(curPerc * dataScaleProxy.sourceDataLen);
			
			var prePerc:Number = dataScaleProxy.getPercentByData(evt.start);
			var nexPerc:Number = dataScaleProxy.getPercentByData(evt.end);
			
			evt.data = curPerc - prePerc;
			
			if (evt.data < (nexPerc - curPerc))
				evt.data = evt.start;
			else
				evt.data = evt.end;
			
			evt.label = axis.sourceValues[evt.data];
			evt.start = axis.mouseX;
			evt.end = dataScaleProxy.fullSize;	
			//这里又
			axis.dispatchEvent(evt);
		}
		
		/**
		 */		
		public function udpateIndexOfCurSourceData(step:uint):void
		{
			dataScaleProxy.currentSourceData.length = 0;
			var i:uint, j:uint = 0, len:uint = dataScaleProxy.sourceDataLen;
			for (i = 0; i < len; i += step)
			{
				if (i + step >= dataScaleProxy.sourceDataLen)
					dataScaleProxy.currentSourceData[j] = axis.sourceValues[len - 1];
				else
					dataScaleProxy.currentSourceData[j] = axis.sourceValues[i];
				
				j ++;
			}
			
			dataScaleProxy.maxIndex = dataScaleProxy.currentSourceData.length - 1;
			
			dataScaleProxy.currentDataRange.min = dataScaleProxy.sourceDataRange.min = 0;
			dataScaleProxy.currentDataRange.max = dataScaleProxy.sourceDataRange.max = dataScaleProxy.maxIndex;
			dataScaleProxy.confirmedSrcValueDis = dataScaleProxy.sourceDataRange.max - dataScaleProxy.sourceDataRange.min;
		}
		
		
		/**
		 * 字符类型数据节点均匀分布， 根据位置就可划定数值范围, 
		 */		
		public function dataResized(dataRange:DataRange):void
		{
			hideDataRender();
			
			dataScaleProxy.updateCurDataItems(dataRange.min, dataRange.max, axis, this);
			
			// 获得当前数据 index 范围
			dataScaleProxy.currentDataRange.min = Math.floor(dataRange.min * dataScaleProxy.maxIndex);
			dataScaleProxy.currentDataRange.max = Math.ceil(dataRange.max * dataScaleProxy.maxIndex);
			
			dataScaleProxy.setFullSizeAndOffsize(axis);
			
			createLabelsData();
			axis.renderHoriticalAxis();
			
			renderYAxisAndSeries(dataScaleProxy.currentDataRange.min, dataScaleProxy.currentDataRange.max);
			
			updateTipsData();
		}
		
		/**
		 */		
		public function scrollingByChartCanvas(offset:Number):void
		{
			if (axis.direction == AxisBase.HORIZONTAL_AXIS)
				dataScaleProxy.scrollData(offset);
			
			this.drawScrollingLabels();
			
			renderYAxisAndSeries(this.scrollMinIndex, this.scrollMaxIndex);
		}
		
		/**
		 * 这里先假定，序列数据分部恰好等于坐标轴的数据分部
		 * 
		 * TODO
		 */		
		public function dataScrolled(dataRange:DataRange):void
		{
			var offPerc:Number = this.currentScrollPos / dataScaleProxy.fullSize;
			var min:Number = Math.floor(dataScaleProxy.currentDataRange.min - offPerc * dataScaleProxy.confirmedSrcValueDis);
			var max:Number = Math.ceil(dataScaleProxy.currentDataRange.max - offPerc * dataScaleProxy.confirmedSrcValueDis);
			
			if (min < 0) min = 0;
			if (max > dataScaleProxy.sourceDataRange.max) max = dataScaleProxy.sourceDataRange.max;
			
			dataRange.min = min / dataScaleProxy.confirmedSrcValueDis;
			dataRange.max = max / dataScaleProxy.confirmedSrcValueDis;
		}
		
		/**
		 * 根据当前数值位置范围，划定序列节点范围，y轴数据范围，然后渲染Y轴和序列 
		 */		
		private function renderYAxisAndSeries(min:Number, max:Number):void
		{
			// 绘制滚动条
			var startPerc:Number = min / dataScaleProxy.maxIndex;
			var endPerc:Number = max / dataScaleProxy.maxIndex;
			axis.updateScrollBarSize(startPerc, endPerc);
			
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.GET_SERIES_DATA_INDEX_BY_INDEXS, min, max));
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE));
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.RENDER_DATA_RESIZED_SERIES));
		}
		
		/**
		 * 数据滚动时， 刷新当前显示区域内的label
		 */		
		protected function drawScrollingLabels():void
		{
			this.renderHorLabelUIs();
			
			axis.adjustHoriTicks();
			if (axis.enable && axis.tickMark.enable)
				axis.drawHoriTicks();
		}
		
		/**
		 */		
		public function renderHorLabelUIs():void
		{
			axis.clearLabels();
			getIndexRangeForRender();
			
			axis.renderHoriLabelUIs(dataIndexForRenderLabels.minIndex, dataIndexForRenderLabels.maxIndex, 
				dataIndexForRenderLabels.length);
		}
		
		/**
		 */		
		private function getIndexRangeForRender():void
		{
			scrollMinIndex = Math.floor(posToPercent(0) * dataScaleProxy.maxIndex);
			scrollMaxIndex =  Math.ceil(posToPercent(axis.size) * dataScaleProxy.maxIndex);
			
			dataIndexForRenderLabels.minIndex = 0;
			var maxIndex:uint = dataIndexForRenderLabels.maxIndex = axis.labelVOes.length - 1;
			
			dataIndexForRenderLabels.getDataIndexRange(scrollMinIndex, scrollMaxIndex, labelIndexInfo);
			dataIndexForRenderLabels.offSet(0, maxIndex);// 多取两个数据位，丰满一些
		}
		
		/**
		 */		
		private function createLabelsData():void
		{
			var labelVO:AxisLabelData;
			axis.labelVOes.length = axis.labelUIs.length = labelIndexInfo.length = 0;
			
			var length:uint = dataScaleProxy.maxIndex;
			var step:uint = Math.ceil(axis.temUintSize / axis.unitSize);
			var i:uint = 0, j:uint = 0;
			
			if (step == 0) 
				step = 1;
			
			for (i = 0; i <= length; i += step)
			{
				labelVO = new AxisLabelData();
				labelVO.value = dataScaleProxy.currentSourceData[i];
				axis.labelVOes[j] = labelVO;
				labelIndexInfo[j] = i;
				j ++;
			}
		}
		
		/**
		 */		
		private var labelIndexInfo:Array = [];
		
		/**
		 */		
		private var scrollMinIndex:Number = 0;
		private var scrollMaxIndex:Number = 0;
		
		/**
		 */		
		private var dataIndexForRenderLabels:DataIndexOffseter = new DataIndexOffseter;
		
		/**
		 */		
		public function adjustZoomFactor(model:Zoom):void
		{
			dataScaleProxy.adjustZoomFactor(model, axis.size);
		}
		
		/**
		 */		
		public function toZoomPattern():void
		{
			
		}
		
		/**
		 */		
		public function toNormalPattern():void
		{
			if (axis.normalPattern)
				axis.curPattern = axis.normalPattern;
			else
				axis.curPattern = axis.getNormalPatter();
		}
		
		
		/**
		 */		
		public function get currentScrollPos():Number
		{
			return dataScaleProxy.currentScrollPos;
		}
		
		/**
		 */		
		private var dataScaleProxy:DataScaleProxy = new DataScaleProxy;
		
		/**
		 */		
		private var axis:FieldAxis;
		
		
		
		/**
		 */		
		public function dataUpdated():void
		{
			dataScaleProxy.setSourceData(axis.sourceValues);
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			dataScaleProxy.updateCurDataItems(0, 1, axis, this);
			
			dataScaleProxy.setFullSizeAndOffsize(axis);
			createLabelsData();
		}
		
		/**
		 */		
		public function valueToSize(value:Object, index:int):Number
		{
			//if (index == - 1)// 此时是坐标轴Label位置计算， 因label位置信息是独立的体系
				index = dataScaleProxy.currentSourceData.indexOf(value)
					
			var result:Number = axis.unitSize * .5 + index * axis.unitSize
					- dataScaleProxy.offsetSize + dataScaleProxy.currentScrollPos;
			
			if (axis.inverse)
				return dataScaleProxy.fullSize - result;
			
			return result;
		}
		
		/**
		 */		
		public function percentToPos(per:Number):Number
		{
			return dataScaleProxy.percentToPos(per, axis);
		}
		
		/**
		 */		
		public function posToPercent(pos:Number):Number
		{
			return dataScaleProxy.posToPercent(pos, axis);
		}
		
		/**
		 */		
		public function getPercentBySourceData(value:Object):Number
		{
			var result:Number =  axis.sourceValues.indexOf(value) / (axis.sourceValues.length - 1);
				
			if (result < 0)
				result = 0;
			
			if (result > 1)
				result = 1;
			
			return result;
		}
		
		/**
		 */		
		public function getPercentByData(value:Object):Number
		{
			var result:Number =  dataScaleProxy.currentSourceData.indexOf(value) / dataScaleProxy.confirmedSrcValueDis;
			
			if (result < 0)
				result = 0;
			
			if (result > 1)
				result = 1;
			
			return result;
		}
		
		/**
		 */		
		public function checkIfShowLabel(index:uint):Boolean
		{
			return true;
		}
		
		
	}
}