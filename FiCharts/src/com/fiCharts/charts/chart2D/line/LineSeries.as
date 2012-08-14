package com.fiCharts.charts.chart2D.line
{
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
	
	import flash.display.Shape;
	import flash.geom.Point;

	/**
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
				renderPartUIs();
				ifSizeChanged = ifDataChanged = false;
			}
		}
		
		/**
		 */		
		protected function renderPartUIs():void
		{
			states.tx = this.seriesWidth;
			states.width = seriesWidth;
			
			var length:uint = partUIs.length
			for (var i:uint = 0; i < length; i ++)
			{
				if (i == 0)
				{
					partUIs[i].locX = partUIs[i].dataItem.x;
					partUIs[i].locWidth = (partUIs[i + 1].dataItem.x - partUIs[i].dataItem.x) / 2;
				}
				else if (i == length - 1)
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
				
				partUIs[i].render();
			}
		}
		
		/**
		 */		
		public function renderPartUI(canvas:Shape, style:Style, metaData:Object):void
		{
			canvas.graphics.clear();
			
			StyleManager.setLineStyle(canvas.graphics, style.getBorder, style, metaData);
			renderLine(canvas);
			
			if (style.cover && style.cover.border)
			{
				StyleManager.setLineStyle(canvas.graphics, style.cover.border, style, metaData);
				renderLine(canvas, style.cover.offset);
			}
			
			StyleManager.setEffects(canvas, style, metaData);
		}
		
		/**
		 */		
		override public function render():void
		{
		}
		
		/**
		 */		
		protected function renderLine(canvas:Shape, offset:Number = 0):void
		{
			var firstX:Number = (dataItemVOs[0] as SeriesDataItemVO).x; 
			var firstY:Number = (dataItemVOs[0] as SeriesDataItemVO).y - baseLine - offset;
			
			if (this.step)// 渐进线段方式
			{
				canvas.graphics.moveTo(firstX, firstY);
				
				var stepY:Number = firstY;
				for each (var item:SeriesDataItemVO in dataItemVOs)
				{
					canvas.graphics.lineTo(item.x, stepY);
					canvas.graphics.lineTo(item.x, item.y - baseLine - offset);
					stepY = item.y - baseLine - offset;
				}
			}
			else if (smooth)//曲线连接方式
			{
				var point:Point = null;
				var pointArr:Array = [];
				
				for (var i:int = 0; i < dataItemVOs.length; i++)
				{
					point = new Point();
					point.x = (dataItemVOs[i] as SeriesDataItemVO).x;
					point.y = (dataItemVOs[i] as SeriesDataItemVO).y - baseLine - offset;
					pointArr.push(point);
				}
				
				//绘制贝塞尔曲线
				CubicBezier.curveThroughPoints(canvas.graphics, pointArr);
			}
			else //线段连接方式
			{
				canvas.graphics.moveTo(firstX, firstY);
				
				for each (item in dataItemVOs)
					canvas.graphics.lineTo(item.x, item.y - baseLine - offset);
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