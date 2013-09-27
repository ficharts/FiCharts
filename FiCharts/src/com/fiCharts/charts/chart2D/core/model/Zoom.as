package com.fiCharts.charts.chart2D.core.model
{
	import com.fiCharts.charts.chart2D.encry.CB;
	import com.fiCharts.utils.XMLConfigKit.XMLVOLib;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;

	/**
	 * 
	 * 数据缩放是非常关键的功能分水岭，开启后，图表的构建与渲染模式会大调：
	 * 
	 * 1.ItemRender 与  ValueLabel 不在构建，信息提示模式改为全局模式，统一处理；
	 * 
	 * 2.图表序列节点不再渲染，而是范围内数据一起渲染在序列Canvas上
	 * 
	 * 3.图表整体渲染模式也会改变， 不再进行动画，并且直接根据数据范围渲染局部数据
	 * 
	 * 4.如果没有设定数据范围时，默认渲染所有数据；
	 * 
	 * 5.主程序会存在两种状态，缩放态和经典态，而且可以相互变态；
	 * 
	 * 6.主程序的状态切换会映射到坐标轴和序列上；
	 * 
	 * 7.当关闭缩放条和滚轮缩放功能时，大数据进入简装版，和经典模式看起来差不多，但是渲染效率深不可测
	 *  
	 */	
	public class Zoom
	{
		public function Zoom()
		{
		}
		
		/**
		 * 缩放的倍数 
		 */		
		private var _zoomInScale:Number = 0.3;

		/**
		 * 放大的比率
		 */
		public function get zoomInScale():Number
		{
			return _zoomInScale;
		}

		/**
		 * @private
		 */
		public function set zoomInScale(value:Number):void
		{
			_zoomInScale = value;
		}
		
		/**
		 * 缩小比率 
		 */		
		private var _zoomOutScale:Number = 0.8;

		/**
		 */
		public function get zoomOutScale():Number
		{
			return _zoomOutScale;
		}

		/**
		 * @private
		 */
		public function set zoomOutScale(value:Number):void
		{
			_zoomOutScale = value;
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

		/**
		 */		
		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
			
			if (_enable)
				XMLVOLib.dispatchCreation(CB.TO_ZOOM_PATTERN);
			else
				XMLVOLib.dispatchCreation(CB.TO_CLASSIC_PATTERN);
		}
		
		/**
		 * 默认大数据下滚轮缩放时开启的，也可以禁用滚轮缩放
		 */		
		private var _mouseWheel:Object = true;

		/**
		 */
		public function get mouseWheel():Object
		{
			return _mouseWheel;
		}

		/**
		 * @private
		 */
		public function set mouseWheel(value:Object):void
		{
			_mouseWheel = XMLVOMapper.boolean(value);
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