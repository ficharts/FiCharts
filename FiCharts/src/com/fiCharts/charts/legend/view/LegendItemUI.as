package com.fiCharts.charts.legend.view
{
	import com.fiCharts.charts.legend.LegendIconStyle;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.charts.legend.model.LegendVO;
	import com.fiCharts.charts.legend.view.itemRender.RecItemRender;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class LegendItemUI extends Sprite
	{
		/**
		 */		
		private var vo:LegendVO;
		
		/**
		 */		
		public function LegendItemUI(vo:LegendVO)
		{
			super();
			this.vo = vo;
			
			this.mouseChildren = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			if (this.ifShow)
			{
				this.vo.dispatchEvent(new LegendEvent(LegendEvent.HIDE_LEGEND, vo));
				this.filters =  StyleManager.getDisableFilter();
				this.ifShow = false;
				this.alpha = .8;
			}
			else
			{
				this.vo.dispatchEvent(new LegendEvent(LegendEvent.SHOW_LEGEND, vo));
				this.filters = null;
				this.ifShow = true;
				this.alpha = 1;
			}
			
			this.y += 1;
		}
		
		/**
		 */		
		private function upHandler(evt:MouseEvent):void
		{
			this.y = sourceY;
		}
		
		/**
		 */		
		private var sourceY:Number;
		
		/**
		 */		
		private var ifShow:Boolean = true;
		
		/**
		 */		
		private function overHandler(evt:MouseEvent):void
		{
			icoRender.toHover();
			sourceY = this.y;
			this.vo.dispatchEvent(new LegendEvent(LegendEvent.LEGEND_ITEM_OVER, vo));
		}
		
		/**
		 */		
		private function outHandler(evt:MouseEvent):void
		{
			icoRender.toNormal();
			this.y = sourceY;
			this.vo.dispatchEvent(new LegendEvent(LegendEvent.LEGEND_ITEM_OUT, vo));
		}
		
		/**
		 */		
		public function render(style:LegendStyle):void
		{
			var labelStyle:LabelStyle = style.label;
			var iconStyle:LegendIconStyle = style.icon;
			
			icoRender = vo.itemRender as RecItemRender;
			icoRender.states = iconStyle.states;
			icoRender.render();
			addChild(icoRender as DisplayObject);
			
			var label:LabelUI = new LabelUI();
			label.metaData = vo.metaData;
			label.style = labelStyle;
			label.render();
			//ChartColorManager.labelShadow(label, labelStyle);
			label.x = icoRender.width + style.hPadding;
			
			var fullHeight:uint = (label.height > icoRender.height) ? label.height : icoRender.height;
			
			if (label.height >= icoRender.height)
				label.y = (label.height - fullHeight) / 4;
			else
				label.y = (fullHeight - label.height) / 2;
			
			(icoRender as DisplayObject).y = (fullHeight - icoRender.height) / 2;
			addChild(label);
			
			// 绘制填充背景， 
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, this.width, this.height);
		}
		
		/**
		 */		
		private var icoRender:RecItemRender;
	}
}