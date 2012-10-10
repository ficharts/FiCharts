package com.fiCharts.ui.toolTips
{
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	
	import flash.geom.Point;

	public class ToolTipHolder extends TooltipDataItem
	{
		public function ToolTipHolder()
		{
		}
		
		/**
		 */		
		public function pushTip(tip:Object):void
		{
			tooltips.push(tip);
		}
		
		/**
		 */		
		public function get tipLength():uint
		{
			return this.tooltips.length;
		}
		
		/**
		 * 重叠的渲染节点会合并成一个， 合并后LabelVO保存在同一个数组中； 
		 */		
		private var _tooltips:Vector.<TooltipDataItem> = new Vector.<TooltipDataItem>;

		/**
		 */
		public function get tooltips():Vector.<TooltipDataItem>
		{
			return _tooltips;
		}

		/**
		 * @private
		 */
		public function set tooltips(value:Vector.<TooltipDataItem>):void
		{
			_tooltips = value;
		}

		/**
		 */		
		private var _location:Point;

		/**
		 */
		public function get location():Point
		{
			return _location;
		}

		/**
		 * @private
		 */
		public function set location(value:Point):void
		{
			_location = value;
		}
		
		/**
		 */		
		private var _locked:Boolean;

		/**
		 */
		public function get locked():Boolean
		{
			return _locked;
		}

		/**
		 * @private
		 */
		public function set locked(value:Boolean):void
		{
			_locked = value;
		}

		
		/**
		 * 是否数值为正
		 */		
		private var _isPositive:Boolean = true;

		/**
		 */
		public function get isPositive():Boolean
		{
			return _isPositive;
		}

		/**
		 * 是否为水平数值， Bar 图会用到;
		 */
		public function set isPositive(value:Boolean):void
		{
			_isPositive = value;
		}
		
		/**
		 */		
		private var _isHorizontal:Boolean = false;

		/**
		 */
		public function get isHorizontal():Boolean
		{
			return _isHorizontal;
		}

		/**
		 * @private
		 */
		public function set isHorizontal(value:Boolean):void
		{
			_isHorizontal = value;
		}

	}
}