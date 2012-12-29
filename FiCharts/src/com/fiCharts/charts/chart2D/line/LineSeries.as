package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.chart2D.core.series.DataIndexOffseter;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.encry.SB;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.CubicBezier;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * 趋势图序列
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
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.LINE_SERIES), this);
		}
		
		/**
		 * Render line.
		 */
		override protected function renderChart():void
		{
			if (ifDataChanged)
			{
				while (canvas.numChildren)
					canvas.removeChildAt(0);
				
				var linePartUI:PartLineUI;
				partUIs = new Vector.<PartLineUI>;
				for each (var itemDataVO:SeriesDataItemVO in dataItemVOs)
				{
					linePartUI = new PartLineUI(itemDataVO);
					linePartUI.partUIRender = this;
					linePartUI.states = this.states;
					linePartUI.metaData = itemDataVO.metaData;
					canvas.addChild(linePartUI);
					partUIs.push(linePartUI);
				}
			}
			
			if (this.ifSizeChanged || this.ifDataChanged)
			{
				states.tx = this.seriesWidth;
				states.width = seriesWidth;
				
				renderPartUIs();
				ifSizeChanged = ifDataChanged = false;
			}
			
		}
		
		/**
		 */		
		protected function renderPartUIs():void
		{
			
			for (var i:uint = 0; i <= itemRenderMaxIndex; i ++)
			{
					
				if (i == 0)
				{
					partUIs[i].locX = partUIs[i].dataItem.x;
					
					if ((i + 1) <=  itemRenderMaxIndex)//防止一个点的报错
						partUIs[i].locWidth = (partUIs[i + 1].dataItem.x - partUIs[i].dataItem.x) / 2;
				}
				else if (i == itemRenderMaxIndex)
				{
					partUIs[i].locX = partUIs[i - 1].dataItem.x + (partUIs[i].dataItem.x - partUIs[i - 1].dataItem.x) / 2;
					partUIs[i].locWidth = (partUIs[i].dataItem.x - partUIs[i - 1].dataItem.x) / 2;
				}
				else
				{
					partUIs[i].locX = partUIs[i - 1].dataItem.x + (partUIs[i].dataItem.x - partUIs[i - 1].dataItem.x) / 2;
					partUIs[i].locWidth = (partUIs[i + 1].dataItem.x - partUIs[i - 1].dataItem.x) / 2;
				}
				
				partUIs[i].locHeight = this.verticalAxis.size;
				partUIs[i].locY = - this.verticalAxis.size - this.baseLine;
				
				partUIs[i].renderIndex = i;
				partUIs[i].render();
			}
		}
		
		/**
		 * 每个节点渲染的是包括自身在内的临近几个节点
		 */		
		public function renderPartUI(canvas:Shape, style:Style, metaData:Object, renderIndex:uint):void
		{
			canvas.graphics.clear();
			
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, metaData);
			renderPartLine(canvas, 0, renderIndex);
			
			if (style.cover && style.cover.border)
			{
				StyleManager.setLineStyle(canvas.graphics, style.cover.border, style, metaData);
				renderPartLine(canvas, style.cover.offset, renderIndex);
			}
			
			StyleManager.setEffects(canvas, style, metaData);
		}
		
		/**
		 */		
		override public function render():void
		{
		}
		
		/**
		 * 每个节点的最终渲染都会调用到此方法
		 */		
		protected function renderPartLine(canvas:Shape, offset:Number = 0, renderIndex:uint = 0):void
		{
			var startIndex:uint, endIndex:uint;
			
			startIndex = dataOffsetter.offsetMin(renderIndex, 0);
			endIndex = dataOffsetter.offsetMax(renderIndex, itemRenderMaxIndex);
			
			renderSimleLine(canvas.graphics, startIndex, endIndex, offset);
		}
		
		/**
		 */		
		protected function renderSimleLine(canvas:Graphics, startIndex:uint, endIndex:uint, offset:uint = 0):void
		{
			var firstX:Number = (dataItemVOs[startIndex] as SeriesDataItemVO).x; 
			var firstY:Number = (dataItemVOs[startIndex] as SeriesDataItemVO).y - baseLine - offset;
			
			var item:SeriesDataItemVO;
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
					point.x = (item as SeriesDataItemVO).x;
					point.y = (item as SeriesDataItemVO).y - baseLine - offset;
					pointArr.push(point);
				}
				
				//绘制贝塞尔曲线
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
		 * 是否采用光滑曲线方式绘制；
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
			
			
			// 平滑趋势图至少需要5个数据采集点才能平滑过渡
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
		 */		
		protected var dataOffsetter:DataIndexOffseter = new DataIndexOffseter;
		
		/**
		 * 是否以渐进线段方式绘制 
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
		protected var partUIs:Vector.<PartLineUI>;
		
	}
}