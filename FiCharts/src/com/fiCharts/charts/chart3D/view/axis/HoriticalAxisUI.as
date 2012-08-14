package com.fiCharts.charts.chart3D.view.axis
{
	import com.fiCharts.charts.chart3D.model.Chart3DConfig;
	import com.fiCharts.charts.chart3D.model.vo.axis.AxisBaseVO;
	import com.fiCharts.charts.chart3D.model.vo.axis.AxisLabelVO;
	import com.fiCharts.ui.text.Label;
	import com.fiCharts.utils.graphic.TextBitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 */	
	public class HoriticalAxisUI extends AxisUIBase
	{
		public function HoriticalAxisUI()
		{
			super();
		}
		
		/**
		 */		
		override public function render(chartConfig:Chart3DConfig):void
		{
			layoutAxis();
			clear();
			
			var labelUI:DisplayObject;
			var labelX:Number;
			var labelY:Number;
			
			var axisLabelFormat:TextFormat = chartConfig.axisLabelStyle.getTextFormat();
			
			for each(var item:AxisLabelVO in axisVO.labels)
			{
				if (axisVO.labelLayout == AxisBaseVO.NORMAL)
				{
					labelUI = new Label(item.label);
					(labelUI as Label).renderText(axisLabelFormat);
					labelX = - (labelUI as Label).textWidth / 2;
					labelY = 0;
				}
				else if (axisVO.labelLayout == AxisBaseVO.WRAP)
				{
					labelUI = new Label(item.label, true);
					labelUI.width = axisVO.unitSize;
					(labelUI as Label).setTextFormat(axisLabelFormat);
					(labelUI as Label).reLabel(item.label);
					
					labelX = - (labelUI as Label).textWidth / 2;
					labelY = 0;
				}
				else if (axisVO.labelLayout == AxisBaseVO.ROTATION)
				{
					labelUI = TextBitmapUtil.drawText(item.label, axisLabelFormat);
					labelX = - Math.cos(Math.PI / 4) * labelUI.width;
					labelY = Math.sin(Math.PI / 4) * labelUI.width;
					labelUI.rotation = - 45;
				}
				
				labelUI.x = item.x + labelX;
				labelUI.y = item.y + labelY;
				addChild(labelUI);
			}
			
			//绘制刻度线
			graphics.clear();
			graphics.lineStyle(chartConfig.axisLine.thikness, uint(chartConfig.axisLine.color), chartConfig.axisLine.alpha);
			graphics.moveTo(0, 0);
			graphics.lineTo(axisVO.size, 0);
			for each (var i:Number in axisVO.ticks)
			{
				graphics.moveTo(i, 0);
				graphics.lineTo(i, 5);
			}
			
			//绘制标题
			if (axisVO.title == "") return;
			
			var titleFormat:TextFormat = chartConfig.axisTitleStyle.getTextFormat();
			
			if (axisVO.labelColor)
				titleFormat.color = axisVO.labelColor;
			
			var horiticalTitle:Label = new Label(axisVO.title);
			horiticalTitle.renderText(titleFormat);
			
			horiticalTitle.x = (axisVO.size - horiticalTitle.textWidth) / 2;
			horiticalTitle.y = this.height + axisVO.gutter;
			addChild(horiticalTitle);
		}
	}
}