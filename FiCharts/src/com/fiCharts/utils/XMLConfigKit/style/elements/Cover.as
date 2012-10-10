package com.fiCharts.utils.XMLConfigKit.style.elements
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.StyleManager;

	/**
	 * 
	 * 高光效果的样式配置
	 *  
	 * @author wallen
	 * 
	 */	
	public class Cover extends Style implements IStyleElement
	{
		public function Cover()
		{
			super();
		}
		
		/**
		 */		
		private var _reverse:Object = false;

		/**
		 * 垂直矩形，高光默认是在左上， 左下 ，如果翻转相互逆转；
		 * 
		 * 水平矩形，高光默认是在左上，右上， 如果翻转相互逆转；
		 */
		public function get reverse():Object
		{
			return _reverse;
		}

		/**
		 * @private
		 */
		public function set reverse(value:Object):void
		{
			_reverse = value;
		}
		
		/**
		 * 高光线距离形状边缘的偏移量； 
		 */		
		private var _offset:Number = 1;

		/**
		 */
		public function get offset():Number
		{
			return _offset;
		}

		/**
		 * @private
		 */
		public function set offset(value:Number):void
		{
			_offset = value;
		}


	}
}