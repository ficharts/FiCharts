package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectable;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Cover;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;

	/**
	 * 
	 * 比基础样式多了内外边距及圆角设置；
	 * 
	 * @author wallen
	 * 
	 */	
	public class ContainerStyle extends Style implements IEffectable, IStyleElement
	{
		public function ContainerStyle()
		{
			super();
		}
		
		/**
		 * 简化同时设置外边距 
		 */		
		private var _margin:Number = 5;

		/**
		 */
		public function get margin():Number
		{
			return _margin;
		}

		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			_margin = this.vMargin = this.hMargin = value;
		}
		
		/**
		 */		
		private var _hMargin:Number = 5;

		public function get hMargin():Number
		{
			return _hMargin;
		}

		public function set hMargin(value:Number):void
		{
			_hMargin = value;
		}

		/**
		 */		
		private var _vMargin:Number = 5;

		public function get vMargin():Number
		{
			return _vMargin;
		}

		public function set vMargin(value:Number):void
		{
			_vMargin = value;
		}
		
		/**
		 * 简化同时设置内边距 
		 */		
		private var _padding:Number = 5;

		/**
		 */
		public function get padding():Number
		{
			return _padding;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			_padding = this.vPadding = this.hPadding = value;
		}

		/**
		 */		
		private var _hPadding:Number = 3;

		public function get hPadding():Number
		{
			return _hPadding;
		}

		public function set hPadding(value:Number):void
		{
			_hPadding = this.paddingLeft = this.paddingRight = value;
		}
		
		/**
		 */		
		private var _paddingLeft:Number = 3;

		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}

		/**
		 */		
		private var _paddingRight:Number = 3;

		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		/**
		 */		
		private var _vPadding:Number = 3;

		public function get vPadding():Number
		{
			return _vPadding;
		}

		public function set vPadding(value:Number):void
		{
			_vPadding = this.paddingTop = this.paddingBottom = value;
		}
		
		/**
		 */		
		private var _paddingTop:Number = 3;

		/**
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}

		/**
		 */		
		private var _paddingBottom:Number = 3;

		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}
		
	}
}