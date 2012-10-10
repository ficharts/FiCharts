package com.fiCharts.charts.chart2D.core.axis
{
	import com.fiCharts.charts.chart2D.core.model.SeriesDataFeature;
	import com.fiCharts.charts.common.ChartDataFormatter;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.graphic.TextBitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
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
			
		}
		
		/**
		 */		
		public function renderHoriticalAxis():void
		{
			if (changed)
			{
				clear(); 
				
				_ticks = new Vector.<Number>();
				
				var labelUI:DisplayObject;
				var axisLabel:LabelUI;
				var length:uint = labelAmount;
				var valuePositon:Number;
				
				var labelX:Number;
				var labelY:Number;
				
				//保证标签间距大于最小单元宽度， 防止标签重叠；
				var addFactor:uint = 1;
				var uintAmount:uint = labelAmount;
				while (size > 0 && (this.size / uintAmount) < this.horiMinUintSize)
				{
					addFactor += 1;
					uintAmount = labelAmount / addFactor;
				}
				
				for (var i:uint = 0; i < length; i += addFactor)
				{
					valuePositon = valueToX(labelsData[i].value);
					_ticks.push(valuePositon);
					
					if (this.enable)
					{
						labelsData[i].label = this.getXLabel(labelsData[i].value);
						labelsData[i].color = this.metaData.color;
							
						axisLabel = new LabelUI();
						axisLabel.style = this.label;
						axisLabel.metaData = labelsData[i];
						axisLabel.render();
						labelUI = TextBitmapUtil.drawUI(axisLabel);
						axisLabel = null;
						
						if (label.layout == LabelStyle.ROTATION)
						{
							// 最小间隔不能小于Label宽度
							if (labelUI.height > horiMinUintSize)
								horiMinUintSize = labelUI.height;
							
							labelX = - Math.cos(Math.PI / 4) * labelUI.width;
							labelY = Math.sin(Math.PI / 4) * labelUI.width;
							labelUI.rotation = - 45;
						}
						else if (label.layout == LabelStyle.VERTICAL)
						{
							// 最小间隔不能小于Label宽度
							if (labelUI.height > horiMinUintSize)
								horiMinUintSize = labelUI.height;
							
							labelX = - labelUI.height / 2;
							labelY = labelUI.width;
							labelUI.rotation = - 90;
						}
						else
						{
							labelX = - labelUI.width / 2;
							labelY = 0;
							
							// 最小间隔不能小于Label宽度
							if (labelUI.width > horiMinUintSize)
								horiMinUintSize = labelUI.width;
						}
						
						labelUI.x = valuePositon + labelX;
						
						if (this.position == 'bottom')
							labelUI.y = label.margin + labelY;
						else
							labelUI.y = - label.margin - labelY - labelUI.height;
						
							
						addChild(labelUI);
					}
				}
				
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
		protected function adjustHoriTicks():void
		{
			
		}
		
		/**
		 * 最小单元格高度
		 * (小于等于这个高度的时候将不再压缩轴)
		 */
		protected var horiMinUintSize:uint = 10;
		
		/**
		 */		
		protected var verticalMinUinitSize:uint = 15;
		
		/**
		 */		
		public function renderVerticalAxis():void
		{
			if (changed)
			{
				clear(); 
				
				_ticks = new Vector.<Number>();
				
				var labelUI:DisplayObject;
				var axisLabel:LabelUI;
				var length:uint = labelAmount;
				var valuePositon:Number;
				
				var labelX:Number;
				var labelY:Number;
				
				var axisLabelFormat:TextFormat = label.getTextFormat(metaData);
				
				//保证标签间距大于最小单元宽度， 防止标签重叠；
				var addFactor:uint = 1;
				var uintAmount:uint = labelAmount;
				while (size > 0 && (this.size / uintAmount) < this.verticalMinUinitSize)
				{
					addFactor += 1;
					uintAmount = labelAmount / addFactor;
				}
				
				for (var i:uint = 0; i < length; i += addFactor)
				{
					valuePositon = valueToY(labelsData[i].value);
					_ticks.push(valuePositon);
					
					if (enable)
					{
						labelsData[i].label = this.getYLabel(labelsData[i].value);
						labelsData[i].color = this.metaData.color;
						
						axisLabel = new LabelUI();
						axisLabel.style = this.label;
						axisLabel.metaData = labelsData[i];
						axisLabel.render();
						labelUI = TextBitmapUtil.drawUI(axisLabel);
						axisLabel = null;
						
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
						addChild(labelUI);
					}
				}
				
				if (enable)
					createVerticalTitle();
				
				adjustVertiTicks();
				
				if (enable && tickMark.enable)
					drawVertiTicks();
				
				changed = false;
			}
		}
		
		protected function adjustVertiTicks():void
		{
		}
		
		/**
		 */		
		protected function drawHoriTicks():void
		{
			// 绘制刻度线
			StyleManager.setLineStyle(graphics, tickMark);
			
			for (var i:uint = 1; i < ticks.length - 1; i ++)
			{
				graphics.moveTo(ticks[i], 0);
				
				if (position == 'bottom')
					graphics.lineTo(ticks[i], tickMark.size);
				else
					graphics.lineTo(ticks[i], - tickMark.size);
			}
		}
		
		/**
		 */		
		protected function drawVertiTicks():void
		{
			// 绘制刻度线
			StyleManager.setLineStyle(graphics, tickMark);
			
			for (var i:uint = 1; i < ticks.length - 1; i ++)
			{
				graphics.moveTo(0, ticks[i]);
				if (position == "left")
					graphics.lineTo(- tickMark.size, ticks[i]);
				else
					graphics.lineTo(tickMark.size, ticks[i]);
			}
		}
		
		/**
		 */		
		protected function createHoriticalTitle():void
		{
			if (title.text.value)
			{
				var titleLabel:LabelUI = new LabelUI();
				titleLabel.style = title;
				titleLabel.metaData = this.metaData;
				titleLabel.render();
				
				titleLabel.x = size * .5 - titleLabel.width * .5;
				
				if (position == 'bottom')
					titleLabel.y = height + title.margin;
				else
					titleLabel.y = - height - title.margin - titleLabel.height;
				
				addChild(titleLabel);
			}
		}
		
		/**
		 */		
		protected function createVerticalTitle():void
		{
			if (title.text.value)
			{
				var titleLabel:LabelUI = new LabelUI();
				titleLabel.metaData = this.metaData;
				titleLabel.style = title;
				titleLabel.render();
				
				var titileBitmap:Bitmap = TextBitmapUtil.drawUI(titleLabel);
				titleLabel = null;
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
		protected function clear() : void
		{
			graphics.clear();
			while ( numChildren > 0 )
				removeChildAt( 0 );
		}
		
		/**
		 * @return 
		 */		
		public function get labelAmount() : uint
		{
			return labelsData.length;
		}
		
		/**
		 */		
		public function redyToUpdateData():void
		{
			sourceValues = new Vector.<Object>;
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
		 */
		public function updateAxis():void
		{
			
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
		 *  Width of every item.
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