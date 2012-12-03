package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.TextBitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 坐标轴的基类，主要负责绘制坐标轴，具体计算都由不同类型的轴负责
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
			this.mouseChildren = this.mouseEnabled = false;
			this.addChild(labelUIsCanvas);
			addChild(labelsMask);
			labelUIsCanvas.mask = labelsMask;
		}
		
		/**
		 * 滚动条的样式
		 */		
		public var scrollBarStyle:Style;
		
		/**
		 * 对于每此数据缩放，坐标轴仅需绘制一次，子数据的滚动只是移动label容器的位置而已
		 */		
		public function renderHoriticalAxis():void
		{
			if (changed)
			{
				this.clearLabels();
				this.labelsMask.graphics.clear();
				
				var labelUI:DisplayObject;
				var axisLabel:LabelUI;
				var length:uint = this.labelsData.length;
				var valuePositon:Number;
				
				var labelX:Number;
				var labelY:Number;
				
				// 横向的最小间距不能小于Label的宽度， 这里要先获取这个宽度，从而决定单元间隔数
				var i:uint;
				minUintSize = 10;//轴的尺寸刷新后 minUintSize 会重新计算，避免之前的大尺寸和谐掉后继的小尺寸
				for (i = 0; i < length; i ++)
				{
					if (this.enable)
					{
						labelUI = labelUIs[i];
						if (labelUI == null)
						{
							labelsData[i].label = this.getXLabel(labelsData[i].value);
							labelsData[i].color = this.metaData.color;
							
							axisLabel = new LabelUI();
							axisLabel.style = this.label;
							axisLabel.metaData = labelsData[i];
							
							// 如果label换行显示，那么先以单元宽度为准
							if (this.labelDisplay == LabelStyle.WRAP)
								axisLabel.maxLabelWidth = this.unitSize;
							
							axisLabel.render();
							
							// 这里的labelUI可考虑用bitmap data绘制来优化渲染
							labelUI = labelUIs[i] = TextBitmapUtil.drawUI(axisLabel);
							axisLabel = null;
						}
							
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
						
					}
					
				}
				
				//保证标签间距大于最小单元宽度， 防止标签重叠；
				var addFactor:uint = 1;
				var uintAmount:uint = length;
				while (this.size > 0 && (this.size / uintAmount) < this.minUintSize)
				{
					addFactor += 1;
					uintAmount = length / addFactor;
				}
				
				// 布局和显示数据范围内的label
				_ticks = new Vector.<Number>();
				for (i = 0; i < length; i += addFactor)
				{
					valuePositon = valueToX(labelsData[i].value);
					_ticks.push(valuePositon);
					
					if (this.enable)
					{
						labelUI = labelUIs[i];
						
						if (label.layout == LabelStyle.ROTATION)
						{
							labelUI.rotation = 0;
							labelX = - Math.cos(Math.PI / 4) * labelUI.width;
							labelY = Math.sin(Math.PI / 4) * labelUI.width;
							labelUI.rotation = - 45;
						}
						else if (label.layout == LabelStyle.VERTICAL)
						{
							labelUI.rotation = 0;
							labelX = - labelUI.height / 2;
							labelY = labelUI.width;
							labelUI.rotation = - 90;
						}
						else
						{
							labelX = - labelUI.width / 2;
							labelY = 0;
						}
						
						labelUI.x = valuePositon + labelX;
						
						if (this.position == 'bottom')
							labelUI.y = label.margin + labelY;
						else
							labelUI.y = - label.margin - labelY - labelUI.height;
						
						labelUIsCanvas.addChild(labelUI);
					}
				}
				
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
				
				changed = false;
			}
		}
		
		/**
		 */		
		private var labelsMask:Shape = new Shape;
		
		/**
		 */		
		protected var labelUIs:Array = [];
		
		/**
		 * label的容器用来数据缩放时整体移动label，辅助遮罩效果
		 */		
		protected var labelUIsCanvas:Sprite = new Sprite;
		
		/**
		 */		
		protected function adjustHoriTicks():void
		{
			
		}
		
		/**
		 * 
		 * 这个值有可能比uinitSize要大，取决于label的尺寸
		 * 
		 */
		public var minUintSize:Number = 10;
		
		/**
		 */		
		public function renderVerticalAxis():void
		{
			if (changed)
			{
				this.clearLabels();
				
				this.labelsMask.graphics.clear();
				
				_ticks = new Vector.<Number>();
				
				var labelUI:DisplayObject;
				var axisLabel:LabelUI;
				var length:uint = this.labelsData.length;
				var valuePositon:Number;
				
				var labelX:Number;
				var labelY:Number;
				
				var i:uint;
				minUintSize = 10;
				for (i = 0; i < length; i ++)
				{
					if (this.enable)
					{
						if (labelUIs[i]) continue;
						
						labelsData[i].label = this.getYLabel(labelsData[i].value);
						labelsData[i].color = this.metaData.color;
						
						axisLabel = new LabelUI();
						axisLabel.style = this.label;
						axisLabel.metaData = labelsData[i];
						axisLabel.render();
						
						if (label.layout == LabelStyle.ROTATION)
						{
							if (axisLabel.width > minUintSize)
								minUintSize = axisLabel.width;
						}
						else
						{
							if (axisLabel.height > minUintSize)
								minUintSize = axisLabel.height;
						}
						
						// 这里的labelUI可考虑用bitmap data绘制来优化渲染
						labelUI = labelUIs[i] = TextBitmapUtil.drawUI(axisLabel);
						axisLabel = null;
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
				
				for (i = 0; i < length; i += addFactor)
				{
					valuePositon = valueToY(labelsData[i].value);
					_ticks.push(valuePositon);
					
					if (enable)
					{
						labelUI = labelUIs[i];
						
						if (label.layout == LabelStyle.ROTATION)
						{
							labelX = - Math.cos(Math.PI / 4) * labelUI.width - 
								Math.cos(Math.PI / 4) * labelUI.height / 2;
							
							labelY = Math.sin(Math.PI / 4) * labelUI.width - 
								Math.cos(Math.PI / 4) * labelUI.height;
							
							labelUI.rotation = - 45;
						}
						else
						{
							labelX = - labelUI.width;
							labelY = - labelUI.height / 2;
						}
						
						if (position == "left")
							labelUI.x = - label.margin + labelX;
						else
							labelUI.x = label.margin;
						
						labelUI.y = valuePositon + labelY;
						
						labelUIsCanvas.addChild(labelUI);
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
		 */		
		protected function adjustVertiTicks():void
		{
		}
		
		/**
		 */		
		protected function drawHoriTicks():void
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
					titleLabel.y = height + title.margin;
				else
					titleLabel.y = - height - title.margin - titleLabel.height;
				
				this.addChild(titleLabel);
			}
		}
		
		/**
		 */		
		private var titleLabel:LabelUI = new LabelUI;
		
		/**
		 */		
		private var titileBitmap:Bitmap;
		
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
					titileBitmap.x = - width - title.margin - titileBitmap.width;
				else
					titileBitmap.x = width + title.margin;
				
				titileBitmap.y = - size * .5 + titileBitmap.height * .5 ;
				addChild(titileBitmap);
			}
		}
		
		/**
		 *  Clear labels.
		 */		
		protected function clearLabels() : void
		{
			this.labelUIsCanvas.graphics.clear();
			while (labelUIsCanvas.numChildren > 0)
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
		 */		
		public function redyToUpdateData():void
		{
			sourceValues = new Vector.<Object>;
		}
		
		/**
		 * 轴标签数据
		 */
		protected var labelsData:Vector.<AxisLabelData>;
		
		/**
		 * 原始数据
		 */		
		protected var sourceValues:Vector.<Object>;
		public function pushValues(values:Vector.<Object>) : void
		{
			
		}
		
		/**
		 * 尺寸更新后更新坐标轴相关属性；
		 * 
		 * 计算最大最小值，间隔刻度，label数据
		 */
		public function beforeRender():void
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
		 * 轴的创建， 尺寸， 数据改变此标识都会为真；
		 */		
		protected var changed:Boolean = true;
		
		/**
		 */		
		protected var _ticks:Vector.<Number>;
		
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
		private var _uintSize:Number;
		
		public function get unitSize():Number
		{
			return _uintSize;
		}
		
		public function set unitSize(value:Number):void
		{
			_uintSize = value;
		}
		
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
		 * @param value
		 * @return 
		 */		
		public function valueToX( value : Object ) : Number
		{
			return 0;
		}
		
		/**
		 */		
		protected function valueToSize( value : Object ) : Number
		{
			return 0
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