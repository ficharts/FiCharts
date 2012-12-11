package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.model.DataScale;
	import com.fiCharts.charts.chart2D.core.series.DataIndexOffseter;
	import com.fiCharts.utils.PerformaceTest;

	/**
	 */	
	public class LinearAxis_DataScale implements IAxisPattern
	{
		/**
		 */		
		public function LinearAxis_DataScale(axis:AxisBase)
		{
			this._axis = axis;
		}
		
		
		/**
		 */		
		public function stopTips():void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.HIDE_TIPS));
		}
		
		/**
		 * 先缩小数值范围，然后寻求最近点来锁定tooltips
		 */		
		public function updateToolTips():void
		{
			var data:Number = getDataByPerc(posToPercent(axis.mouseX));
			
			var evt:DataResizeEvent = new DataResizeEvent(DataResizeEvent.UPDATE_TIPS_BY_DATA);
			evt.start = data - axis.interval;
			evt.end = data + axis.interval;
			evt.data = data;
			
			axis.dispatchEvent(evt);
		}
		
		/**
		 */		
		public function dataResized(dataRange:DataRange):void
		{
			stopTips();
			
			//筛分数据节点
			dataScaleProxy.updateCurDataItems(dataRange.min, dataRange.max, axis, this);
			
			getCurrentDataRange(dataRange.min, dataRange.max);
		
			createLabelsData();// 数据缩放时才重新创建label数据, 数据范围决定label数据
			
			dataScaleProxy.setFullSizeAndOffsize(axis);
			
			axis.renderHoriticalAxis();
			
			renderYAxisAndSeries(dataScaleProxy.currentDataRange.min, dataScaleProxy.currentDataRange.max);
			
			updateToolTips();
			
			axis.updateScrollBarSize(dataRange.min, dataRange.max);
		}
		
		/**
		 */		
		protected function getCurrentDataRange(start:Number, end:Number):void
		{
			//要根据    internal 重新构建 labels, 调整最值
			var min:Number, max:Number;
			min = start * axis.sourceValueDis + axis.sourceMin;
			max = end * axis.sourceValueDis + axis.sourceMin;
			
			axis.preMaxMin(max, min);
			axis.confirmMaxMin(axis.size);
			
			// 数据放大后，单元刻度会变小，两头空隙还是按照旧单元刻度格局，需要调整，除去多余的 internal
			dataScaleProxy.sourceDataRange.min = sourceConfirmedMin + Math.floor((axis.sourceMin - this.sourceConfirmedMin) / axis.interval) * axis.interval;
			dataScaleProxy.sourceDataRange.max = sourceConfirmedMax - Math.floor((sourceConfirmedMax - axis.sourceMax) / axis.interval) * axis.interval;
			dataScaleProxy.confirmedSrcValueDis = dataScaleProxy.sourceDataRange.max - dataScaleProxy.sourceDataRange.min
			
			dataScaleProxy.currentDataRange.min = dataScaleProxy.sourceDataRange.min + 
				dataScaleProxy.confirmedSrcValueDis * start;
			
			dataScaleProxy.currentDataRange.max = dataScaleProxy.sourceDataRange.min + 
				dataScaleProxy.confirmedSrcValueDis * end;
		}
		
		/**
		 */		
		protected var sourceConfirmedMax:Number = 0;
		
		/**
		 */		
		protected var sourceConfirmedMin:Number = 0;
		
		/**
		 * 
		 */		
		public function scrollByDataBar(sourceOff:Number):void
		{
			
		}
		
		/**
		 */		
		public function scrollingByChartCanvas(offset:Number):void
		{
			PerformaceTest.start("scrollingData");
			if (axis.direction == AxisBase.HORIZONTAL_AXIS)
				dataScaleProxy.scrollData(offset);
			
			this.scrollingLabelsAndTicks();
			PerformaceTest.end("scrollingData");
			
			renderYAxisAndSeries(this.scrollMinData, this.scrollMaxData);
			
			axis.updateScrollBarPos(dataScaleProxy.getPercentByData(scrollMinData));
		}
		
		/**
		 * 根据当前数值范围，划定序列节点范围，y轴数据范围，然后渲染Y轴和序列 
		 */		
		protected function renderYAxisAndSeries(minData:Number, maxData:Number):void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.GET_SERIES_DATA_INDEX_RANGE_BY_DATA, minData, maxData));
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE));
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.RENDER_DATA_RESIZED_SERIES));
			trace("----------------------------------------------------------------------")
		}
		
		/**
		 */		
		public function dataScrolled(dataRange:DataRange):void
		{
			var offPerc:Number = dataScaleProxy.currentScrollPos / dataScaleProxy.fullSize;
			var min:Number = dataScaleProxy.currentDataRange.min - offPerc * dataScaleProxy.confirmedSrcValueDis;
			var max:Number = dataScaleProxy.currentDataRange.max - offPerc * dataScaleProxy.confirmedSrcValueDis;
			
			dataRange.min = getPercentByData(min);
			dataRange.max = getPercentByData(max);
		}
		
		/**
		 */		
		public function udpateIndexOfCurSourceData(step:uint):void
		{
			dataScaleProxy.maxIndex = Math.ceil(dataScaleProxy.sourceDataLen / step);
		}
		
		/**
		 */		
		public function adjustZoomFactor(model:DataScale):void
		{
			dataScaleProxy.adjustZoomFactor(model, axis.size);
		}
		
		/**
		 */		
		protected var dataScaleProxy:DataScaleProxy = new DataScaleProxy;
		
		/**
		 */		
		protected var _axis:AxisBase;
		
		/**
		 */		
		protected function get axis():LinearAxis
		{
			return _axis as LinearAxis;
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
		public function toDataResizePattern():void
		{
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			axis.preMaxMin(axis.sourceMax, axis.sourceMin);
			axis.confirmMaxMin(axis.size);
			
			sourceConfirmedMin = dataScaleProxy.currentDataRange.min = dataScaleProxy.sourceDataRange.min = axis.minimum;
			sourceConfirmedMax = dataScaleProxy.currentDataRange.max = dataScaleProxy.sourceDataRange.max = axis.maximum;
			
			//获得最值差，供后继频繁计算用
			dataScaleProxy.confirmedSrcValueDis = dataScaleProxy.sourceDataRange.max - dataScaleProxy.sourceDataRange.min;
			
			dataScaleProxy.updateCurDataItems(0, 1, axis, this);
			this.createLabelsData();
			dataScaleProxy.setFullSizeAndOffsize(axis);
		}
		
		/**
		 */		
		public function dataUpdated():void
		{
			dataScaleProxy.setSourceData(axis.sourceValues);
		}
		
		
		
		
		
		//--------------------------------------------------------------
		//
		//
		// 显示区域刻度绘制
		//
		//
		//---------------------------------------------------------------
		
		/**
		 * 数据滚动时， 刷新当前显示区域内的label
		 */		
		protected function scrollingLabelsAndTicks():void
		{
			this.renderHorLabelUIs();
			if (axis.enable && axis.tickMark.enable)
				axis.drawHoriTicks();
		}
		
		/**
		 * 根据当前数据范围确定label范围，渲染这些label；
		 * 
		 * 已经被渲染的label不用重复渲染，之渲染需要渲染的；
		 * 
		 * 同时更新ticks信息，供背景网格实时绘制
		 */		
		public function renderHorLabelUIs():void
		{
			axis.clearLabels();
			getLabelIndexRangeForRender();
			
			axis.renderHoriLabelUIs(dataIndexActor.minIndex, dataIndexActor.maxIndex, 
				dataIndexActor.length);
		}
		
		/**
		 * 获取当前坐标轴显示区域label的数据位置范围
		 */		
		protected function getLabelIndexRangeForRender():void
		{
			scrollMinData = getDataByPerc(posToPercent(0));
			scrollMaxData = getDataByPerc(posToPercent(axis.size))
			
			dataIndexActor.minIndex = 0;
			var maxIndex:uint = dataIndexActor.maxIndex = axis.labelVOes.length - 1;
			
			dataIndexActor.getDataIndexRange(scrollMinData, scrollMaxData, axis.labelValues);
			dataIndexActor.offSet(0, maxIndex);// 多取两个数据位，丰满一些
		}
		
		/**
		 */		
		protected var scrollMinData:Number = 0;
		protected var scrollMaxData:Number = 0;
		
		/**
		 */		
		protected function createLabelsData():void
		{
			axis.createLabelsData(dataScaleProxy.sourceDataRange.max, dataScaleProxy.sourceDataRange.min);
		}
		
		/**
		 * 辅助Y轴数据刷新和X轴的刻度渲染划定index范围
		 */		
		protected var dataIndexActor:DataIndexOffseter = new DataIndexOffseter;
		
		/**
		 * 根据百分比位置，得出数据值
		 */		
		protected function getDataByPerc(perc:Number):Number
		{
			return perc * dataScaleProxy.confirmedSrcValueDis + dataScaleProxy.sourceDataRange.min;
		}
		
		/**
		 */		
		public function getPercentBySourceData(value:Object):Number
		{
			return getPercentByData(value);
		}
		
		/**
		 */		
		public function getPercentByData(data:Object):Number
		{
			return dataScaleProxy.getPercentByData(Number(data));
		}
		
		/**
		 */		
		public function valueToSize(value:Object, index:int):Number
		{
			return percentToPos(getPercentByData(value));
		}
		
		/**
		 */		
		public function percentToPos(perc:Number):Number
		{
			return dataScaleProxy.percentToPos(perc, axis);
		}
		
		/**
		 */		
		public function posToPercent(pos:Number):Number
		{
			return dataScaleProxy.posToPercent(pos, axis);
		}
		
	}
}