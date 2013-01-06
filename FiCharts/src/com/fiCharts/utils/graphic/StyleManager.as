package com.fiCharts.utils.graphic
{
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectElement;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectable;
	import com.fiCharts.utils.XMLConfigKit.effect.Noise;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.Text;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Cover;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;

	/**
	 * 定义应用各种样式的  样式控制器；负责具体的绘制工作
	 */	
	dynamic public class StyleManager extends Array
	{
		
		/**
		 * 
		 * 绘制圆弧
		 * 
		 * @param canvas
		 * @param style
		 * @param radius
		 * @param metaData
		 * 
		 */		
		public static function drawArc(canvas:Sprite, style:Style, 
									   radius:Number, rads:Vector.<Number>, metaData:Object = null):void
		{
			style.radius = radius;
			setShapeStyle(style, canvas.graphics, metaData);
			
			canvas.graphics.moveTo(0, 0);
			
			for each (var rad:Number in rads)
			{
				canvas.graphics.lineTo(radius * Math.cos(rad), 
					- radius * Math.sin(rad));
			}
			
			canvas.graphics.lineTo(0, 0);
			canvas.graphics.endFill();
			
			StyleManager.setEffects(canvas, style, metaData);
		}
		
		
		/**
		 */		
		public static function drawRect(target:Sprite, style:Style, metaData:Object = null):void
		{
			setShapeStyle(style, target.graphics, metaData);
			target.graphics.drawRoundRect(style.tx, style.ty, style.width, style.height, style.radius, style.radius);
			target.graphics.endFill();
			
			drawRectCover(target.graphics, style.getCover, metaData);
			StyleManager.setEffects(target, style, metaData);
		}
		
		/**
		 */		
		public static function drawCircle(target:Sprite, style:Style, metaData:Object, x:Number = 0, y:Number = 0):void
		{
			setShapeStyle(style, target.graphics, metaData);
			target.graphics.drawCircle(x, y, style.radius);
			target.graphics.endFill();
			
			drawCircleCover(target.graphics, style.getCover, metaData);
			StyleManager.setEffects(target, style, metaData);
		}
		
		/**
		 * 绘制菱形
		 */		
		public static function drawDiamond(target:Sprite, style:Style, metaData:Object = null):void
		{
			setShapeStyle(style, target.graphics, metaData);
			
			target.graphics.moveTo(0, - style.radius);
			target.graphics.lineTo(style.radius, 0);
			target.graphics.lineTo(0, style.radius);
			target.graphics.lineTo( - style.radius, 0)
			target.graphics.lineTo(0, - style.radius);
			
			target.graphics.endFill();
			
			StyleManager.setEffects(target, style, metaData);
		}
		
		/**
		 * 设定滤镜，噪点等效果；
		 */		
		public static function setEffects(target:DisplayObject, effectable:IEffectable, metaData:Object = null):void
		{
			// 移动平台下为了提升性能，去除一些滤镜效果
			/*if (OS.isDesktopSystem == false)
				return;*/ 
			
			if (effectable.effects)
			{
				var filters:Array = [];
				for each(var effect:IEffectElement in effectable.effects.effects)
				{
					
					if (effect is Noise)
					{
						if (target is IBitmapDrawable)
							var bitMapData:BitmapData = BitmapUtil.drawBitData(target);
							
						bitMapData.noise((effect as Noise).randomSpeed, (effect as Noise).low, (effect as Noise).high,
							(effect as Noise).channelOptions, (effect as Noise).grayScale as Boolean);
						
						if (target is Sprite)
						{
							var mar:Matrix = new Matrix();
							mar.createGradientBox(target.width, target.height);
							
							var width:Number = target.width;
							var height:Number = target.height;
							
							(target as Sprite).graphics.clear();
							(target as Sprite).graphics.beginBitmapFill(bitMapData, null, false);
							(target as Sprite).graphics.drawRect(0, 0, width, height);
							(target as Sprite).graphics.endFill();
						}
					}
					else
					{
						filters.push(effect.getEffect(metaData));
					}
				}
				
				target.filters = filters;
			}
			else
			{
				target.filters = null;
			}
			
			//new BitmapData(200, 200).draw(target);
		}
		
		
		//-------------------------------------------
		//
		// 绘制高光效果
		//
		//-------------------------------------------
		
		/**
		 * 绘制圆形高光
		 */		
		public static function drawCircleCover(canvas:Graphics, cover:Cover, metaData:Object = null):void
		{
			if (cover)
			{
				setShapeStyle(cover, canvas, metaData);
				canvas.drawCircle(0, 0, cover.radius - cover.offset);
				canvas.endFill();
			}
		}
		
		/**
		 *  绘制矩形高光
		 */		
		public static function drawRectCover(canvas:Graphics, cover:Cover, metaData:Object):void
		{
			if (cover)
			{
				var xOffset:Number;
				var yOffset:Number;
				
				if (cover.width >= 0)
					xOffset = cover.offset;
				else
					xOffset = - cover.offset;
				
				if (cover.height >= 0)
					yOffset = cover.offset;
				else
					yOffset = - cover.offset;
				
				setShapeStyle(cover, canvas, metaData);
				canvas.drawRoundRect(cover.tx + xOffset, cover.ty + yOffset, 
					cover.width - xOffset * 2, cover.height - yOffset * 2, 
					cover.radius, cover.radius);
				
				canvas.endFill();
			}
		}
		
		/**
		 * 设置文本的内容；
		 */		
		public static function setLabelUIText(labelUI:LabelUI, mataData:Object = null):void
		{
			var value:String;
			var textStyle:Text = (labelUI.style as LabelStyle).text as Text;
			
			if (labelUI.text == null)
				value = RexUtil.getTagValueFromMataData(textStyle.value, mataData).toString();
			else
				value = labelUI.text;
			
			if (value.length > textStyle.substr)
				value = value.substr(0, textStyle.substr) + "..."
				
			labelUI.text = value;
		}
		
		
		//--------------------------------------
		//
		// 应用样式
		//
		//--------------------------------------
		
		
		/**
		 * 设置形状边框与填充信息, 仅当样式存在时才设置该样式项；
		 */		
		public static function setShapeStyle(style:Style, target:Graphics, 
										metaData:Object = null):void
		{
			
			setLineStyle(target, style.getBorder, style, metaData);
			setFillStyle(target, style, metaData);
		}
		
		/**
		 */		
		public static function setLineStyle(graphic:Graphics, lineStyle:BorderLine, style:Style = null, metaData:Object = null):void
		{
			if (lineStyle)
			{
				//动态获取到填充色
				var lineColor:Object = getColor(metaData, lineStyle.color);
				if (lineColor is Array)
				{
					var colors:Array = lineColor as Array;
					var alphas:Array = lineStyle.alpha as Array;
					var ratios:Array = lineStyle.radioes as Array;
					
					matr.createGradientBox(style.width, style.height, lineStyle.angle, style.tx, style.ty);
					graphic.lineGradientStyle(lineStyle.type, colors, alphas, ratios, matr, SpreadMethod.PAD); 
				}
				else
				{
					graphic.lineStyle(lineStyle.thikness, uint(getColor(metaData, lineStyle.color)), 
						Number(lineStyle.alpha), lineStyle.pixelHinting, lineStyle.scaleMode, lineStyle.caps, lineStyle.joints);
				}
			}
		}
		
		/**
		 */		
		public static function setFillStyle(graphic:Graphics, style:Style, metaData:Object = null):void
		{
			var fillStyle:Fill = style.getFill;
			
			if (fillStyle)
			{
				//动态获取到填充色
				var fillColor:Object = getColor(metaData, fillStyle.color);
				
				if (fillColor is Array)
				{
					var colors:Array = fillColor as Array;
					var alphas:Array = fillStyle.alpha as Array;
					var ratios:Array = fillStyle.radioes as Array;
					
					matr.createGradientBox(style.width, style.height, fillStyle.angle, style.tx, style.ty);
					graphic.beginGradientFill(fillStyle.type, colors, alphas, ratios, matr, SpreadMethod.PAD); 
				}
				else
				{
					graphic.beginFill(uint(fillColor), Number(fillStyle.alpha));
				}
			}
		}
		
		
		//------------------------------------
		//
		// 效果滤镜
		//
		//------------------------------------
		
		/**
		 */		
		public static function getOverFilter():Array
		{
			if (overFilter == null)
			{
				var colorMangager:StyleManager = new StyleManager;
				colorMangager.adjustBrightness(25);
				colorMangager.adjustContrast(25);
				overFilter = [new ColorMatrixFilter(colorMangager)];
			}
			
			return overFilter;
		}
		
		/**
		 */		
		private static var overFilter:Array;
		
		/**
		 */		
		public static function getDisableFilter():Array
		{
			if (disableFilter == null)
			{
				var matrix:Array = [
					0.3, 0.59, 0.11, 0, 0, 
					0.3, 0.59, 0.11, 0, 0,
					0.3, 0.59, 0.11, 0, 0,
					0  , 0   , 0   , 1, 0 
				];
				
				disableFilter = [new ColorMatrixFilter(matrix)];	
			}
			
			return disableFilter;
		}
		
		/**
		 */		
		private static var disableFilter:Array;
		
		
		
		
		
		//-----------------------------------------------
		//
		// 颜色控制
		//
		//-----------------------------------------------
		
		/**
		 * 获取颜色值或者通过颜色字段映射出来的颜色；
		 */		
		public static function getColor(metaData:Object, sourceColor:Object):Object
		{
			if (sourceColor == null)
				return null;
			
			if (sourceColor is Array)// 颜色数组
			{
				var resultColor:Array = [];
				for each (var colorItem:String in sourceColor)
					resultColor.push(getColor(metaData, colorItem));
				
				return resultColor;
			}
			else
			{
				return uint(RexUtil.getTagValueFromMataData(sourceColor, metaData));
			}
		}
		
		/**
		 * 设置字符串颜色或者颜色字段；
		 */		
		public static function setColor(value:Object):Object
		{
			if (String(value).indexOf(',') != - 1)
			{
				var result:Array = XMLVOMapper.setArrayValue(value) as Array;
				result.forEach(formatColorArray);
				
				return result;
			}
			else if (RexUtil.isTagValue(value))
			{
				return value;
			}
			else
			{
				return StyleManager.getUintColor(value);
			}
		}
		
		/**
		 * 将数组中颜色值格式化为正确值
		 */		
		private static function formatColorArray(item:Object, index:uint, array:Array):void
		{
			if (RexUtil.isTagValue(item))
				array[index] = item;
			else
				array[index] = getUintColor(item);
		}
		
		/**
		 * 将字符类型的颜色数据转换为unit类型;
		 */		
		public static function getUintColor(value:Object):uint
		{
			var result:uint;
			
			if (String(value).indexOf('#') != - 1)
			{
				result = uint(String(value).replace('#', '0x'));
			}
			else
			{
				result = uint("0x" + value.toString());
			}
			
			return result;
		}
		
		/**
		 * 调节颜色亮度， 数值越高越亮；
		 */		
		public static function transformBright(baseColor:Object, factor:Number):uint
		{
			return transformColor(baseColor, factor, factor, factor);
		}
		
		/**
		 * 系数的值越高，数值越高越亮；
		 */		
		public static function transformColor(baseColor:Object, 
											  redFactor:Number, greenFactor:Number, blueFactor:Number):uint
		{
			var resultColor:uint;
			var red:uint = uint(baseColor) >> 16 & 0xFF;
			var green:uint = uint(baseColor) >> 8 & 0xFF;
			var blue:uint = uint(baseColor) & 0xFF;
			
			if (red == 0 && redFactor > 1) red = 50;
			if (green == 0 && greenFactor > 1) green = 50;
			if (blue == 0 && blueFactor > 1) blue = 50;
			
			red = formatColorChannel(red * redFactor);
			green = formatColorChannel(green * greenFactor);
			blue = formatColorChannel(blue * blueFactor);
			
			resultColor = (red << 16) | (green << 8) | blue;
			
			return resultColor;
		}
		
		
		
		
		
		
		
		//---------------------------------------------
		//
		// 基础函数
		//
		//---------------------------------------------
		
		/**
		 */		
		private static var matr:Matrix = new Matrix();
		
		/**
		 * @param value
		 * @return 
		 */		
		private static function formatColorChannel(value:uint):uint
		{
			if (value > 255) value = 255;
			else if (value < 0) value = 0;
			
			return value;
		}
		
		// constant for contrast calculations:
		private static const DELTA_INDEX:Array = [
			0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
			0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
			0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
			0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
			0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
			1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
			1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
			2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
			4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
			7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
			10.0
		];
	
		// identity matrix constant:
		private static const IDENTITY_MATRIX:Array = [
			1,0,0,0,0,
			0,1,0,0,0,
			0,0,1,0,0,
			0,0,0,1,0,
			0,0,0,0,1
		];
		
		private static const LENGTH:Number = IDENTITY_MATRIX.length;
	
		/**
		 */		
		public function StyleManager(p_matrix:Array=null) 
		{
			p_matrix = fixMatrix(p_matrix);
			copyMatrix(((p_matrix.length == LENGTH) ? p_matrix : IDENTITY_MATRIX));
		}
		
		/**
		 */		
		public function reset():void 
		{
			for (var i:uint=0; i<LENGTH; i++) 
			{
				this[i] = IDENTITY_MATRIX[i];
			}
		}
	
		public function adjustColor(p_brightness:Number,p_contrast:Number,p_saturation:Number,p_hue:Number):void 
		{
			adjustHue(p_hue);
			adjustContrast(p_contrast);
			adjustBrightness(p_brightness);
			adjustSaturation(p_saturation);
		}

		public function adjustBrightness(p_val:Number):void 
		{
			p_val = cleanValue(p_val,100);
			if (p_val == 0 || isNaN(p_val)) { return; }
			multiplyMatrix([
				1,0,0,0,p_val,
				0,1,0,0,p_val,
				0,0,1,0,p_val,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
	
		public function adjustContrast(p_val:Number):void 
		{
			p_val = cleanValue(p_val,100);
			if (p_val == 0 || isNaN(p_val)) { return; }
			var x:Number;
			if (p_val<0) 
			{
				x = 127+p_val/100*127
			} 
			else 
			{
				x = p_val%1;
				if (x == 0) 
				{
					x = DELTA_INDEX[p_val];
				} 
				else 
				{
					//x = DELTA_INDEX[(p_val<<0)]; // this is how the IDE does it.
					x = DELTA_INDEX[(p_val<<0)]*(1-x)+DELTA_INDEX[(p_val<<0)+1]*x; // use linear interpolation for more granularity.
				}
				x = x*127+127;
			}
			
			multiplyMatrix([
				x/127,0,0,0,0.5*(127-x),
				0,x/127,0,0,0.5*(127-x),
				0,0,x/127,0,0.5*(127-x),
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
	
		public function adjustSaturation(p_val:Number):void 
		{
			p_val = cleanValue(p_val,100);
			if (p_val == 0 || isNaN(p_val)) { return; }
			var x:Number = 1+((p_val > 0) ? 3*p_val/100 : p_val/100);
			var lumR:Number = 0.3086;
			var lumG:Number = 0.6094;
			var lumB:Number = 0.0820;
			
			multiplyMatrix([
				lumR*(1-x)+x,lumG*(1-x),lumB*(1-x),0,0,
				lumR*(1-x),lumG*(1-x)+x,lumB*(1-x),0,0,
				lumR*(1-x),lumG*(1-x),lumB*(1-x)+x,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
	
		public function adjustHue(p_val:Number):void 
		{
			p_val = cleanValue(p_val,180)/180*Math.PI;
			if (p_val == 0 || isNaN(p_val)) { return; }
			var cosVal:Number = Math.cos(p_val);
			var sinVal:Number = Math.sin(p_val);
			var lumR:Number = 0.213;
			var lumG:Number = 0.715;
			var lumB:Number = 0.072;
			multiplyMatrix([
				lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(-lumG),lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0,
				lumR+cosVal*(-lumR)+sinVal*(0.143),lumG+cosVal*(1-lumG)+sinVal*(0.140),lumB+cosVal*(-lumB)+sinVal*(-0.283),0,0,
				lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG)+sinVal*(lumG),lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
	
		public function concat(p_matrix:Array):void 
		{
			p_matrix = fixMatrix(p_matrix);
			if (p_matrix.length != LENGTH) { return; }
			multiplyMatrix(p_matrix);
		}
		
		public function clone():StyleManager 
		{
			return new StyleManager(this);
		}
	
		public function toString():String 
		{
			return "ColorMatrix [ "+this.join(" , ")+" ]";
		}
		
		// return a length 20 array (5x4):
		public function toArray():Array 
		{
			return slice(0,20);
		}
	
		// copy the specified matrix's values to this matrix:
		protected function copyMatrix(p_matrix:Array):void 
		{
			var l:Number = LENGTH;
			for (var i:uint=0;i<l;i++)
			{
				this[i] = p_matrix[i];
			}
		}
	
		// multiplies one matrix against another:
		protected function multiplyMatrix(p_matrix:Array):void
		{
			var col:Array = [];
			
			for (var i:uint=0;i<5;i++) {
				for (var j:uint=0;j<5;j++) 
				{
					col[j] = this[j+i*5];
				}
				
				for (j=0;j<5;j++) 
				{
					var val:Number=0;
					for (var k:Number=0;k<5;k++) 
					{
						val += p_matrix[j+k*5]*col[k];
					}
					
					this[j+i*5] = val;
				}
			}
		}
		
		// make sure values are within the specified range, hue has a limit of 180, others are 100:
		protected function cleanValue(p_val:Number,p_limit:Number):Number 
		{
			return Math.min(p_limit,Math.max(-p_limit,p_val));
		}
	
		// makes sure matrixes are 5x5 (25 long):
		protected function fixMatrix(p_matrix:Array=null):Array 
		{
			if (p_matrix == null) { return IDENTITY_MATRIX; }
			if (p_matrix is StyleManager) { p_matrix = p_matrix.slice(0); }
			
			if (p_matrix.length < LENGTH) 
			{
				p_matrix = p_matrix.slice(0,p_matrix.length).concat(IDENTITY_MATRIX.slice(p_matrix.length,LENGTH));
			} 
			else if (p_matrix.length > LENGTH) 
			{
				p_matrix = p_matrix.slice(0,LENGTH);
			}
			
			return p_matrix;
		}
	}
}