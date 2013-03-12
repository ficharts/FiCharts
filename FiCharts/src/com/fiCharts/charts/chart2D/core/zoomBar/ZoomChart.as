package com.fiCharts.charts.chart2D.core.zoomBar
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.core.series.SeriesDirectionControl;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 */	
	public class ZoomChart extends Sprite implements IDirectionSeries
	{
		public function ZoomChart()
		{
			super();
			
			addChild(grayChart);
			addChild(canvas);
			addChild(masker);
			canvas.mask = masker;
			
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		/**
		 */		
		private var masker:Shape = new Shape;
		
		/**
		 */		
		internal function scrollChart(x:Number, w:Number):void
		{
			masker.graphics.clear();
			masker.graphics.beginFill(0, 0);
			masker.graphics.drawRect(x, 0, w, chartHeight);
		}
		
		/**
		 */		
		private var grayChart:Shape = new Shape;
		
		/**
		 */		
		private var canvas:Shape = new Shape;
		
		/**
		 */		
		public var hAxis:AxisBase;
		
		/**
		 */		
		public var vAxis:AxisBase;
		
		/**
		 */		
		public var chartHeight:Number = 0;
		
		/**
		 */		
		public var chartWidth:Number = 0;
		
		/**
		 */		
		public var dataStep:uint = 1;
		
		/**
		 */		
		public var chartStyle:Style;
		
		/**
		 */		
		public var grayChartStyle:Style;
		
		/**
		 */		
		public function render():void
		{
			this.hAxis.size = this.chartWidth;
			hAxis.beforeRender();
			hAxis.renderHoriticalAxis();
			
			this.vAxis.size = this.chartHeight;
			vAxis.beforeRender();
			
			applyDataFeature();
			
			var item:SeriesDataPoint;
			var i:uint;
			var len:uint = dataItems.length;
			
			canvas.graphics.clear();
			grayChart.graphics.clear();
			
			StyleManager.setShapeStyle(chartStyle, canvas.graphics);
			StyleManager.setShapeStyle(grayChartStyle, grayChart.graphics);
			
			var py:Number;
			for (i = 0; i < len; i += dataStep)
			{
				if (i + dataStep >= len)
					item = dataItems[len - 1];
				else
					item = dataItems[i];
				
				item.x = this.hAxis.valueToX(item.xVerifyValue, i);
				item.y = vAxis.valueToY(item.yVerifyValue);
				
				
				py = item.y + baseLine + chartHeight;
				
				if (i == 0)
				{
					canvas.graphics.moveTo(item.x, py)
					grayChart.graphics.moveTo(item.x, py)
				}
				else
				{
					canvas.graphics.lineTo(item.x, py);
					grayChart.graphics.lineTo(item.x, py);
				}
			}
			
			//绘制闭合区域以便填充
			var startPoint:SeriesDataPoint = dataItems[0] as SeriesDataPoint;
			var endPoint:SeriesDataPoint = dataItems[len - 1] as SeriesDataPoint;
			
			canvas.graphics.lineStyle(0, 0, 0);
			canvas.graphics.lineTo(endPoint.x, baseLine + chartHeight);
			canvas.graphics.lineTo(startPoint.x, baseLine + chartHeight);
			canvas.graphics.lineTo(startPoint.x, startPoint.y );
			canvas.graphics.endFill();
			
			grayChart.graphics.lineStyle(0, 0, 0);
			grayChart.graphics.lineTo(endPoint.x, baseLine + chartHeight);
			grayChart.graphics.lineTo(startPoint.x, baseLine + chartHeight);
			grayChart.graphics.lineTo(startPoint.x, startPoint.y );
			grayChart.graphics.endFill();
		}
		
		
		/**
		 */		
		public var dataItems:Vector.<SeriesDataPoint>
		
		/**
		 */		
		private function applyDataFeature():void
		{
			this.directionControl.dataFeature = this.controlAxis.getSeriesDataFeature(
				this.verticalValues);
			
			directionControl.checkDirection(this);
		}
		
		/**
		 */		
		public var verticalValues:Vector.<Object>
		
		/**
		 */		
		public function upBaseLine():void
		{
			if ((controlAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = controlAxis.valueToY(0);
			else
				directionControl.baseLine = controlAxis.valueToY(directionControl.dataFeature.minValue);
		}
		
		/**
		 */		
		public function centerBaseLine():void
		{
			directionControl.baseLine = controlAxis.valueToY(0);
		}
		
		/**
		 */		
		public function downBaseLine():void
		{
			if ((controlAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = controlAxis.valueToY(0);
			else
				directionControl.baseLine = controlAxis.valueToY(directionControl.dataFeature.maxValue);
		}
		
		/**
		 */		
		public function get baseLine():Number
		{
			return directionControl.baseLine;
		}
		
		/**
		 */		
		public function set baseLine(value:Number):void
		{
			directionControl.baseLine = value;
		}
		
		/**
		 */		
		protected var directionControl:SeriesDirectionControl = new SeriesDirectionControl();
		
		/**
		 */		
		public function get controlAxis():AxisBase
		{
			return this.vAxis;
		}
		
	}
}