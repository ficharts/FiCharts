package com.fiCharts.utils
{
	
	/**
	 */	
	public class RexUtil
	{
		public function RexUtil()
		{
		}
		
		/**
		 * 根据标签值从对象上获取满足与此标签对应的属性；
		 */		
		public static function getTagValueFromMataData(tagValue:Object, mataData:Object):Object
		{
			if (isTagValue(tagValue) && mataData)
				return replaceTagValue(tagValue, mataData);
			else if (isBraceParagraph(String(tagValue)) && mataData)
				return replaceFieldBraceValue(String(tagValue), mataData);
			else
				return tagValue;
		}
		
		/**
		 */		
		public static function ifTextNull(value:String):Boolean
		{
			if (value == null)
				return true;
			
			var rex:RegExp = /^\s*$/g;
			return rex.test(value); 
		}
		
		//---------------------------------------
		//
		// 单独的花括号类型值
		//
		//---------------------------------------
		
		/**
		 * 检测数据是否是{value}格式， 花括号包裹的数值；
		 */		
		public static function isTagValue(value:Object):Boolean
		{
			var rex:RegExp = /^\s*\$\{\w+\.?\w*\}\s*(\{\w+\s*:\s*\w+\.?\w*\}\s*)*$/;
			
			return rex.test(String(value)); 
		}
		
		/**
		 * 将包裹字符串的花括号去掉;
		 */		
		public static function removeBrace(property:Object):Object
		{
			var result:String = String(property);
			result = result.slice(result.indexOf('{') + 1, result.length - 1);
			
			return result;
		}
		
		/**
		 * 将花括号类型的数值替换为对象的真正属性；
		 */		
		public static function replaceTagValue(value:Object, metaData:Object):Object
		{
			value = value.replace(/\s*/g, '');// 剔除空格
			
			/*if (value.indexOf(" ") != - 1)
			{
				var original:Array = value.split(" ");
				value = original.join("");
			}*/
			
			// 属性名称的提取
			var rex:RegExp = /(?:\$\{\w+\.?\w*\})/g;
			var valueNameArray:Array = value.match(rex);
			
			//属性处理函数的提取
			rex = /(?:\{\w+\:\w+\.?\w*\})/g;
			var functionArray:Array = value.match(rex);
			
			// 此属性名可以是层级关系
			var propertyFullTagName:String = removeBrace(valueNameArray[0]).toString();
			var propertyTagsArray:Array = propertyFullTagName.split('.');
			
			// 最终的属性值
			var resultValue:String;
			var sourceData:Object = metaData;
			for each (var attributeTag:String in propertyTagsArray)
			{
				resultValue = sourceData[attributeTag];
				sourceData = sourceData[attributeTag];
			}
			
			if (functionArray.length > 0)
			{
				var dynimicFunc:DynamicFunc = new DynamicFunc;
				
				// 对字段值进行函数化处理
				var funcDeparts:Array;
				for each(var func:String in functionArray)
				{
					funcDeparts = removeBrace(func).toString().split(':');
					resultValue = dynimicFunc[funcDeparts[0].toString()](resultValue, funcDeparts[1].toString());
					dynimicFunc.resetFormatter();
				}
				
			}
			
			return resultValue;
		}
		
		
		//-----------------------------------------------
		//
		// 花括号类型值段落
		//
		//-----------------------------------------------
		
		public static function isBraceParagraph(value:String):Boolean
		{
			var rex:RegExp = /(\$\{\w+\.?\w*\}\s*(\s*\{\w+\s*:\s*\w+\.?\w*\}\s*)*)+/;
			return rex.test(value); 
		}
		
		/**
		 * 将一段文本中的数据字段替换为正式的值;
		 */		
		public static function replaceFieldBraceValue(sourceField:String, sourceObject:Object):String
		{
			sourceField = sourceField.replace(/\s*/g, '');// 剔除空格
			
			if (isBraceParagraph(sourceField))
			{
				var value:Object;
				var rex:RegExp = /(?:\$\{\w+\.?\w*\})(\{\w+:\w+\.?\w*\})*/g;
				var braceValues:Array = sourceField.match(rex);
				
				for each (var fieldValue:String in braceValues)
				{
					value = replaceTagValue(fieldValue, sourceObject);
					sourceField = sourceField.replace(fieldValue, value); 
				}
			}
			
			return sourceField;
		}
	}
} 