package com.fiCharts.charts.chart2D.core.dataBar
{
	import com.fiCharts.charts.chart2D.core.axis.AxisBase;
	import com.fiCharts.charts.chart2D.core.axis.LinearAxis;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.core.series.SeriesDirectionControl;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 */	
	public class DataChart extends Sprite implements IDirectionSeries
	{
		public function DataChart()
		{
			super();
			addChild(canvas);
			
			this.mouseChildren = this.mouseEnabled = false;
		}
		
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
		public var style:Style;
		
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
			
			var item:SeriesDataItemVO;
			var i:uint;
			var len:uint = dataItems.length;
			
			canvas.graphics.clear();
			StyleManager.setShapeStyle(style, canvas.graphics);
			
			for (i = 0; i < len; i += dataStep)
			{
				if (i + dataStep >= len)
					item = dataItems[len - 1];
				else
					item = dataItems[i];
				
				item.x = this.hAxis.valueToX(item.xVerifyValue, i);
				item.y = vAxis.valueToY(item.yVerifyValue);
				
				if (i == 0)
				{
					canvas.graphics.moveTo(item.x, item.y + baseLine + chartHeight)
				}
				else
				{
					canvas.graphics.lineTo(item.x, item.y + baseLine + chartHeight);
				}
			}
			
			//绘制闭合区域以便填充
			var startPoint:SeriesDataItemVO = dataItems[0] as SeriesDataItemVO;
			var endPoint:SeriesDataItemVO = dataItems[len - 1] as SeriesDataItemVO;
			
			canvas.graphics.lineStyle(0, 0, 0);
			canvas.graphics.lineTo(endPoint.x, + baseLine + chartHeight);
			canvas.graphics.lineTo(startPoint.x, baseLine + chartHeight);
			canvas.graphics.lineTo(startPoint.x, startPoint.y );
			canvas.graphics.endFill();
		}
		
		/**
		 */		
		public var dataItems:Vector.<SeriesDataItemVO>
		
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