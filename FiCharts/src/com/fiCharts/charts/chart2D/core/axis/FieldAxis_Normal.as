package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.Zoom;
	
	/**
	 * 字符坐标轴正常模式
	 */	
	public class FieldAxis_Normal implements IAxisPattern
	{
		public function FieldAxis_Normal(axis:FieldAxis)
		{
			this.axis = axis;
		}
		
		/**
		 */		
		public function stopTips():void
		{
			
		}
		
		/**
		 */		
		public function updateToolTips():void
		{
			
		}
		
		/**
		 */		
		public function udpateIndexOfCurSourceData(step:uint):void
		{
			
		}
		
		/**
		 */		
		public function dataUpdated():void
		{
			
		}
		
		/**
		 */		
		private var axis:FieldAxis;
		
		/**
		 */		
		public function adjustZoomFactor(model:Zoom):void
		{
		}
		
		/**
		 */		
		public function toNormalPattern():void
		{
		}
		
		/**
		 */		
		public function toZoomPattern():void
		{
			if (axis.zoomPattern)
				axis.curPattern = axis.zoomPattern;
			else
				axis.curPattern = axis.getZoomPattern();
		}
		
		/**
		 */		
		public function valueToSize(value:Object, index:int):Number
		{
			if (index == - 1)
				index = axis.sourceValues.indexOf(value.toString())
					
			var result:Number = axis.unitSize * .5 + index * axis.unitSize;
			
			if (axis.inverse)
				return axis.size - result;
			
			return result;
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			var labelData:AxisLabelData;
			axis.labelVOes.length = axis.labelUIs.length = 0;
			
			var length:uint = axis.sourceValues.length;
			var step:uint = axis.size / length
			
			for (var i:Number = 0; i < length; i += step)
			{
				labelData = new AxisLabelData()
				labelData.value = axis.sourceValues[i];
				axis.labelVOes.push(labelData);
			}
			
			axis.unitSize = axis.size / length;
		}
		
		/**
		 */		
		public function scrollingByChartCanvas(offset:Number):void
		{
		}
		
		public function dataScrolled(dataRange:DataRange):void
		{
		}
		
		public function get currentScrollPos():Number
		{
			return 0;
		}
		
		public function dataResized(dataRange:DataRange):void
		{
		}
		
		public function renderSeries(startPerc:Number, endPerc:Number):void
		{
		}
		
		public function getPercentByData(data:Object):Number
		{
			return 0;
		}
		
		public function getPercentBySourceData(data:Object):Number
		{
			return 0;
		}
		
		public function percentToPos(perc:Number):Number
		{
			return 0;
		}
		
		public function posToPercent(pos:Number):Number
		{
			return 0;
		}
		
		/**
		 */		
		public function renderHorLabelUIs():void
		{
			axis.clearLabels();
			var length:int = axis.labelVOes.length;
			
			if (axis.ifHideEdgeLabel)
				axis.renderHoriLabelUIs(1, length - 2, length - 2);
			else
				axis.renderHoriLabelUIs(0, length - 1, length);
		}
		
		
	}
}