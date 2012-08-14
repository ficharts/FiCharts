package com.fiCharts.charts.chart2D.core.series
{
	import com.fiCharts.charts.chart2D.core.axis.FieldAxis;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;

	/**
	 * 序列的纵向渲染具有方向性，根据序列纵值的分布而定；
	 */	
	public class SeriesDirectionControl
	{
		public function SeriesDirectionControl()
		{
			super();
			
			isUp = isCenter = isDown = false;
		}
		
		/**
		 */		
		public function checkDirection(directionSeries:IDirectionSeries):void
		{
			if (directionSeries.controlAxis is FieldAxis)
			{
				isUp = true;
			}
			else if (Number(dataFeature.maxValue) * Number(dataFeature.minValue) > 0 &&
				Number(dataFeature.minValue) > 0)
			{
				isUp = true;
			}
			else if (Number(dataFeature.maxValue) * Number(dataFeature.minValue) > 0 &&
				Number(dataFeature.maxValue) < 0)
			{
				isDown = true;
			}
			else
			{ 
				isCenter = true;
			}
			
			if(isCenter)
				directionSeries.centerBaseLine();
			else if (isUp)
				directionSeries.upBaseLine();
			else
				directionSeries.downBaseLine();
		}
		
		/**
		 */		
		private var _dataFeature:SeriesDataFeature;

		public function get dataFeature():SeriesDataFeature
		{
			return _dataFeature;
		}

		public function set dataFeature(value:SeriesDataFeature):void
		{
			_dataFeature = value;
		}

		/**
		 */		
		private var _baseLine:Number;

		public function get baseLine():Number
		{
			return _baseLine;
		}

		public function set baseLine(value:Number):void
		{
			_baseLine = value;
		}

		/**
		 */		
		private var isUp:Boolean;
		private var isCenter:Boolean;
		private var isDown:Boolean;
			
	}
}