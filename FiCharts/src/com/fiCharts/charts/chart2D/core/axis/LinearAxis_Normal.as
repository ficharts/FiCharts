package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.DataScale;

	/**
	 */	
	public class LinearAxis_Normal implements IAxisPattern
	{
		/**
		 */		
		public function LinearAxis_Normal(axis:AxisBase)
		{
			this._axis = axis;
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
		public function adjustZoomFactor(model:DataScale):void
		{
			
		}
		
		/**
		 */		
		private function get axis():LinearAxis
		{
			return _axis as LinearAxis;
		}
		
		/**
		 */		
		protected var _axis:AxisBase;
		
		/**
		 */		
		public function toNormalPattern():void
		{
		}
		
		/**
		 */		
		public function toDataResizePattern():void
		{
			if (axis.dataScalePattern)
				axis.curPattern = axis.dataScalePattern;
			else
				axis.curPattern = axis.getDataScalePattern();
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			axis.preMaxMin(axis.sourceMax, axis.sourceMin);
			axis.confirmMaxMin(axis.size);
			
			//获得最值差，供后继频繁计算用
			axis.confirmedSourceValueDis = axis.maximum - axis.minimum;
			
			axis.createLabelsData(axis.maximum, axis.minimum);
			axis.unitSize = axis.size / axis.labelVOes.length;
			
			axis.sourceLabelUIs = [];
			axis.sourceLabelVOs = new Vector.<AxisLabelData>;
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
		
		/**
		 */		
		public function scrollingByChartCanvas(offset:Number):void
		{
		}
		
		/**
		 */		
		public function dataScrolled(dataRange:DataRange):void
		{
		}
		
		/**
		 */		
		public function get currentScrollPos():Number
		{
			return 0;
		}
		
		/**
		 */		
		public function dataResized(dataRange:DataRange):void
		{
		}
		
		/**
		 */		
		public function renderSeries(startPerc:Number, endPerc:Number):void
		{
		}
		
		/**
		 */		
		public function valueToSize(value:Object, index:int):Number
		{
			return percentToPos(getPercentByData(value));
		}
		
		/**
		 */		
		public function getPercentBySourceData(value:Object):Number
		{
			return 0;
		}
		
		/**
		 */		
		public function getPercentByData(data:Object):Number
		{
			if (data == null)
				return 0;
			else
				return (Number(data) - axis.minimum) / axis.confirmedSourceValueDis;
		}
		
		/**
		 */		
		public function percentToPos(perc:Number):Number
		{
			var position:Number;
			
			if (axis.confirmedSourceValueDis)
				position = perc * axis.size;
			else
				position = 0;
			
			if (axis.inverse)
				position = axis.size - position;
			
			return position;;
		}
		
		/**
		 */		
		public function posToPercent(pos:Number):Number
		{
			return 0;
		}
		
		
		
	}
}