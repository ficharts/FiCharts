package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.Zoom;

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
		public function hideDataRender():void
		{
			
		}
		
		/**
		 */		
		public function updateTipsData():void
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
		public function adjustZoomFactor(model:Zoom):void
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
		public function toZoomPattern():void
		{
			if (axis.zoomPattern)
				axis.curPattern = axis.zoomPattern;
			else
				axis.curPattern = axis.getZoomPattern();
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			axis.preMaxMin(axis.sourceMax, axis.sourceMin);
			axis.confirmMaxMin(axis.size);
			
			if(axis.ifCeilEdgeValue)
				axis.confirmedSourceValueDis = axis.maximum - axis.minimum;
			else
				axis.confirmedSourceValueDis = axis.sourceMax - axis.sourceMin;
			
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
			{
				return 0;
			}
			else
			{
				var confirmedMin:Number = 0;
				if (axis.ifCeilEdgeValue)
					confirmedMin = axis.minimum;
				else
					confirmedMin = axis.sourceMin;
					
				return (Number(data) - confirmedMin) / axis.confirmedSourceValueDis;
			}
		}
		
		/**
		 */		
		public function percentToPos(perc:Number):Number
		{
			var position:Number = 0;
			
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
		
		/**
		 */		
		public function checkIfShowLabel(index:uint):Boolean
		{
			if(isNaN(axis.minLabel) && isNaN(axis.maxLabel))
			{
				return true;
			}
			else
			{
				var value:Number = Number(axis.labelVOes[index].value);
				
				if ((value - axis.interval) < axis.maxLabel && value >= axis.maxLabel)
					return true;
				if (axis.minLabel < (value + axis.interval) && axis.minLabel >= value)
					return true;
				else
					return false;
			}
		}
		
	}
}