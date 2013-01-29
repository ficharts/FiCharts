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
	public class Cover extends Style implements IFiElement
	{
		public function Cover()
		{
			super();
		}
		
		/**
		 * 
		 * 在没有填充和边框的情况下，因为之前已设置了填充和边框，
		 * 
		 * 这会导致即便无效的cover也会被借助之前的设置而绘制
		 * 
		 */		
		override public function get enable():Object
		{
			return (this.border || this.fill);
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