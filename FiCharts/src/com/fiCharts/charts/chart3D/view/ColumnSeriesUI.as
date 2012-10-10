package com.fiCharts.charts.chart3D.view
{
	import com.fiCharts.charts.chart3D.baseClasses.IItemRenderVO;
	import com.fiCharts.charts.chart3D.model.vo.cube.ColumnVO;
	import com.fiCharts.charts.chart3D.view.columnUI.ColumnUI;
	import com.fiCharts.charts.chart3D.view.columnUI.ColumnValueLabelBase;
	import com.fiCharts.charts.chart3D.view.columnUI.ColumnValueLabelDown;
	import com.fiCharts.charts.common.SeriesDataItemVO;
	import com.fiCharts.ui.toolTips.ToolTipHolder;
	import com.fiCharts.ui.toolTips.ToolTipsEvent;
	import com.fiCharts.ui.toolTips.TooltipDataItem;
	import com.fiCharts.utils.MathUtil;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	import com.fiCharts.utils.graphic.Point2D;
	import com.fiCharts.utils.graphic.Point3D;
	import com.fiCharts.utils.graphic.style.FillStyle;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 *  Render series items.
	 * 
	 * @author wallen
	 */	
	public class ColumnSeriesUI extends Sprite
	{
		/**
		 */		
		public function ColumnSeriesUI()
		{
			super();
			
			addChild(columnUIContainer);
			addChild(valueLabelsContainer);
		}
		
		/**
		 */		
		private var _valueLabelFillStyle:Fill;

		public function get valueLabelFillStyle():Fill
		{
			return _valueLabelFillStyle;
		}

		public function set valueLabelFillStyle(value:Fill):void
		{
			_valueLabelFillStyle = value;
		}
		
		/**
		 */		
		private var _valueLabelFontStyle:LabelStyle;

		public function get valueLabelFontStyle():LabelStyle
		{
			return _valueLabelFontStyle;
		}

		public function set valueLabelFontStyle(value:LabelStyle):void
		{
			_valueLabelFontStyle = value;
		}

		/**
		 */		
		private var _ifHasValueLabel:Number;

		/**
		 */
		public function get ifHasValueLabel():Number
		{
			return _ifHasValueLabel;
		}

		/**
		 * @private
		 */
		public function set ifHasValueLabel(value:Number):void
		{
			_ifHasValueLabel = value;
		}
		
		private var _ifFlash:Number;

		public function get ifFlash():Number
		{
			return _ifFlash;
		}

		public function set ifFlash(value:Number):void
		{
			_ifFlash = value;
		}
		
		/**
		 */		
		private var ifFirstRender:Boolean = false;

		
		private var _canvasHeight:uint;

		/**
		 */
		public function get canvasHeight():uint
		{
			return _canvasHeight;
		}

		/**
		 * @private
		 */
		public function set canvasHeight(value:uint):void
		{
			_canvasHeight = value;
		}

		
		private var _renderVOes:Vector.<IItemRenderVO>;
		
		/**
		 */
		public function get renderVOes():Vector.<IItemRenderVO>
		{
			return _renderVOes;
		}
		
		/**
		 * @private
		 */
		public function set renderVOes(value:Vector.<IItemRenderVO>):void
		{
			_renderVOes = value;
			
			ifFirstRender = true;// 数据仅在首次渲染时才可以播放动画； 
			_renderVOes.sort(compareRenders);// sort renders from left to right.
			createCoumnUIs();
			
			if (this.ifHasValueLabel)
				creatColumnValueLabels();
		}
		
		/**
		 * 创建柱体UI
		 */		
		private function createCoumnUIs():void
		{
			while (columnUIContainer.numChildren)
				columnUIContainer.removeChildAt(0);
			
			var column:ColumnUI;
			
			columnUIs = new Vector.<ColumnUI>();
			for each (var item:ColumnVO in renderVOes)
			{
				column = new ColumnUI(item);
				column.addEventListener(MouseEvent.ROLL_OVER, overHandler, false, 0, true);
				column.addEventListener(MouseEvent.ROLL_OUT, outHandler, false, 0, true);
				columnUIs.push(column);
				columnUIContainer.addChild(column);
			}
		}
		
		
		/**
		 * 调整柱体的景深，按照从左到右的顺序；
		 */		
		private function compareRenders(small:ColumnVO, big:ColumnVO):int
		{
			if (small.location3D.x < big.location3D.x) 
				
				return - 1;
			else if (small.location3D.x > big.location3D.x) 
				return 1;
			else
				return 0;
		}
		
		/**
		 */		
		private var columnUIs:Vector.<ColumnUI>;
		
		/**
		 * 创建数值显示标签;
		 */		
		private function creatColumnValueLabels():void
		{
			while (valueLabelsContainer.numChildren)
				valueLabelsContainer.removeChildAt(0);
			
			var columnLabel:ColumnValueLabelBase;
			columnValueLabels = new Vector.<ColumnValueLabelBase>();
			for each (var renderVO:ColumnVO in renderVOes)
			{
				if (renderVO.direction == ColumnVO.COLUMN_UP)
					columnLabel = new ColumnValueLabelBase(renderVO.itemVO.yLabel);
				else
					columnLabel = new ColumnValueLabelDown(renderVO.itemVO.yLabel);
				
				
				columnLabel.setFillStyle(this.valueLabelFillStyle);
				columnLabel.setFontStyle(this.valueLabelFontStyle);
				columnLabel.render();
				columnValueLabels.push(columnLabel);
				valueLabelsContainer.addChild(columnLabel);
			}
		}
		
		/**
		 */		
		private function overHandler(evt:MouseEvent):void
		{
			var tooltipHolder:ToolTipHolder = new ToolTipHolder();
			var metaData:Object = ((evt.target as CubeUI).cubeVO as ColumnVO).itemVO.metaData;
			var tooltipItem:TooltipDataItem = new TooltipDataItem;
			
			metaData.tooltip = metaData.xLabel + 
				"\n" + metaData.yLabel;
			
			if (metaData.seriesName != "") metaData.tooltip = metaData.seriesName + ":\n" + metaData.tooltip;
			
			tooltipItem.metaData = metaData.metaData;
			//tooltipItem.style = this
			tooltipHolder.pushTip(metaData);
			this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tooltipHolder));
		}
		
		/**
		 */		
		private function outHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		
		
		
		//------------------------------------
		//
		// 渲染及动画；
		//
		//------------------------------------
		
		/**
		 */		
		public function render():void
		{
			// 为播放动画做准备；
			if (this.ifFlash && ifFirstRender)
			{
				flashColumnPercent = 0;
				if (ifHasValueLabel)
					valueLabelsContainer.alpha = 0;
			}
			else
			{
				flashColumnPercent = 1;
			}
			
			//渲染柱体
			var column:ColumnUI;
			for each (column in columnUIs)
			{
				column.render();
				column.setHeight(flashColumnPercent);
			}
			
			if (ifHasValueLabel)
				updateValueLabelsLoaction();
			
			//播放动画
			if (ifFlash && ifFirstRender)
			{
				flashTimmer.addEventListener(TimerEvent.TIMER, flashColumnHandler, false, 0, true);
				flashTimmer.start();
			}
			
		}
		
		/**
		 */		
		private function flashColumnHandler(evt:Event):void
		{
			flashColumnPercent += .05;
			if (flashColumnPercent > 1)
			{
				ifFirstRender = false;// 新数据渲染动画仅播放一次；
				flashColumnPercent = 1;
				flashTimmer.stop();
				flashTimmer.removeEventListener(TimerEvent.TIMER, flashColumnHandler);
				
				// 柱体动画播放完毕后播放数值标签动画；
				if (this.ifHasValueLabel)
				{
					flashLabelPercent = .05;
					flashTimmer.addEventListener(TimerEvent.TIMER, flashValueLabelsHandler, false, 0, true);
					flashTimmer.start();
				}
			}
			
			for each (var column:ColumnUI in columnUIs)
			{
				column.setHeight(Number(MathUtil.round(flashColumnPercent, 2)));
			}
		}
		
		/**
		 */		
		private function flashValueLabelsHandler(evt:TimerEvent):void
		{
			flashLabelPercent += .1;
			if (flashLabelPercent > 1)
			{
				flashLabelPercent = 1;
				flashTimmer.stop();
				flashTimmer.removeEventListener(TimerEvent.TIMER, flashValueLabelsHandler);
			}
			
			valueLabelsContainer.alpha = flashLabelPercent;
		}
		
		/**
		 */		
		private function updateValueLabelsLoaction():void
		{
			var length:uint = renderVOes.length;
			var renderVO:ColumnVO;
			for (var i:uint = 0; i < length; i ++)
			{
				renderVO = (renderVOes[i] as ColumnVO);
				columnValueLabels[i].layout(renderVO);
			}
		}
		
		private var columnValueLabels:Vector.<ColumnValueLabelBase>;
		 
		private var valueLabelsContainer:Sprite = new Sprite();
		
		private var columnUIContainer:Sprite = new Sprite();
		
		/**
		 */		
		private var flashTimmer:Timer = new Timer(30, 0);;
		
		/**
		 */		
		private var flashColumnPercent:Number = 0;
		private var flashLabelPercent:Number = 0;
		
		/**
		 */		
		private var _location3D:Point3D = new Point3D();

		public function get location3D():Point3D
		{
			return _location3D;
		}

		public function set location3D(value:Point3D):void
		{
			_location3D = value;
		}
		
		/**
		 */		
		private var _location2D:Point2D;

		public function get location2D():Point2D
		{
			return _location2D;
		}

		public function set location2D(value:Point2D):void
		{
			_location2D = value;
		}
	}
}