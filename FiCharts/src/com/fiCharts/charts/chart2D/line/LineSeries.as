package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.chart2D.core.series.DataIndexOffseter;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.Model;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.CubicBezier;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * 趋势图序
	 */	
	public class LineSeries extends SB implements IDirectionSeries
	{
		/**
		 */
		public function LineSeries()
		{
			super();
		}
		
		/**
		 */		
		override protected function getClassicPattern():ISeriesRenderPattern
		{
			return new ClassicLineRender(this);
		}
		
		/**
		 */		
		override protected function getSimplePattern():ISeriesRenderPattern
		{
			return new SimpleLineRender(this);
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.LINE_SERIES, Model.SYSTEM), this);

		}
		
		/**
		 */		
		override protected function get type():String
		{
			return "line";
		}
		
		/**
		 */		
		public function renderPartUIs():void
		{
			var len:uint = maxDataItemIndex;
			var nodeUI:PartLineUI;
			var preNodeUI:PartLineUI;
			var nextNodeUI:PartLineUI; 
			
			for (var i:uint = 0; i <= len; i ++)
			{
				nodeUI = partUIs[i];
				
				if (i == 0)
				{
					nodeUI.locX = nodeUI.dataItem.x;
					
					if ((i + 1) <= len)//防止一个点的报
					{
						nextNodeUI = partUIs[i + 1];
						nodeUI.locWidth = (nextNodeUI.dataItem.x - nodeUI.dataItem.x) / 2;
					}
					
				}
				else if (i == len)
				{
					preNodeUI = partUIs[i - 1];
					nodeUI.locX = preNodeUI.dataItem.x + (nodeUI.dataItem.x - preNodeUI.dataItem.x) / 2;
					nodeUI.locWidth = (nodeUI.dataItem.x - preNodeUI.dataItem.x) / 2;
				}
				else
				{
					preNodeUI = partUIs[i - 1];
					nextNodeUI = partUIs[i + 1];
					nodeUI.locX = preNodeUI.dataItem.x + (nodeUI.dataItem.x - preNodeUI.dataItem.x) / 2;
					nodeUI.locWidth = (nextNodeUI.dataItem.x - preNodeUI.dataItem.x) / 2;
				}
				
				nodeUI.locHeight = verticalAxis.size;
				nodeUI.locY = - verticalAxis.size - baseLine;
				
				nodeUI.renderIndex = i;
				nodeUI.render();
			}
		}
		
		/**
		 * 每个节点的最终渲染都会调用到此方
		 */		
		public function renderPartLine(canvas:Shape, offset:Number = 0, renderIndex:uint = 0):void
		{
			var startIndex:uint, endIndex:uint;
			
			startIndex = dataOffsetter.offsetMin(renderIndex, 0);
			endIndex = dataOffsetter.offsetMax(renderIndex, maxDataItemIndex);
			
			renderSimleLine(canvas.graphics, startIndex, endIndex, offset);
		}
		
		/**
		 */		
		public function renderSimleLine(canvas:Graphics, startIndex:uint, endIndex:uint, offset:uint = 0):void
		{
			var firstX:Number = (dataItemVOs[startIndex] as SeriesDataPoint).x; 
			var firstY:Number = (dataItemVOs[startIndex] as SeriesDataPoint).y - baseLine - offset;
			
			var item:SeriesDataPoint;
			var i:uint;
			
			if (this.step)// 渐进线段方式
			{
				canvas.moveTo(firstX, firstY);
				
				var stepY:Number = firstY;
				for (i = startIndex; i <= endIndex; i ++)
				{
					item = dataItemVOs[i];
					canvas.lineTo(item.x, stepY);
					canvas.lineTo(item.x, item.y - baseLine - offset);
					stepY = item.y - baseLine - offset;
				}
			}
			else if (smooth)//曲线连接方式
			{
				var point:Point = null;
				var pointArr:Array = [];
				
				for (i = startIndex; i <= endIndex; i ++)
				{
					item = dataItemVOs[i];
					point = new Point();
					point.x = (item as SeriesDataPoint).x;
					point.y = (item as SeriesDataPoint).y - baseLine - offset;
					pointArr.push(point);
				}
				
				//绘制贝塞尔曲
				CubicBezier.curveThroughPoints(canvas, pointArr);
			}
			else //线段连接方式
			{
				canvas.moveTo(firstX, firstY);
				
				for (i = startIndex; i <= endIndex; i ++)
				{
					item = dataItemVOs[i];
					canvas.lineTo(item.x, item.y - baseLine - offset);
				}
			}
			
		}
		
		/**
		 */		
		override public function setPercent(value:Number):void
		{
			canvas.scaleY = value;
		}
		
		/**
		 * 是否采用光滑曲线方式绘制
		 */		
		private var _ifSmooth:Object = false;

		/**
		 */
		public function get smooth():Object
		{
			return _ifSmooth;
		}
		
		/**
		 * @private
		 */
		public function set smooth(value:Object):void
		{
			_ifSmooth = XMLVOMapper.boolean(value);
			
			
			// 平滑趋势图至少需个数据采集点才能平滑过渡
			if (_ifSmooth)
			{
				this.dataOffsetter.dataIndexOffset = 2;
			}
			else
			{
				this.dataOffsetter.dataIndexOffset = 1;
			}
		}
		
		/**
		 * 是否以渐进线段方式绘
		 */		
		private var _ifStep:Object = 0;

		/**
		 */
		public function get step():Object
		{
			return _ifStep;
		}

		/**
		 * @private
		 */
		public function set step(value:Object):void
		{
			_ifStep = XMLVOMapper.boolean(value);
		}

		/**
		 */		
		override public function centerBaseLine():void
		{
			super.centerBaseLine();
			
			states.ty = verticalAxis.valueToY(dataFeature.maxValue) - this.baseLine;
			states.height = verticalAxis.valueToY(dataFeature.minValue) - verticalAxis.valueToY(dataFeature.maxValue);
		}
		
		/**
		 */		
		override public function upBaseLine():void
		{
			super.upBaseLine();
			
			states.ty = verticalAxis.valueToY(dataFeature.maxValue);
			states.height = - verticalAxis.valueToY(dataFeature.maxValue);
		}
		
		/**
		 */		
		override public function downBaseLine():void
		{
			super.downBaseLine();
			
			states.ty = 0;
			states.height = verticalAxis.valueToY(dataFeature.minValue) - baseLine;
		}
		
		/**
		 */		
		private function get dataFeature():SeriesDataFeature
		{
			return directionControl.dataFeature;
		}
		
		/**
		 */		
		public var partUIs:Vector.<PartLineUI>;
		
	}
}