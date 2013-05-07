package com.fiCharts.charts.chart2D.bubble
{
	import com.fiCharts.charts.chart2D.core.series.ISeriesRenderPattern;
	
	public class ClassicBubbleRender implements ISeriesRenderPattern
	{
		public function ClassicBubbleRender(bubble:BubbleSeries)
		{
			this.bubble = bubble;
		}
		
		/**
		 */		
		private var bubble:BubbleSeries;
		
		/**
		 */		
		public function toClassicPattern():void
		{
			
		}
		
		/**
		 */		
		public function toSimplePattern():void
		{
			if (bubble.simplePattern)
				bubble.curRenderPattern = bubble.simplePattern;
			else
				bubble.curRenderPattern = bubble.simplePattern = new SimpleBubbleRender(bubble);
			
			bubble.clearCanvas();
		}
		
		/**
		 */		
		public function renderScaledData():void
		{
		}
		
		/**
		 */		
		public function render():void
		{
			if (bubble.ifDataChanged || bubble.ifSizeChanged)
			{
				bubble.applyDataFeature();
				
				//创建新数据点
				if (bubble.ifDataChanged)
				{
					bubble.initData();
					bubble.createItemRenders();
					bubble.clearCanvas();
				}
				
				//更新尺寸信息
				bubble.layoutDataItems(0, bubble.maxDataItemIndex);
				bubble.ifSizeChanged = bubble.ifDataChanged = false;
			}
		}
	}
}