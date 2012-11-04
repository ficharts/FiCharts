package com.fiCharts.charts.chart2D.line
{
	import com.fiCharts.charts.chart2D.core.events.DataResizeEvent;
	import com.fiCharts.charts.chart2D.core.itemRender.ItemRenderBace;
	import com.fiCharts.charts.chart2D.core.model.Chart2DModel;
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.chart2D.core.series.IDirectionSeries;
	import com.fiCharts.charts.chart2D.encry.SeriesBase;
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
	public class LineSeries extends SeriesBase implements IDirectionSeries
	{
		/**
		 */
		public function LineSeries()
		{
			super();
		}
		
		/**
		 * 线条的渲染模式， 简单型和复杂型， 默认是复杂型 default;
		 * 
		 * 简单型， simple 则每个节点不单独渲染，单个节点无法响应交互动作，但是渲染效率较高
		 * 
		 * 大数据量时建议采用simple类型
		 */		
		private var _type:String = 'default';

		/**
		 */
		public function get renderType():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set renderType(value:String):void
		{
			_type = value;
		}

		/**
		 */		
		override protected function dataResizedByIndex(evt:DataResizeEvent):void
		{
			super.dataResizedByIndex(evt);
			
			if (renderType == 'simple')
			{
				renderWholeLine(dataOffsetter.minIndex, dataOffsetter.maxIndex);
			}
			else
			{
				renderPartUIs();
			}
			
			updataItemRendersLayout();
		}
		
		/**
		 */		
		override protected function dataResizedByRange(evt:DataResizeEvent):void
		{
			super.dataResizedByRange(evt);
			
			if (renderType == 'simple')
			{
				renderWholeLine(dataOffsetter.minIndex, dataOffsetter.maxIndex);
			}
			else
			{
				renderPartUIs();
			}
			
			updataItemRendersLayout();
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
			if (renderType == 'simple')
			{
				if (this.ifSizeChanged || this.ifDataChanged)
				{
					
					states.tx = this.seriesWidth;
					states.width = seriesWidth;
					
					this.style = this.states.getNormal;
					
					renderWholeLine(dataOffsetter.minIndex, dataOffsetter.maxIndex);
					ifSizeChanged = ifDataChanged = false;
				}
			}
			else
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
			
		}
		
		/**
		 */		
		protected function renderPartUIs():void
		{
			// 不用选然道临界结点，而是把临界结点包含在内用于辅助渲染最靠近临界节点的节点
			var startRenderIndex:uint = dataOffsetter.minIndex// + dataOffsetter.dataIndexOffset;
			var endRenderIndex:uint = dataOffsetter.maxIndex// - dataOffsetter.dataIndexOffset;
			
			for (var i:uint = 0; i <= itemRenderMaxIndex; i ++)
			{
				if (startRenderIndex <= i && i <=  endRenderIndex)
				{
					partUIs[i].visible = true;
					
					if (i == startRenderIndex)
					{
						partUIs[i].locX = partUIs[i].dataItem.x;
						partUIs[i].locWidth = (partUIs[i + 1].dataItem.x - partUIs[i].dataItem.x) / 2;
					}
					else if (i == endRenderIndex)
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
				else
				{
					partUIs[i].visible = false;
				}
						
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
		 * 
		 * 一次渲染所有节点，此方法用在 simple 类型的的序列中, 最简单方式的渲染，但性能最好
		 */		
		protected function renderWholeLine(startIndex:uint, endIndex:uint):void
		{
			canvas.graphics.clear();
			
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, this);
			this.renderSimleLine(canvas.graphics, startIndex, endIndex, 0);
			
			/*if (style.cover && style.cover.border)
			{
				StyleManager.setLineStyle(canvas.graphics, style.cover.border, style, this);
				this.renderSimleLine(canvas.graphics, startIndex, endIndex, style.cover.offset);
			}*/
			
			//StyleManager.setEffects(canvas, style);
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
		override protected function get itemRender():ItemRenderBace
		{
			return new ItemRenderBace;
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