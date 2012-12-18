package com.fiCharts.charts.chart2D.pie.series
{
	import com.fiCharts.charts.chart2D.core.events.FiChartsEvent;
	import com.fiCharts.charts.chart2D.core.series.SeriesItemUIBase;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.charts.toolTips.ToolTipHolder;
	import com.fiCharts.charts.toolTips.ToolTipsEvent;
	import com.fiCharts.charts.toolTips.TooltipStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class PartPieUI extends SeriesItemUIBase
	{
		public function PartPieUI(dataItem:SeriesDataItemVO)
		{
			super(dataItem);
			
			midRad = pieDataItem.startRad + (pieDataItem.endRad - pieDataItem.startRad) / 2;
		}
		
		/**
		 */		
		private var tooltipHolder:ToolTipHolder = new ToolTipHolder();
		
		/**
		 */		
		override protected function rollOverHandler(evt:MouseEvent):void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_OVER);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
			
			this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tooltipHolder));
		}
		
		/**
		 */		
		override protected function rollOutHandler(evt:MouseEvent):void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_OUT);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
			
			this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		/**
		 */		
		override public function downHandler():void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_CLICKED);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		public function init():void
		{
			valueLabelUI = new LabelUI;
			valueLabelUI.style = this.labelStyle;
			valueLabelUI.metaData = this.dataItem.metaData;
			valueLabelUI.render();
			addChild(valueLabelUI);
			
			tooltipHolder.metaData = dataItem.metaData;
			tooltipHolder.style = tooltipStyle;
		}
		
		/**
		 */		
		public var labelStyle:LabelStyle;
		
		/**
		 */		
		public var tooltipStyle:TooltipStyle;
		
		/**
		 */
		public function get rads():Vector.<Number>
		{
			return _rads;
		}

		/**
		 * @private
		 */
		public function set rads(value:Vector.<Number>):void
		{
			_rads = value;
		}

		/**
		 */		
		public function get angleRadRange():Number
		{
			return pieDataItem.endRad - pieDataItem.startRad;
		}
		
		/**
		 */		
		public function get pieDataItem():PieDataItem
		{
			return dataItem as PieDataItem;
		}
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.clear();
			
			style.tx = - radius;
			style.ty = - radius;
			style.width = style.height = radius * 2;
			
			StyleManager.drawArc(this, style, radius, rads, pieDataItem.metaData);
			
			layoutValueLabel();
		}
		
		/**
		 * 调整数值标签的位置及显示
		 */		
		private function layoutValueLabel():void
		{
			if (ifSizeChanged)
			{
				valueLabelUI.layout(radius * 0.8 * Math.cos(midRad), - radius * 0.8 * Math.sin(midRad));
				if (valueLabelUI.width > radius)
					valueLabelUI.visible = false;
				else
					valueLabelUI.visible = true;
				
				ifSizeChanged = false;
			}
		}
		
		
		
		/**
		 */		
		private var valueLabelUI:LabelUI;
		
		/**
		 */		
		private var _rads:Vector.<Number>
		
		
		/**
		 * 扇形弧度的中间值， 用来定位数值标签的位置； 
		 */		
		private var midRad:Number;
		
		
		/**
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
			if (_radius != value)
			{
				_radius = value;
				ifSizeChanged = true;			
			}
		}

		/**
		 */		
		private var ifSizeChanged:Boolean = false;

	}
}