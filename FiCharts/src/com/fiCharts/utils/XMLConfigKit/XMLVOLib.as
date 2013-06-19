package com.fiCharts.utils.XMLConfigKit
{
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.Map;
	import com.fiCharts.utils.XMLConfigKit.effect.Blur;
	import com.fiCharts.utils.XMLConfigKit.effect.Effects;
	import com.fiCharts.utils.XMLConfigKit.effect.Glow;
	import com.fiCharts.utils.XMLConfigKit.effect.Shadow;
	import com.fiCharts.utils.XMLConfigKit.shape.CircleShape;
	import com.fiCharts.utils.XMLConfigKit.shape.Diamond;
	import com.fiCharts.utils.XMLConfigKit.shape.RectShape;
	import com.fiCharts.utils.XMLConfigKit.shape.Triangle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.Text;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Cover;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Img;
	import com.fiCharts.utils.XMLConfigKit.style.elements.TextFormatStyle;

	/**
	 * 
	 */	
	public class XMLVOLib
	{
		/**
		 * 若对象含有此属性时， 不管对象是否已被创建， XML映射时都重新构建；
		 */		
		public static const RE_NEW:String = 'reNew';
		
		/**
		 * 若XML对象拥有此属性，并且为 true， 重新映射的时候刷新对象； 
		 */		
		public static const CLEAR:String = 'fresh';
		
		/**
		 * 如果对象拥有此属性并且值为 false 则重新构建对象；
		 */		
		public static const EXTEND:String = 'extends';
		
		
		/**
		 */		
		public static function createLib(key:String):XMLVOLib
		{
			if (libs.containsKey(key))
			{
				return libs.getValue(key) as XMLVOLib;
			}
			else
			{
				var lib:XMLVOLib = new XMLVOLib;
				libs.put(key, lib);
				
				return lib;
			}
		}
		
		/**
		 */		
		private static var libs:Map = new Map;
		
		
		
		/**
		 * 
		 * 这里存储着共享库和基础元素类定义，共享库分全局库和临时库
		 * 
		 * 全局库随系统初始化建立，临时库会动态改变
		 * 
		 * 库元素采用而为结构存储，第一层是所属分类，第二层是具体的值对关系
		 * 
		 */			
		public function XMLVOLib()
		{
			Cover;
			BorderLine;
			Fill;
			Img;
			States;
			LabelStyle;
			TextFormatStyle;
			Style;
			Text;
			Effects;
			Shadow;
			Blur;
			Glow;
			
			CircleShape;
			RectShape;
			Diamond;
			Triangle;
		}
		
		/**
		 */		
		public static function initCore():void
		{
			
		}
		
		/**
		 */		
		public static function addCreationHandler(name:String, handler:Function):void
		{
			creationMaps.put(name, handler);
		}
		
		/**
		 */		
		public static function removeCreationHandler(name:String, handler:Function):void
		{
			if (creationMaps.containsKey(name))
				creationMaps.remove(name);
		}
		
		/**
		 */		
		public static function dispatchCreation(name:String, value:Object = null):void
		{
			if (creationMaps.containsKey(name))
				creationMaps.getValue(name)(value);
		}
		
		/**
		 */		
		private static var creationMaps:Map = new Map;
		
		
		
		
		
		
		//---------------------------------------------------------------------------
		//
		// 将付给对象上某个属性的值转嫁到改对象的另一个属性上；映射范围先是同一层再深一层
		//
		//---------------------------------------------------------------------------
		
		
		public static function isRegistedPropertyToProperty(object:String, sourceProperty:String):Boolean
		{
			return propertyToPropertyMap.containsKey(object + sourceProperty);
		}
		
		/**
		 */		
		public static function registerPropertyToProperty(object:String, sourceProperty:String, targetProperty:String):void
		{
			propertyToPropertyMap.put(object + sourceProperty, targetProperty);
		}
		
		/**
		 */		
		public static function getTargetProperty(object:String, sourceProperty:String):String
		{
			return propertyToPropertyMap.getValue(object + sourceProperty);
		}
		
		/**
		 */		
		private static var propertyToPropertyMap:Map = new Map;
		
		
		
		
		
		
		
		
		//---------------------------------------------------------------------------------
		//
		// 将付给对象的值映射到对象的某个属性上; 映射范围是层级递进的
		//
		// 如果需要快捷设置对象上的某个属性时，属性类型不匹配，直接把属性值赋给对象的话会报错
		//
		// 需要转换一下，如果对象为空则创建对象，然后将值付给对象上的响应属性。
		//
		// 以Key，值得方式映射对象，属性；
		//
		//---------------------------------------------------------------------------------
		
		/**
		 */		
		public static function isObjectToProperyRegisted(key:String):Boolean
		{
			return objectToPropertyMap.containsKey(key);
		}
		
		/**
		 */		
		public static function registerObjectToProperty(baseOB:String, property:String, valueTag:String):void
		{
			objectToPropertyMap.put(baseOB + property, valueTag);
		}
		
		public static function getObjectToProperty(baseOB:String, property:String):String
		{
			return objectToPropertyMap.getValue(baseOB + property)
		}
		
		/**
		 */		
		private static var objectToPropertyMap:Map = new Map();
		
		
		
		
		
		
		//----------------------------------------------------------------
		//
		// 共享库分全局和局部，局部库会经常变动
		//
		// 有一些可共享，可被重复使用或者转接的XML配置需要存储在统一的地方 
		//
		//----------------------------------------------------------------
		
		/**
		 * 
		 * 注意： 如果局部不存在某元素，还要在全局区寻找一下
		 * 
		 */		
		public static function isRegistedXML(key:String, type:String):Boolean
		{
			if (partXMLLib.containsKey(type))
			{
				if (partXMLLib.getValue(type)[key])
					return true;
			}
			
			if (wholeXmlLib.containsKey(type))
			{
				if (wholeXmlLib.getValue(type)[key])
					return true;
				
				return false;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 */		
		public static function registWholeXML(key:String, xml:*, type:String):void
		{
			if (wholeXmlLib.containsKey(type))
			{
				wholeXmlLib.getValue(type)[key] = xml;
			}
			else
			{
				var vo:Object = new Object;
				vo[key] = xml;
				wholeXmlLib.put(type, vo);
			}
		}
		
		/**
		 */		
		public static function registerPartXML(key:String, xml:*, type:String):void
		{
			if (partXMLLib.containsKey(type))
			{
				partXMLLib.getValue(type)[key] = xml;
			}
			else
			{
				var vo:Object = new Object;
				vo[key] = xml;
				partXMLLib.put(type, vo);
			}
		}
		
		/**
		 * 局部不存在的元素，全局可能存在
		 * 
		 * type 为类型
		 * 
		 * key 为具体的id
		 * 
		 */		
		public static function getXML(key:String, type:String):*
		{
			var value:Object;
			
			if (partXMLLib.containsKey(type))
			{
				value = partXMLLib.getValue(type)[key];
					
				if (value)
					return value;
			}
			
			// 全局无条件排查
			value = wholeXmlLib.getValue(type)[key];
			
			if (value)
				return value;
		}
		
		/**
		 * 清空临时库
		 */		
		public static function clearPartLib():void
		{
			partXMLLib.clear();
		}
		
		/**
		 */		
		private static var wholeXmlLib:Map = new Map;
		
		/**
		 */		
		private static var partXMLLib:Map = new Map;
		
		
		
		
		
		
		
		
		//-------------------------------------------------------
		//
		//  以XML方式注册类信息，节点名为Key值， 后继就可以根据节点名
		//
		//  创建对象, 并赋值;
		//
		//-------------------------------------------------------
		
		/**
		 * 注册自定义的类， 以便后继根据XML信息创建此类;
		 * 
		 * <br/>
		 * 
		 * <code><name path='class path'/></code>
		 * 
		 */		
		public static function registerCustomClasses(value:XML):void
		{
			if (!registedClasses.hasOwnProperty(value.name().toString()))
			{
				registedClasses.appendChild(value);
			}
		}
		
		/**
		 * 根据样式的节点名称创建样式对象；
		 */		
		public static function createRegistedObject(name:String):Object
		{
			return ClassUtil.getObjectByClassPath(registedClasses[name].@path);
		}
		
		/**
		 */		
		internal static function isRegistedClass(name:String):Boolean
		{
			if (registedClasses.hasOwnProperty(name))
				return true;
			else
				return false;
		}
		
		/**
		 */		
		public static function setASLabelStyleKey(key:String):void
		{
			registerCustomClasses(<{key} path='com.fiCharts.utils.XMLConfigKit.style.LabelStyle'/>);
		}
		
		/**
		 */		
		public static function setASStyleKey(key:String):void
		{
			registerCustomClasses(<{key} path='com.fiCharts.utils.XMLConfigKit.style.Style'/>);
		}
		
		/**
		 * 自定义的对象列表， 根据这些信息创建特定的对象， 这些对象通常是程序特有的定义类；
		 * 
		 * 默认的常见样式类可直接创建， 特定的类需要类信息才可以创建；
		 */		
		private static var registedClasses:XML = 
							<classes>
								<!--基础样式元素-->
								<border path='com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine'/>
								<cover path='com.fiCharts.utils.XMLConfigKit.style.elements.Cover'/>
								<fill path='com.fiCharts.utils.XMLConfigKit.style.elements.Fill'/>
								<format path='com.fiCharts.utils.XMLConfigKit.style.elements.TextFormatStyle'/>
								<img path='com.fiCharts.utils.XMLConfigKit.style.elements.Img'/>
								
								<!--样式模型-->
								<label path='com.fiCharts.utils.XMLConfigKit.style.LabelStyle'/>
								<text path='com.fiCharts.utils.XMLConfigKit.style.Text'/>
								<states path='com.fiCharts.utils.XMLConfigKit.style.States'/>
								<bg path='com.fiCharts.utils.XMLConfigKit.style.ContainerStyle'/>
								<normal path='com.fiCharts.utils.XMLConfigKit.style.Style'/>
								<hover path='com.fiCharts.utils.XMLConfigKit.style.Style'/>
								<down path='com.fiCharts.utils.XMLConfigKit.style.Style'/>
								<style path='com.fiCharts.utils.XMLConfigKit.style.Style'/>
								
								<!-- 滤镜效果-->
								<effects path='com.fiCharts.utils.XMLConfigKit.effect.Effects'/>
								<shadow path='com.fiCharts.utils.XMLConfigKit.effect.Shadow'/>
								<blur path='com.fiCharts.utils.XMLConfigKit.effect.Blur'/>
								<glow path='com.fiCharts.utils.XMLConfigKit.effect.Glow'/>
								<noise path='com.fiCharts.utils.XMLConfigKit.effect.Noise'/> 
								
								<!--形状-->
								<circle path='com.fiCharts.utils.XMLConfigKit.shape.CircleShape'/>
								<rect path='com.fiCharts.utils.XMLConfigKit.shape.RectShape'/>
								<diamond path='com.fiCharts.utils.XMLConfigKit.shape.Diamond'/>
								<triangle path='com.fiCharts.utils.XMLConfigKit.shape.Triangle'/>
		
							</classes>
		
		
	}
}