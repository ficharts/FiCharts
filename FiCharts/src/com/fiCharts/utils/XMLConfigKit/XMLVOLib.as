package com.fiCharts.utils.XMLConfigKit
{
	import com.fiCharts.utils.ClassUtil;
	import com.fiCharts.utils.Map;
	import com.fiCharts.utils.XMLConfigKit.effect.Blur;
	import com.fiCharts.utils.XMLConfigKit.effect.Effects;
	import com.fiCharts.utils.XMLConfigKit.effect.Glow;
	import com.fiCharts.utils.XMLConfigKit.effect.IEffectElement;
	import com.fiCharts.utils.XMLConfigKit.effect.Shadow;
	import com.fiCharts.utils.XMLConfigKit.shape.CircleShape;
	import com.fiCharts.utils.XMLConfigKit.shape.RectShape;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.States;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.XMLConfigKit.style.Text;
	import com.fiCharts.utils.XMLConfigKit.style.elements.BorderLine;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Cover;
	import com.fiCharts.utils.XMLConfigKit.style.elements.Fill;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;
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
		 * 若对象拥有此方法时并且已被创建， 重新映射的时候调用此方法刷新对象； 
		 */		
		public static const FRESH:String = 'fresh';
		
		/**
		 * 如果对象拥有此属性并且值为 false 则重新构建对象；
		 */		
		public static const EXTEND:String = 'extends';
		
		/**
		 */			
		public function XMLVOLib()
		{
			Cover;
			BorderLine;
			Fill;
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
		
		
		
		
		
		
		//--------------------------------------------------
		//
		// 有一些可共享，可被重复使用或者转接的XML配置需要存储在统一的地方 
		//
		//--------------------------------------------------
		
		/**
		 */		
		public static function isRegistedXML(key:String):Boolean
		{
			return xmlLib.containsKey(key);
		}
		
		/**
		 */		
		public static function setXML(key:String, xml:*):void
		{
			xmlLib.put(key, xml);
		}
		
		/**
		 */		
		public static function getXML(key:String):*
		{
			return xmlLib.getValue(key);
		}
		
		/**
		 */		
		private static var xmlLib:Map = new Map;
		
		
		
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
			
		</classes>
		
		
	}
}