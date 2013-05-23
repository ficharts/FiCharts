package
{
	import com.fiCharts.charts.toolTips.ToolTipHolder;
	import com.fiCharts.charts.toolTips.ToolTipsEvent;
	import com.fiCharts.utils.RexUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class TipsHolder
	{
		/**
		 */		
		public function TipsHolder(target:ITipsSender)
		{
			this._target = target;	
			
			tipsVO.metaData = target;
			
			this.target.addEventListener(MouseEvent.ROLL_OVER, overHandler, false, 0, true);
			this.target.addEventListener(MouseEvent.ROLL_OUT, outHandler, false, 0, true);
		}
		
		/**
		 */		
		private function get target():EventDispatcher
		{
			return _target as EventDispatcher
		}
		
		/**
		 */		
		private function overHandler(evt:MouseEvent):void
		{
			if (RexUtil.ifTextNull(_target.tips) == false)
				target.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tipsVO));
		}
		
		/**
		 */		
		private var tipsVO:ToolTipHolder = new ToolTipHolder;
		
		/**
		 */		
		private function outHandler(evt:MouseEvent):void
		{
			target.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		/**
		 */		
		private var _target:ITipsSender
		
		/**
		 */		
		private var _tips:String = '';

		/**
		 */
		public function get tips():String
		{
			return _tips;
		}

		/**
		 * @private
		 */
		public function set tips(value:String):void
		{
			_tips = value;
		}

	}
}