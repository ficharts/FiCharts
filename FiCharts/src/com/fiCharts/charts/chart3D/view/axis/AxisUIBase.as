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
	
	public class AxisUIBase extends Sprite
	{
		private var _axisVO:AxisBaseVO;
		
		/**
		 * @param axisVO
		 */		
		public function AxisUIBase()
		{
			super();
		}
		
		public function get axisVO():AxisBaseVO
		{
			return _axisVO;
		}

		public function set axisVO(value:AxisBaseVO):void
		{
			_axisVO = value;
		}

		/**
		 */		
		protected function layoutAxis():void
		{
			if (axisVO)
			{
				this.x = axisVO.location2D.x;
				this.y = axisVO.location2D.y;
			}
		}
		
		/**
		 */		
		public function render(configVO:Chart3DConfig):void
		{
			
		}
		
		/**
		 */		
		protected function clear():void
		{
			while(this.numChildren)
				this.removeChildAt(0);
		}
	}
}