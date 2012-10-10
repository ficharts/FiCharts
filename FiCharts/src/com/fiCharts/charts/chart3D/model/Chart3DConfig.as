package com.fiCharts.charts.chart3D.model
{
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.style.LineStyle;
	
	/**
	 */
	public class Chart3DConfig
	{
		public function Chart3DConfig()
		{
		}
		
		
		//-------------------------------------
		//
		// 系统设置, 全局特性
		//
		//-------------------------------------
		
		private var _ifFlash:Number;

		/**
		 */
		public function get ifFlash():Number
		{
			return _ifFlash;
		}

		/**
		 * @private
		 */
		public function set ifFlash(value:Number):void
		{
			_ifFlash = value;
		}

		/**
		 */		
		private var _ifHasValueLabel:Number;
		
		public function get ifHasValueLabel():Number
		{
			return _ifHasValueLabel;
		}
		
		public function set ifHasValueLabel(value:Number):void
		{
			_ifHasValueLabel = value;
		}
		
		
		
		
		//----------------------------------------------------
		//
		// 样式设置
		//
		//-----------------------------------------------------
		

		/**
		 * 标题字体样式
		 */		
		private var _titleStyle:LabelStyle = new LabelStyle;

		/**
		 */
		public function get titleStyle():LabelStyle
		{
			return _titleStyle;
		}

		/**
		 * @private
		 */
		public function set titleStyle(value:LabelStyle):void
		{
			_titleStyle = value;
		}
		
		/**
		 * 控制数值样式
		 */		
		private var _valueLabelStyle:LabelStyle = new LabelStyle;

		/**
		 */
		public function get valueLabelStyle():LabelStyle
		{
			return _valueLabelStyle;
		}

		/**
		 * @private
		 */
		public function set valueLabelStyle(value:LabelStyle):void
		{
			_valueLabelStyle = value;
		}
		
		/**
		 * 标题样式 
		 */		
		private var _chartTitle:LabelStyle = new LabelStyle;
		
		/**
		 */
		public function get chartTitleStyle():LabelStyle
		{
			return _chartTitle;
		}
		
		/**
		 * @private
		 */
		public function set chartTitleStyle(value:LabelStyle):void
		{
			_chartTitle = value;
		} 
		
		
		
		//--------------------------------------------------------
		//
		// 坐标轴样式
		//
		//--------------------------------------------------------
		
		/**
		 */		
		private var _axisLabel:LabelStyle = new LabelStyle();
		
		public function get axisLabelStyle():LabelStyle
		{
			return _axisLabel;
		}
		
		public function set axisLabelStyle(value:LabelStyle):void
		{
			_axisLabel = value;
		}
		
		/**
		 */		
		private var _axisTitleStyle:LabelStyle = new LabelStyle;
		
		public function get axisTitleStyle():LabelStyle
		{
			return _axisTitleStyle;
		}
		
		public function set axisTitleStyle(value:LabelStyle):void
		{
			_axisTitleStyle = value;
		}
		
		/**
		 */		
		private var _axisLine:LineStyle = new LineStyle;
		
		/**
		 */
		public function get axisLine():LineStyle
		{
			return _axisLine;
		}
		
		/**
		 * @private
		 */
		public function set axisLine(value:LineStyle):void
		{
			_axisLine = value;
		}
		
		
		
		
		//--------------------------------------
		//
		// 布局设置
		//
		//----------------------------------------
		
		private var _title:String = "";

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}
		
		/**
		 */		
		private var _gutterLeft:int = 10;

		public function get gutterLeft():int
		{
			return _gutterLeft;
		}

		public function set gutterLeft(value:int):void
		{
			_gutterLeft = value;
		}
		
		/**
		 */		
		private var _gutterRight:int = 10;

		public function get gutterRight():int
		{
			return _gutterRight;
		}

		public function set gutterRight(value:int):void
		{
			_gutterRight = value;
		}
		
		/**
		 */		
		private var _gutterTop:int = 10;

		public function get gutterTop():int
		{
			return _gutterTop;
		}

		public function set gutterTop(value:int):void
		{
			_gutterTop = value;
		}
		
		/**
		 */		
		private var _gutterBottom:int = 10;

		public function get gutterBottom():int
		{
			return _gutterBottom;
		}

		public function set gutterBottom(value:int):void
		{
			_gutterBottom = value;
		}
		
		/**
		 */		
		private var _sizeX:int;
		
		public function get sizeX():int
		{
			return _sizeX;
		}
		
		public function set sizeX(value:int):void
		{
			_sizeX = value;
		}
		
		/**
		 */		
		private var _sizeY:int;
		
		public function get sizeY():int
		{
			return _sizeY;
		}
		
		public function set sizeY(value:int):void
		{
			_sizeY = value;
		}
		
		/**
		 */		
		private var _sizeZ:int;
		
		public function get sizeZ():int
		{
			return _sizeZ;
		}
		
		public function set sizeZ(value:int):void
		{
			_sizeZ = value;
		}
		
		
		
		
		
		//-------------------------------------
		//
		// 背景设置
		//
		//-------------------------------------
		
		/**
		 */		
		private var _bgCubeThikness:uint;

		public function get bgCubeThikness():uint
		{
			return _bgCubeThikness;
		}

		public function set bgCubeThikness(value:uint):void
		{
			if (_bgCubeThikness != value)
			{
				_bgCubeThikness = value;
				this.ifBgCubeThiknessChanged = true;
			}
		}
		
		private var _ifBgCubeThiknessChanged:Boolean = false;

		public function get ifBgCubeThiknessChanged():Boolean
		{
			return _ifBgCubeThiknessChanged;
		}

		public function set ifBgCubeThiknessChanged(value:Boolean):void
		{
			_ifBgCubeThiknessChanged = value;
		}
		
		/**
		 */		
		private var _bgCubeFillColor:uint;

		public function get bgCubeFillColor():Object
		{
			return _bgCubeFillColor;
		}

		public function set bgCubeFillColor(value:Object):void
		{
			_bgCubeFillColor = StyleManager.getUintColor(value);
		}
		
		private var _bgGuideColor:uint;

		public function get bgGuideColor():Object
		{
			return _bgGuideColor;
		}

		public function set bgGuideColor(value:Object):void
		{
			_bgGuideColor = StyleManager.getUintColor(value);
		}
		
		private var _bgGuideThikness:Number;

		public function get bgGuideThikness():Number
		{
			return _bgGuideThikness;
		}

		public function set bgGuideThikness(value:Number):void
		{
			_bgGuideThikness = value;
		}

	}
}