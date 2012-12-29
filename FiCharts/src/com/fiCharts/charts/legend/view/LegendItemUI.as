package com.fiCharts.charts.legend.view
{
	import com.fiCharts.charts.chart2D.core.model.DataRender;
	import com.fiCharts.charts.legend.LegendStyle;
	import com.fiCharts.charts.legend.model.LegendVO;
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
			icoRender.render(this, vo.metaData);
			
			sourceY = this.y;
			this.vo.dispatchEvent(new LegendEvent(LegendEvent.LEGEND_ITEM_OVER, vo));
		}
		
		/**
		 */		
		private function outHandler(evt:MouseEvent):void
		{
			icoRender.toNormal();
			icoRender.render(this, vo.metaData);
			
			this.y = sourceY;
			this.vo.dispatchEvent(new LegendEvent(LegendEvent.LEGEND_ITEM_OUT, vo));
		}
		
		/**
		 */		
		public function render(style:LegendStyle):void
		{
			this.graphics.clear();
			
			var labelStyle:LabelStyle = style.label;
			
			if (vo.iconRender)
				icoRender = vo.iconRender;
			else
				icoRender = style.icon;
			
			icoRender.toNormal();
			icoRender.render(iconShape, vo.metaData);
			this.addChild(iconShape);
			
			var label:LabelUI = new LabelUI();
			label.metaData = vo.metaData;
			label.style = labelStyle;
			label.render();
			label.x = this.width + style.hPadding;
			
			var fullHeight:uint = (label.height > iconShape.height) ? label.height : iconShape.height;
			
			if (label.height >= iconShape.height)
				label.y = (label.height - fullHeight) / 4;
			else
				label.y = (fullHeight - label.height) / 2;
			
			iconShape.y = (fullHeight - iconShape.height) / 2;
			addChild(label);
			
			// 绘制填充背景， 
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, this.width, this.height);
		}
		
		/**
		 */		
		private var iconShape:Sprite = new Sprite;
		
		/**
		 */		
		private var icoRender:DataRender;
	}
}