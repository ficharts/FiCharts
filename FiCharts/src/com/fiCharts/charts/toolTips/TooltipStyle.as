package com.fiCharts.charts.toolTips
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;

	/**
	 *
	 * 当同时要显示几个数据节点信息时， 采用  group 样式， 
	 * 
	 * 默认仅有一个数据节点信息时采用 self 样式；
	 *  
	 * @author wallen
	 * 
	 */	
	public class TooltipStyle extends LabelStyle
	{
		public function TooltipStyle()
		{
		}
		
		/**
		 */		
		public function set label(value:String):void
		{
			if (self == null) self = new LabelStyle;
			if (group == null) group = new LabelStyle;
			
			self.text.value = value;
			group.text.value = value;
		}
		
		/**
		 */		
		public function get label():String
		{
			if (self)
				return self.text.value
			else if (group)
				return group.text.value;
			else
				return null;
		}
		
		/**
		 */		
		private var _normal:LabelStyle;

		public function get self():LabelStyle
		{
			return _normal;
		}

		public function set self(value:LabelStyle):void
		{
			_normal = value;
		}
		
		/**
		 */		
		private var _group:LabelStyle;

		public function get group():LabelStyle
		{
			return _group;
		}

		public function set group(value:LabelStyle):void
		{
			_group = value;
		}
		
		/**
		 */		
		private var _locked:Boolean = false;
		
		/**
		 */
		public function get locked():Object
		{
			return _locked;
		}
		
		/**
		 * @private
		 */
		public function set locked(value:Object):void
		{
			_locked = XMLVOMapper.boolean(value);
		}

	}
}