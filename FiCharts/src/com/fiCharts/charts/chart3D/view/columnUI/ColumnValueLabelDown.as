package com.fiCharts.charts.chart3D.view.columnUI
{
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnVO;

	public class ColumnValueLabelDown extends ColumnValueLabelBase
	{
		public function ColumnValueLabelDown(labelString:String)
		{
			super(labelString);
		}
		
		/**
		 */		
		override public function layout(renderVO:ColumnVO):void
		{
			x = renderVO.location2D.x + renderVO.xSize / 2;
			y = renderVO.location2D.y + renderVO.ySize + bgHeight / 2 + 5;
		}
		
		/**
		 */		
		override public function render():void
		{
			valueLabel.reLabel(labelString);
			valueLabel.x = - valueLabel.width / 2;
			valueLabel.y = - valueLabel.height / 2;
			
			this.graphics.clear();
			drawFill();
			
			var w:Number = 10;
			var h:Number = - 6;
			var offY:Number = - bgHeight / 2;
			var offX:Number = 0;
			
			graphics.beginFill(uint(fillStyle.color), Number(fillStyle.alpha));
			graphics.moveTo(offX, offY);
			graphics.lineTo(w / 2 + offX, offY);
			graphics.lineTo(offX, h + offY);
			graphics.lineTo(- w / 2 + offX, offY);
			graphics.lineTo(offX, offY);
			graphics.endFill();
		}
	}
}