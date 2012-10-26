package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;

	public class DataScale
	{
		public function DataScale()
		{
		}
		
		/**
		 * 缩放的倍数 
		 */		
		private var _zoomScale:Number = 0.2;

		/**
		 * 
		 */
		public function get zoomScale():Number
		{
			return _zoomScale;
		}

		/**
		 * @private
		 */
		public function set zoomScale(value:Number):void
		{
			_zoomScale = value;
		}

		
		/**
		 * 最大缩放
		 */		
		private var _maxScale:Number = 10;

		public function get maxScale():Number
		{
			return _maxScale;
		}

		public function set maxScale(value:Number):void
		{
			_maxScale = value;
		}

		/**
		 */		
		private var _enable:Object

		public function get enable():Object
		{
			return _enable;
		}

		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		private var _start:String;

		/**
		 */
		public function get start():String
		{
			return _start;
		}

		/**
		 * @private
		 */
		public function set start(value:String):void
		{
			_start = value;
			
			changed = true;
		}

		/**
		 */		
		private var _end:String

		public function get end():String
		{
			return _end;
		}

		public function set end(value:String):void
		{
			_end = value;
			
			changed = true;
		}
		
		/**
		 */		
		public var changed:Boolean = false;

	}
}