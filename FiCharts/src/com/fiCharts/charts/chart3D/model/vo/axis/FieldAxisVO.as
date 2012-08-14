package com.fiCharts.charts.chart3D.model.vo.axis
{
	import com.fiCharts.charts.common.ChartDataFormatter;

	public class FieldAxisVO extends AxisBaseVO
	{
		public function FieldAxisVO()
		{
			super();
		}
		
		
		override public function formatXValue(value:Object):String
		{
			return dataFormatter.formatXString(value);
		}
		
		override public function formatYValue(value:Object):String
		{
			return dataFormatter.formatYString(value);
		}
		
		/**
		 */		
		override public function redyToUpdateData():void
		{
			fields = new Vector.<String>();
		}
		
		/**
		 * @param value
		 */		
		override public function updateData(value:Vector.<Object>) : void
		{
			for each (var item:Object in value)
			{
				if (fields.indexOf(item) == -1)
					fields.push(item.toString());
			}
		}
		
		/**
		 */		
		override public function dataUpdated():void
		{
			ifAxisDataChanged = true;
		}
		
		/**
		 */		
		override public function generateAxisLabelVO():void
		{
			if (ifAxisDataChanged && fields)
			{
				this.labels = new Vector.<AxisLabelVO>();
				var length:uint = fields.length;
				var labelVO:AxisLabelVO;
				for (var i:uint = 0; i < length; i ++)
				{
					labelVO = new AxisLabelVO();
					labelVO.value = fields[i];
					
					if (this.direction == AxisBaseVO.HORIZONTAL_AXIS)
						labelVO.label = dataFormatter.formatXString(labelVO.value);
					else
						labelVO.label = dataFormatter.formatYString(labelVO.value);
					
					labels.push(labelVO);
				}
				
				ifAxisDataChanged = false;
			}
			
			this.unitSize = this.size / labels.length;
		}
		
		/**
		 */		
		private var ifAxisDataChanged:Boolean = false;
		
		/**
		 */		
		override public function layoutHorizontalLabels() : void
		{
			this._ticks = new Vector.<Number>;
			for each(var labelVO:AxisLabelVO in labels)
			{
				labelVO.x = valueToSize(labelVO.value);
				labelVO.y = gutter + this.labelOffSet;
				_ticks.push(labelVO.x - this.unitSize / 2);
			}
			
			_ticks.push(_ticks[_ticks.length - 1] + this.unitSize);
		}
		
		/**
		 */		
		override public function layoutVerticalLabels() : void
		{
			this._ticks = new Vector.<Number>;
			for each(var labelVO:AxisLabelVO in labels)
			{
				labelVO.x = - gutter - this.labelOffSet;
				labelVO.y = - valueToSize(labelVO.value);
				_ticks.push(labelVO.y);
			}
		}
		
		/**
		 */		
		private var fields:Vector.<String>;
		
		/**
		 * @param value
		 * @return 
		 */		
		override public function valueToSize(value:Object):Number
		{
			var resultSize:Number;
			resultSize = unitSize * .5 +  fields.indexOf(value.toString()) * unitSize;
			
			return resultSize;
		}
		
	}
}