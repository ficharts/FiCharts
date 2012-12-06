package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.DataBarStyle;
	import com.fiCharts.charts.chart2D.core.model.DataScale;
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.utils.PerformaceTest;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.TextBitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * 坐标轴的基类，主要负责绘制坐标轴，具体计算都由不同类型的轴负责
	 * 
	 * 坐标轴有刻度分布密度和数据节点分部密度两方面；
	 * 
	 * 刻度密度由数值步长和最小单元刻度决定， 数据节点分部密度由当前可视区域内包含数据节点密度决定
	 * 
	 */	
	public class AxisBase extends Sprite 
	{
		// Type.
		public static const LINER_AXIS : String = 'linear';
		public static const FIELD_AXIS : String = 'field';
		public static const DATE_AXIS : String = 'date';
		
		// Direction.
		public static const HORIZONTAL_AXIS : String = 'horizontalAxis';
		public static const VERTICAL_AXIX : String = 'verticalAixs';
		
		/**
		 *  Constructor.
		 */		
		public function AxisBase()
		{
			//this.mouseChildren = this.mouseEnabled = false;
			
			labelUIsCanvas.mouseChildren = labelUIsCanvas.mouseEnabled = false;
			this.addChild(labelUIsCanvas);
			addChild(labelsMask);
			labelUIsCanvas.mask = labelsMask;
			
			// 初始化当前模式
			curPattern = this.getNormalPatter();
		}
		
		/**
		 */		
		public function stopTip():void
		{
			curPattern.stopTips();
		}
		
		/**
		 */		
		public function updateToolTips():void
		{
			this.curPattern.updateToolTips();
		}
		
		
		/**
		 * 原始数据不一定等于坐标轴上的数据节点， 例如时间类型的坐标轴
		 * 
		 * 校验后的值是数字(time)，原始值是字符串(2001-12-01)
		 */		
		public function getVerifyData(data:Object):Object
		{
			return data;
		}
		
		/**
		 */		
		public function adjustZoomFactor(scaleModel:DataScale):void
		{
			curPattern.adjustZoomFactor(scaleModel);
		}
		
		/**
		 */		
		public function toNomalPattern():void
		{
			if(curPattern)
				curPattern.toNormalPattern();
			else
				curPattern = getNormalPatter();
			
			dataScrollBar.distory();
			this.removeChild(dataScrollBar)
			dataScrollBar = null;
		}
		
		/**
		 */		
		public function toDataScalePatter():void
		{
			if (curPattern)
				curPattern.toDataResizePattern();
			else
				curPattern = getDataScalePattern();
			
			this.curPattern.dataUpdated();
			
			if (dataScrollBar == null)
			{
				dataScrollBar = new DataScrollBar(this, this.dataBarStyle);
				this.addChild(dataScrollBar);
			}
		}
		
		/**
		 */		
		private var dataScrollBar:DataScrollBar;
		
		/**
		 */		
		internal function getNormalPatter():IAxisPattern
		{
			return null;
		}
		
		/**
		 */		
		internal function getDataScalePattern():IAxisPattern
		{
			return null;
		}
		
		/**
		 */		
		internal var curPattern:IAxisPattern;
		
		/**
		 */		
		internal var normalPattern:IAxisPattern;
		
		/**
		 */		
		internal var dataScalePattern:IAxisPattern;
		
		/**
		 * 根据原始数据得到其在总数据中的百分比位置，用来做尺寸缩放
		 */		
		public function getDataPercent(value:Object):Number
		{
			return curPattern.getPercentByData(value);
		}
		
		/**
		 * 将原始的值转换为百分比，用于初次根据配置文件获取缩放比率，
		 * 
		 * 因为坐标轴很早就已渲染，进行了数据筛分
		 */		
		public function getSourceDataPercent(value:Object):Number
		{
			return curPattern.getPercentBySourceData(value);
		}
		
		/**
		 */		
		public function posToPercent(pos:Number):Number
		{
			return curPattern.posToPercent(pos);
		}
		
		/**
		 * 将百分比位置信息转换为真正的位置数值
		 */		
		public function percentToPos(per:Number):Number
		{
			return curPattern.percentToPos(per);
		}
		
		/**
		 * 滚动结束后，渲染数据范围内的序列
		 */		
		public function dataScrolled(dataRange:DataRange):void
		{
			curPattern.dataScrolled(dataRange);
		}
		
		/**
		 * 数据缩放后调用
		 */		
		public function dataResized(dataRange:DataRange):void
		{
			changed = true;
			curPattern.dataResized(dataRange);
		}
		
		/**
		 * 数据滚动过程中，仅需要绘制显示范围内的Label
		 */		
		public function scrollingData(offset:Number):void
		{
			curPattern.scrollingData(offset);
		}
		
		/**
		 */		
		public function scrollDataByDataBar(offset:Number):void
		{
			
		}
		
		/**
		 */		
		internal function updateScrollBar(startPerc:Number, endPerc:Number):void
		{
			dataScrollBar.update(startPerc, endPerc);
		}
		
		/**
		 * 滚动条的样式
		 */		
		public var dataBarStyle:DataBarStyle;
		
		/**
		 * 对于每此数据缩放，坐标轴仅需绘制一次，子数据的滚动只是移动label容器的位置而已
		 */		
		public function renderHoriticalAxis():void
		{
			if (changed)
			{
				this.labelsMask.graphics.clear();
				labelRender.style = this.label;
				
				this.curPattern.renderHorLabelUIs();
				
				// 横轴的坐标轴遮罩只绘制一次，图表初始化时会先整个坐标轴一起渲染
				this.labelsMask.graphics.beginFill(0);
				if (this.position == 'bottom')
				{
					this.labelsMask.graphics.drawRect(- minUintSize / 2, 0, 
						this.size + this.minUintSize, this.labelUIsCanvas.height);
				}
				else
				{
					this.labelsMask.graphics.drawRect(- minUintSize / 2, - this.labelUIsCanvas.height, 
						this.size + this.minUintSize, this.labelUIsCanvas.height);
				}
				labelsMask.graphics.endFill();
				
				if (enable)
					createHoriticalTitle();
				
				adjustHoriTicks();
				
				if (enable && this.tickMark.enable)
					drawHoriTicks();
				
				
				if (this.dataScrollBar)
					dataScrollBar.render();
				
				changed = false;
			}
		}
		
		/**
		 * 将显示区域内的label绘制，如果label未被创建，那么先创建其在绘制
		 */		
		internal function renderHoriLabelUIs(startIndex:int, endIndex:int, length:int):void
		{
			var labelUI:BitmapData;
			var labelVO:AxisLabelData;
			var valuePositon:Number;
			
			
			// 横向的最小间距不能小于Label的宽度， 这里要先获取这个宽度，从而决定单元间隔数
			var i:uint;
			
			// 先获得字符数最长的label位置， 然后根据其获取最小单元宽度
			var labelLen:uint = 0;
			var labelIndex:uint = 0;
			var temLabelLen:uint = 0;
			for (i = startIndex; i <= endIndex; i ++)
			{
				temLabelLen = this.getXLabel(labelVOes[i].value).length;
				if (temLabelLen > labelLen)
				{
					labelLen = temLabelLen;
					labelIndex = i;
				}
			}
			
			labelUI = createLabelUI(labelIndex);
			minUintSize = 10;//轴的尺寸刷新后 minUintSize 会重新计算，避免之前的大尺寸和谐掉后继的小尺寸
			// 线性轴的label UI 每次渲染创建时都需要重新计算  minUintSize ，因为每次的Label都是重新生成的
			if (label.layout == LabelStyle.VERTICAL)
			{
				if (labelUI.height > minUintSize)
					minUintSize = labelUI.height;
			}
			else if (label.layout == LabelStyle.ROTATION)
			{
				if (labelUI.width * 0.5 > minUintSize)
					minUintSize = labelUI.width * 0.5;
			}
			else
			{
				if (labelUI.width > minUintSize)
					minUintSize = labelUI.width;
			}
			
			//保证标签间距大于最小单元宽度， 防止标签重叠；
			var addFactor:uint = 1;
			var uintAmount:uint = length;
			while (size > 0 && (size / uintAmount) < minUintSize)
			{
				addFactor += 1;
				uintAmount = length / addFactor;
			}
			
			// 布局和显示数据范围内的label
			_ticks.length = 0;
			
			for (i = startIndex; i <= endIndex; i += addFactor)
			{
				valuePositon = this.curPattern.valueToSize(labelVOes[i].value, - 1)
				_ticks.push(valuePositon);
				
				if (enable)
				{
					labelUI = labelUIs[i];
					
					if (labelUI == null)
						labelUI = createLabelUI(i);
					
					drawLabelUI(labelUI, valuePositon);
				}
			}
		}
		
		/**
		 */		
		private function drawLabelUI(labelUI:BitmapData, valuePositon:Number):void
		{
			var labelX:Number = 0;
			var labelY:Number = 0;
			var bm:Bitmap;
			
			if (label.layout == LabelStyle.ROTATION)
			{
				bm = new Bitmap(labelUI);
				bm.x = - Math.cos(Math.PI / 4) * labelUI.width + valuePositon;
				
				labelY = Math.sin(Math.PI / 4) * labelUI.width;
				if (this.position == 'bottom')
					labelY = label.margin + labelY;
				else
					labelY = - label.margin - labelUI.height - labelY;
				
				bm.y = labelY;
				bm.rotation = - 45
				labelUIsCanvas.addChild(bm);
			}
			else if (label.layout == LabelStyle.VERTICAL)
			{
				bm = new Bitmap(labelUI);
				bm.x = - labelUI.height / 2 + valuePositon;
				
				labelY = labelUI.width;
				if (this.position == 'bottom')
					labelY = label.margin + labelY;
				else
					labelY = - label.margin - labelUI.height - labelY;
				
				bm.y = labelY;
				bm.rotation = - 90;
				labelUIsCanvas.addChild(bm);
			}
			else
			{
				labelMartrix.tx = - labelUI.width / 2 + valuePositon;
				
				if (this.position == 'bottom')
					labelMartrix.ty = label.margin;
				else
					labelMartrix.ty = - label.margin - labelUI.height;
				
				labelUIsCanvas.graphics.beginBitmapFill(labelUI, labelMartrix, false);
				labelUIsCanvas.graphics.drawRect(labelMartrix.tx, labelMartrix.ty, labelUI.width, labelUI.height);
			}
		}
		
		/**
		 * 
		 */		
		private function createLabelUI(index:uint):BitmapData
		{
			var labelVO:AxisLabelData, ui:BitmapData;
			
			labelVO = labelVOes[index];
			labelVO.label = getXLabel(labelVO.value);
			labelVO.color = metaData.color;
			labelRender.metaData = labelVO;
			
			// 如果label换行显示，那么先以单元宽度为准
			if (labelDisplay == LabelStyle.WRAP)
				labelRender.maxLabelWidth = unitSize;
			
			labelRender.render();
			
			// 这里的labelUI可考虑用bitmap data绘制来优化渲染
			ui = labelUIs[index] = TextBitmapUtil.getUIBmd(labelRender);
			
			return ui;
		}
		
		/**
		 * 仅字段型坐标轴才需要调节刻度线位置
		 */		
		internal function adjustHoriTicks():void
		{
			
		}
		
		/**
		 * 纵轴暂时不存在数据缩放控制，渲染单纯很多
		 */		
		public function renderVerticalAxis():void
		{
			if (changed)
			{
				this.clearLabels();
				this.labelsMask.graphics.clear();
				
				var labelUI:BitmapData;
				var length:uint = this.labelVOes.length;
				var valuePositon:Number;
				
				var labelX:Number;
				var labelY:Number;
				
				var i:uint;
				var labelVO:AxisLabelData;
				minUintSize = 10;
				
				PerformaceTest.start();
				for (i = 0; i < length; i ++)
				{
					if (this.enable)
					{
						labelUI = labelUIs[i];
						
						if (labelUI == null)
						{
							labelVO = labelVOes[i];
							labelVO.label = this.getYLabel(labelVO.value);
							labelVO.color = this.metaData.color;
							labelRender.style = this.label;
							labelRender.metaData = labelVO;
							labelRender.render();
							
							labelUI = labelUIs[i] = TextBitmapUtil.getUIBmd(labelRender);
							restoreLabel(labelVO, labelUI);// 创建一对，存储一对儿
						}
						
						if (label.layout == LabelStyle.ROTATION)
						{
							if (labelUI.width > minUintSize)
								minUintSize = labelUI.width;
						}
						else
						{
							if (labelUI.height > minUintSize)
								minUintSize = labelUI.height;
						}
						
					}
					
				}
				
				//保证标签间距大于最小单元宽度， 防止标签重叠；
				var addFactor:uint = 1;
				var uintAmount:uint = length;
				while (size > 0 && (this.size / uintAmount) < this.minUintSize)
				{
					addFactor += 1;
					uintAmount = length / addFactor;
				}
				
				_ticks.length = 0;
				for (i = 0; i < length; i += addFactor)
				{
					valuePositon = valueToY(labelVOes[i].value);
					_ticks.push(valuePositon);
					
					if (enable)
					{
						labelUI = labelUIs[i];
						
						if (position == "left")
							labelMartrix.tx = - labelUI.width - label.margin;
						else
							labelMartrix.tx = label.margin;
							
						labelMartrix.ty =  valuePositon -  labelUI.height / 2;
						
						labelUIsCanvas.graphics.beginBitmapFill(labelUI, labelMartrix, false);
						labelUIsCanvas.graphics.drawRect(labelMartrix.tx, labelMartrix.ty, labelUI.width, labelUI.height);
					}
				}
				
				this.labelsMask.graphics.beginFill(0);
				if (position == "left")
				{
					this.labelsMask.graphics.drawRect(0, minUintSize / 2, 
						- this.labelUIsCanvas.width - 2, - this.size - this.minUintSize);
				}
				else
				{
					this.labelsMask.graphics.drawRect(0, minUintSize / 2, 
						 this.labelUIsCanvas.width + 2, - this.size - this.minUintSize);
				}
				labelsMask.graphics.endFill();
				
				if (enable)
					createVerticalTitle();
				
				adjustVertiTicks();
				
				if (enable && tickMark.enable)
					drawVertiTicks();
				
				changed = false;
			}
		}
		
		/**
		 * 数据缩放中，y轴会动态刷新，存储下label数据避免了重复构建渲染其性能开销
		 * 
		 * 这个开销挺大的
		 */		
		protected function restoreLabel(vo:AxisLabelData, ui:BitmapData):void
		{
			
		}
		
		/**
		 */		
		protected function adjustVertiTicks():void
		{
		}
		
		/**
		 */		
		internal function drawHoriTicks():void
		{
			// 绘制刻度线
			StyleManager.setLineStyle(this.labelUIsCanvas.graphics, tickMark);
			
			for (var i:uint = 1; i < ticks.length - 1; i ++)
			{
				labelUIsCanvas.graphics.moveTo(ticks[i], 0);
				
				if (position == 'bottom')
					labelUIsCanvas.graphics.lineTo(ticks[i], tickMark.size);
				else
					labelUIsCanvas.graphics.lineTo(ticks[i], - tickMark.size);
			}
		}
		
		/**
		 */		
		protected function drawVertiTicks():void
		{
			// 绘制刻度线
			StyleManager.setLineStyle(labelUIsCanvas.graphics, tickMark);
			
			for (var i:uint = 1; i < ticks.length - 1; i ++)
			{
				labelUIsCanvas.graphics.moveTo(0, ticks[i]);
				if (position == "left")
					labelUIsCanvas.graphics.lineTo(- tickMark.size, ticks[i]);
				else
					labelUIsCanvas.graphics.lineTo(tickMark.size, ticks[i]);
			}
		}
		
		/**
		 */		
		protected function createHoriticalTitle():void
		{
			if(titleLabel.parent)
				this.removeChild(titleLabel);
			
			if (title.text.value)
			{
				titleLabel.style = title;
				titleLabel.metaData = this.metaData;
				titleLabel.render();
				
				titleLabel.x = size * .5 - titleLabel.width * .5;
				
				if (position == 'bottom')
				{
					
					if (this.dataScrollBar)
					{
						titleLabel.y = this.labelUIsCanvas.height + title.margin + dataScrollBar.barHeight;
					}
					else
					{
						titleLabel.y = this.labelUIsCanvas.height + title.margin;
					}
				}
				else
				{
					titleLabel.y = - labelUIsCanvas.height - title.margin - titleLabel.height;
				}
				
				this.addChild(titleLabel);
			}
		}
		
		/**
		 */		
		protected function createVerticalTitle():void
		{
			if(titileBitmap && titileBitmap.parent)
				this.removeChild(titileBitmap);
			
			if (title.text.value)
			{
				titleLabel.metaData = this.metaData;
				titleLabel.style = title;
				titleLabel.render();
				
				titileBitmap = TextBitmapUtil.drawUI(titleLabel);
				titileBitmap.rotation =  - 90;
				
				if(this.position == "left")
					titileBitmap.x = - this.labelUIsCanvas.width - title.margin - titileBitmap.width;
				else
					titileBitmap.x = labelUIsCanvas.width + title.margin;
				
				titileBitmap.y = - size * .5 + titileBitmap.height * .5 ;
				addChild(titileBitmap);
			}
		}
		
		/**
		 *  Clear labels.
		 */		
		internal function clearLabels() : void
		{
			this.labelUIsCanvas.graphics.clear();
			
			while (labelUIsCanvas.numChildren)
				labelUIsCanvas.removeChildAt(0);
		}
		
		
		/**
		 * 获取序列的数值范围，最值；
		 */		
		public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
			
			return seriesDataFeature;
		}
		
		/**
		 * 这两个全局唯一，用来渲染label，然后将bitmapdata其绘制到坐标轴 
		 */		
		internal var labelMartrix:Matrix = new Matrix;
		internal var labelRender:LabelUI = new LabelUI;
		
		/**
		 */		
		private var labelsMask:Shape = new Shape;
		
		/**
		 */		
		internal var labelUIs:Array = [];
		
		/**
		 * label的容器用来数据缩放时整体移动label，辅助遮罩效果
		 */		
		internal var labelUIsCanvas:Sprite = new Sprite;
		
		/**
		 */		
		private var titleLabel:LabelUI = new LabelUI;
		
		/**
		 */		
		private var titileBitmap:Bitmap;
		
		/**
		 * 轴标签数据
		 */
		internal var labelVOes:Vector.<AxisLabelData> = new Vector.<AxisLabelData>;
		
		
		
		//---------------------------------------------------
		//
		// 
		//  数据初始化， 数据缩放中Y轴需动态更新，也许处理数据
		//
		//
		//--------------------------------------------------
		
		/**
		 */		
		public function redayToUpdataYData():void
		{
		}
		
		/**
		 */		
		public function pushYData(value:Vector.<Object>):void
		{
		}
		
		/**
		 */		
		public function yDataUpdated():void
		{
		}
		
		
		/**
		 *     
		 *  以下是原始数据的处理
		 * 
		 */		
		
		
		/**
		 */		
		public function redyToUpdateData():void
		{
			sourceValues.length = 0;
		}
		
		/**
		 */		
		public function pushValues(values:Vector.<Object>) : void
		{
			
		}
		
		/**
		 */		
		public function dataUpdated():void
		{
			this.label.layout = this.labelDisplay;
			
			if (label.layout == LabelStyle.NONE)
				label.enable = false;
			else 
				label.enable = true;
			
			changed = true;
		}
		
		/**
		 * 尺寸更新后更新坐标轴相关属性；
		 * 
		 * 计算最大最小值，间隔刻度，label数据
		 */
		public function beforeRender():void
		{
			if (this.changed)
				this.curPattern.beforeRender();
		}
		
		/**
		 * 原始数据
		 */		
		internal var sourceValues:Array = [];
		
		/**
		 * 轴的创建， 尺寸， 数据改变此标识都会为真；
		 */		
		internal var changed:Boolean = true;
		
		/**
		 */		
		internal var _ticks:Vector.<Number> = new Vector.<Number>;
		
		/**
		 */
		public function get ticks():Vector.<Number>
		{
			return _ticks;
		}
		
		
		/**
		 * @return 
		 * 
		 */		
		protected function get type() : String
		{
			return null;
		}
		
		/**
		 */		
		private var _direction : String;
		public function set direction( value : String ) : void
		{
			_direction = value;
		}
		
		public function get direction() : String
		{
			return _direction;
		}
		
		/**
		 * The size of this axis. 
		 */		
		protected var _length : Number;
		public function set size( value : Number ) : void
		{
			_length = value;
			changed = true;
		}
		
		public function get size() : Number
		{
			return _length;
		}
		
		/**
		 *  标准单元格尺寸，为显示尺寸内，显示的数据范围除以单元数据而来
		 * 
		 *  因为label可能会很长，label间距为单元刻度的倍数
		 */
		private var _uintSize:Number = 0;
		
		public function get unitSize():Number
		{
			return _uintSize;
		}
		
		public function set unitSize(value:Number):void
		{
			_uintSize = value;
		}
		
		/**
		 * 这个值有可能比uinitSize要大，取决于label的尺寸
		 */
		public var minUintSize:Number = 10;
		
		/**
		 * @param value
		 */		
		public function valueToY( value : Object ) : Number
		{
			return 0;
		}
		
		/**
		 */		
		public function valueToZ(value:Object):Number
		{
			return 0;
		}
		
		/**
		 * 
		 * 大数据量计算时， 根据数据再获取其位置信息很耗性能， 所以把位置直接
		 * 
		 * 传进来，方便 Field 轴的位置计算
		 * 
		 * @param value
		 * @return 
		 */		
		public function valueToX(value:Object, index:uint) : Number
		{
			return 0;
		}
		
		/**
		 */		
		protected function valueToSize( value : Object, index:uint ) : Number
		{
			return this.curPattern.valueToSize(value, index);
		}
		
		/**
		 */		
		protected var _disPlayName:String
		public function set displayName(value:String) : void
		{
			_disPlayName = value;
		}
		
		/**
		 * 如果没有设置 displayName 则继承自 title;
		 */		
		public function get displayName():String
		{
			if (_disPlayName)
				return _disPlayName
			else	
				return this.title.text.value;
		}
		
		/**
		 */		
		private var _paddingLeft:Number = 0;
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}
		
		private var _paddingRight:Number = 0;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		
		
		
		
		//---------------------------------------
		//
		// 数据格式化
		//
		//---------------------------------------
		
		public function getXLabel(value:Object):String
		{
			return null;
		}
		
		public function getYLabel(value:Object):String
		{
			return null;
		}
		
		public function getZLabel(value:Object):String
		{
			return null;
		}
		
		
		private var _dataFormatter:ChartDataFormatter;
		
		/**
		 */
		public function get dataFormatter():ChartDataFormatter
		{
			return _dataFormatter;
		}
		
		/**
		 * @private
		 */
		public function set dataFormatter(value:ChartDataFormatter):void
		{
			// 默认采用全局配置， 也可单独配置。
			if (this._dataFormatter == null)
				_dataFormatter = value;
		}
		
		
		
		
		//------------------------------------------------
		//
		// 坐标轴公共属性
		//
		//------------------------------------------------
		
		/**
		 * 是否显示/渲染坐标轴； 
		 */		
		private var _enable:Object = true;

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
		private var _id:String = "";
		
		/**
		 * @return 
		 */		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 *  决定坐标轴的布局位置： top, bottom, left, right;
		 */		
		private var _postition:String;

		/**
		 */
		public function get position():String
		{
			return _postition;
		}

		/**
		 * @private
		 */
		public function set position(value:String):void
		{
			_postition = value;
		}
		
		/**
		 * 是否翻转坐标轴的计算方式，此属性配合position可以决定 
		 */		
		private var _inverse:Object = false;
		
		/**
		 */
		public function get inverse():Object
		{
			return _inverse;
		}
		
		/**
		 * @private
		 */
		public function set inverse(value:Object):void
		{
			_inverse = XMLVOMapper.boolean(value);
		}

		/**
		 * 坐标轴标题
		 */		
		private var _title:LabelStyle;

		public function get title():LabelStyle
		{
			return _title;
		}

		public function set title(value:LabelStyle):void
		{
			_title = value;
		}
		
		/**
		 */		
		public function get labelDisplay():String
		{
			return _labelDisplay;
		}

		public function set labelDisplay(value:String):void
		{
			_labelDisplay = value;
		}
		
		/**
		 */		
		private var _labelDisplay:String = LabelStyle.NORMAL;

		/**
		 * 数值标签
		 */		
		private var _label:LabelStyle
		
		/**
		 */
		public function get label():LabelStyle
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:LabelStyle):void
		{
			_label = value;
		}
		
		/**
		 * 坐标刻度 
		 */		
		private var _tickMark:TickMarkStyle;

		/**
		 */
		public function get tickMark():TickMarkStyle
		{
			return _tickMark;
		}

		/**
		 * @private
		 */
		public function set tickMark(value:TickMarkStyle):void
		{
			_tickMark = value;
		}
		
		/**
		 */		
		private var _line:BorderLine;

		/**
		 * 坐标轴线样式
		 */
		public function get line():BorderLine
		{
			return _line;
		}

		/**
		 * @private
		 */
		public function set line(value:BorderLine):void
		{
			_line = value;
		}
		
		/**
		 */		
		private var _metaData:Object;

		/**
		 */
		public function get metaData():Object
		{
			return _metaData;
		}

		/**
		 * @private
		 */
		public function set metaData(value:Object):void
		{
			_metaData = value;
		}

	}
}