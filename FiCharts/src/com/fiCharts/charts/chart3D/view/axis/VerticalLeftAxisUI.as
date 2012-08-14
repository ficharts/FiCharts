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
	
	public class VerticalLeftAxisUI extends AxisUIBase
	{
		public function VerticalLeftAxisUI()
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
			
			if (axisVO.labelColor)
				axisLabelFormat.color = axisVO.labelColor;
			
			for each(var item:AxisLabelVO in axisVO.labels)
			{
				if (axisVO.labelLayout == AxisBaseVO.ROTATION)
				{
					labelUI = TextBitmapUtil.drawText(item.label, axisLabelFormat);
					labelX = - Math.cos(Math.PI / 4) * labelUI.width - 
						Math.cos(Math.PI / 4) * labelUI.height / 2;
					
					labelY = Math.sin(Math.PI / 4) * labelUI.width - 
						Math.cos(Math.PI / 4) * labelUI.height;
					
					labelUI.rotation = - 45;
				}
				else
				{
					labelUI = new Label(item.label);
					(labelUI as Label).renderText(axisLabelFormat);
					labelX = - (labelUI as Label).textWidth;
					labelY = - (labelUI as Label).textHeight / 2;
				}
				
				labelUI.x = item.x + labelX;
				labelUI.y = item.y + labelY;
				addChild(labelUI);
			}
			
			// 绘制刻度线
			graphics.clear();
			graphics.lineStyle(chartConfig.axisLine.thikness, uint(chartConfig.axisLine.color), 
				chartConfig.axisLine.alpha);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(0, - axisVO.size);
			for each (var i:Number in axisVO.ticks)
			{
				graphics.moveTo(0, i);
				graphics.lineTo(- 5, i);
			}
			
			//绘制标题
			if (axisVO.title)
			{
				var titleFormat:TextFormat = chartConfig.axisTitleStyle.getTextFormat();
				
				if (axisVO.labelColor)
					titleFormat.color = axisVO.labelColor;
				
				var titleLabel:Bitmap = TextBitmapUtil.drawText(axisVO.title, titleFormat);
				titleLabel.rotation =  - 90;
				titleLabel.x = - this.width - titleLabel.width;
				titleLabel.y = - axisVO.size / 2 + titleLabel.height / 2;
				addChild(titleLabel);
			}
		}
	}
}