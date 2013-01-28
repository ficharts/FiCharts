package com.fiCharts.utils.XMLConfigKit.style
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.effect.Effects;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectable;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Cover;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFiElement;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFreshElement;
	
	/**
	 * 通常用来设置矩形或者原型的样式，包含填充，边框及基本的尺寸信息；
	 */
	public class Style implements IEffectable, IFiElement, IFreshElement
	{
		public function Style()
		{
		}
		
		/**
		 */		
		public function fresh():void
		{
			effects = new Effects;
			cover = new Cover;
			fill = new Fill;
			border = new BorderLine;
		}
		
		/**
		 */		
		private var _enable:Object = true;

		public function get enable():Object
		{
			return _enable;
		}

		/**
		 */		
		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		private var _effects:Effects;

		/**
		 */
		public function get effects():Object
		{
			return _effects;
		}

		/**
		 * @private
		 */
		public function set effects(value:Object):void
		{
			_effects = XMLVOMapper.updateObject(value, _effects, "effects", this) as Effects;
		}

		/**
		 */		
		private var _ty:Number = 0;
		
		public function get ty():Number
		{
			return _ty;
		}
		
		public function set ty(value:Number):void
		{
			_ty = value;
		}
		
		/**
		 */		
		private var _tx:Number = 0;
		
		/**
		 */		
		public function get tx():Number
		{
			return _tx;
		}
		
		public function set tx(value:Number):void
		{
			_tx = value;
		}
		
		/**
		 */		
		private var _width:Number = 10;

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		/**
		 */		
		private var _height:Number = 10;

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		/**
		 * 如果是圆形则代表半径， 举行则代表圆角半径；
		 */		
		private var _radius:Number = 0;
		
		/**
		 */
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		/**
		 */		
		private var _cover:Cover;

		/**
		 */
		public function get cover():Object
		{
			return _cover;
		}
		
		/**
		 */		
		public function get getCover():Cover
		{
			if (_cover)
			{
				_cover.width = this.width;
				_cover.height = this.height;
				_cover.tx = this.tx;
				_cover.ty = this.ty;
				_cover.radius = this.radius;
			}
			
			return _cover;
		}

		/**
		 * @private
		 */
		public function set cover(value:Object):void
		{
			_cover = XMLVOMapper.updateObject(value, _cover, "cover", this) as Cover;
		}
		
		/**
		 */		
		private var _fill:Fill;

		public function get fill():Object
		{
			return _fill;
		}

		public function set fill(value:Object):void
		{
			_fill = XMLVOMapper.updateObject(value, _fill, "fill", this) as Fill;
		}
		
		public function get getFill():Fill
		{
			return _fill;
		}

		/**
		 */		
		private var _line:BorderLine;

		public function get border():Object
		{
			return _line;
		}

		public function set border(value:Object):void
		{
			_line = XMLVOMapper.updateObject(value, _line, "border", this) as BorderLine;
		}
		
		/**
		 */		
		public function get getBorder():BorderLine
		{
			return _line;
		}
		
	}
}