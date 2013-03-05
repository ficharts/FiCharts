package com.fiCharts.charts.chart2D.core.itemRender
{
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.charts.common.SeriesDataPoint;
	import com.fiCharts.charts.toolTips.ToolTipHolder;
	import com.fiCharts.charts.toolTips.ToolTipsEvent;
	import com.fiCharts.charts.toolTips.TooltipDataItem;
	import com.fiCharts.charts.toolTips.TooltipStyle;
	import com.fiCharts.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.StatesControl;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 */	
	public class PointRenderBace extends Sprite implements IStyleStatesUI
	{
		public function PointRenderBace()
		{
			super();

			//this.hitArea = canvas;
			addChild(canvas);
			
			statesControl = new StatesControl(this);
			canvas.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
			canvas.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		}
		
		/**
		 * 
		 * 这个值在全局判断节点碰撞时会用到
		 * 
		 * 渲染节点的半径，  汽包图的气泡半径由Z值决定，默认由样式文件定�radius 
		 */		
		private var _radius:Number = 0;

		/**
		 */
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		/**
		 */		
		private function rollOverHandler(evt:MouseEvent):void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_OVER);
			event.dataItem = this.itemVO;
			this.dispatchEvent(event);
			
			this.showToolTips();
		}
		
		/**
		 */		
		private function rollOutHandler(evt:MouseEvent):void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_OUT);
			event.dataItem = this.itemVO;
			this.dispatchEvent(event);
			
			this.hideToolTips();	
		}				
		
		/**
		 */		
		public var isHorizontal:Boolean = false;
		
		/**
		 * 判断当前渲染器是否有效�
		 */
		public function get isEnable():Boolean
		{
			return _isEnable;
		}
		
		/**
		 */		
		protected var _isEnable:Boolean = true;

		/**
		 */		
		public function disable():void
		{
			this.statesControl.enable = canvas.visible = _isEnable = false;
			
			_itemVO.removeEventListener(ItemRenderEvent.SHOW_TOOLTIP, showTooltipHandler);
			_itemVO.removeEventListener(ItemRenderEvent.HIDE_TOOLTIP, hideTooltipHandler);
		}
		
		/**
		 */		
		public function enable():void
		{
			this.statesControl.enable = canvas.visible = _isEnable = true;
			
			_itemVO.addEventListener(ItemRenderEvent.SHOW_TOOLTIP, showTooltipHandler, false, 0, true);
			_itemVO.addEventListener(ItemRenderEvent.HIDE_TOOLTIP, hideTooltipHandler, false, 0, true);
		}
		
		/**
		 */		
		private function showTooltipHandler(evt:Event):void
		{
			this.showToolTips();
			statesControl.toHover();
		}
		
		/**
		 */		
		private function hideTooltipHandler(evt:Event):void
		{
			this.hideToolTips();
			statesControl.toNormal();
		}
		
		/**
		 */		
		public function initToolTips():void
		{
			if (this.tooltip.enable)
			{
				toolTipsHolder = new ToolTipHolder;
				toolTipsHolder.locked = tooltip.locked;
				
				var isUp:Boolean = true;
				
				if (Number(itemVO[this.value]) < 0)
					toolTipsHolder.isPositive = false;
				
				toolTipsHolder.isHorizontal = isHorizontal;
				
				var tooltipItem:TooltipDataItem = new TooltipDataItem;
				tooltipItem.metaData = itemVO.metaData;
				tooltipItem.style = this.tooltip;
				toolTipsHolder.pushTip(tooltipItem);
			}
		}
		
		/**
		 */		
		private var _tooltipStyle:TooltipStyle;

		/**
		 * 
		 */
		public function get tooltip():TooltipStyle
		{
			return _tooltipStyle;
		}

		/**
		 * @private
		 */
		public function set tooltip(value:TooltipStyle):void
		{
			_tooltipStyle = value;
		}
		
		/**
		 */		
		public function get xTipLabel():String
		{
			return itemVO.xLabel;
		}
		
		/**
		 */		
		public function get yTipLabel():String
		{
			return itemVO.yLabel;
		}
		
		/**
		 */		
		public function get zTipLabel():String
		{
			return '';
		}
		
		/**
		 */		
		protected var _toolTipsVO:ToolTipHolder;

		/**
		 */
		public function get toolTipsHolder():ToolTipHolder
		{
			return _toolTipsVO;
		}

		/**
		 * @private
		 */
		public function set toolTipsHolder(value:ToolTipHolder):void
		{
			_toolTipsVO = value;
		}
		
		/**
		 */		
		protected var canvas:Sprite = new Sprite;

		/**
		 * @param evt
		 */
		public function hoverHandler():void
		{
			y = _itemVO.dataItemY;
			
			dataRender.toHover();
		}
		
		/**
		 */		
		public function normalHandler():void
		{
			y = _itemVO.dataItemY;
			
			dataRender.toNormal();
		}
		
		/**
		 */		
		public function downHandler():void
		{
			this.y = itemVO.dataItemY + 1;
			
			dataRender.toDown();
			
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_CLICKED);
			event.dataItem = this._itemVO;
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		protected function showToolTips():void
		{
			if (this.tooltip.enable)
			{
				var location:Point = new Point(itemVO.dataItemX, itemVO.dataItemY);
				toolTipsHolder.location = this.parent.parent.localToGlobal(location);
				this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, toolTipsHolder));
			}
		}
		
		/**
		 */		
		protected function hideToolTips():void
		{
			if (this.tooltip.enable)
				this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}

		/**
		 *  Set item render position.             
		 */
		public function render():void
		{
			if (this.dataRender.enable)
			{
				canvas.graphics.clear();
				this.dataRender.render(this.canvas, itemVO.metaData);
				this.radius = canvas.width / 2;
			}
		}
		
		/**
		 */		
		public function layout():void
		{
			x = _itemVO.dataItemX;
			y = _itemVO.dataItemY;
			if (this.valueLabel.enable)
			{
				if(valueLabelUI == null)
				{
					valueLabelUI = createValueLabelUI()
					//addChild(valueLabelUI);
					layoutValueLabel();
				}
			}
		}
		
		/**
		 */		
		protected function createValueLabelUI():Bitmap
		{
			var labelUI:LabelUI  = new LabelUI();
			labelUI.style = this.valueLabel;
			labelUI.metaData = this.itemVO.metaData;
			labelUI.render();
			
			return BitmapUtil.drawBitmap(labelUI);
		}
		
		/**
		 * 数值字段， 用来判断toolTip提示的方向；
		 */		
		private var _valueField:String = 'xValue';
		
		public function get value():String
		{
			return _valueField;
		}
		
		public function set value(value:String):void
		{
			_valueField = value;
		}
		
		/**
		 */		
		protected function layoutValueLabel():void
		{
			if (this.valueLabel.layout == LabelStyle.VERTICAL)
			{
				valueLabelUI.rotation = - 90;
				valueLabelUI.x = - valueLabelUI.width / 2;
				
				if (Number(_itemVO.yValue) < 0)
					valueLabelUI.y = this.radius + valueLabelUI.height + this.valueLabel.margin;
				else
					valueLabelUI.y = - this.radius - this.valueLabel.margin;
			}
			else
			{
				valueLabelUI.x = - valueLabelUI.width / 2;
				
				if (Number(_itemVO.yValue) < 0)
					valueLabelUI.y = this.radius + this.valueLabel.margin;
				else
					valueLabelUI.y = - this.radius - valueLabelUI.height - this.valueLabel.margin;
			}
		}
		
		/**
		 */		
		public var valueLabelUI:Bitmap;

		/**
		 */
		protected var _itemVO:SeriesDataPoint;

		public function get itemVO():SeriesDataPoint
		{
			return _itemVO;
		}

		public function set itemVO(v:SeriesDataPoint):void
		{
			_itemVO = v;
			
			legendStateContorl = new LegendStateControl(_itemVO, this.statesControl);
			
			_itemVO.addEventListener(ItemRenderEvent.SHOW_TOOLTIP, showTooltipHandler, false, 0, true);
			_itemVO.addEventListener(ItemRenderEvent.HIDE_TOOLTIP, hideTooltipHandler, false, 0, true);
		}
		
		/**
		 */		
		protected var legendStateContorl:LegendStateControl;
		
		/**
		 */		
		private var _dataRender:DataRender;

		/**
		 */
		public function get dataRender():DataRender
		{
			return _dataRender;
		}

		/**
		 * @private
		 */
		public function set dataRender(value:DataRender):void
		{
			_dataRender = value;
			_dataRender.toNormal();
		}
		
		/**
		 */		
		private var _style:Style;
		
		public function get style():Style
		{
			return _style;
		}
		
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 * 数值标签的文字样式 
		 */		
		protected var _valueLabel:LabelStyle;

		/**
		 */
		public function get valueLabel():LabelStyle
		{
			return _valueLabel;
		}

		/**
		 * @private
		 */
		public function set valueLabel(value:LabelStyle):void
		{
			_valueLabel = value;
		}
		
		/**
		 */		
		private var _states:States;

		/**
		 */
		public function get states():States
		{
			return _states;
		}

		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		protected var statesControl:StatesControl;;

	}
}