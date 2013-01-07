package com.fiCharts.utils.XMLConfigKit
{
	import com.fiCharts.utils.XMLConfigKit.style.elements.IFreshElement;
	import com.fiCharts.utils.XMLConfigKit.style.elements.IStyleElement;

	/**
	 * 构建XML与AS 对象间的结构属性映射；
	 */	
	public class XMLVOMapper
	{
		public function XMLVOMapper()
		{
		}
		
		/**
		 * 映射函数
		 */		
		public static function fuck(xml:*, vo:Object, parentVo:Object = null):void
		{
			transformNodeAttributes(xml.attributes(), vo, xml.name().toString());
			ransfromNodeChild(xml, vo, parentVo, xml.name().toString());
		}
		
		/**
		 */		
		public static function ransfromNodeChild(xml:*, vo:Object, parentVo:Object = null, voName:String = null):void
		{
			if (xml.children().length() >= 1)
			{
				for each (var child:XML in xml.children())
				{ 
					var childName:String;
					var temObject:Object;
					
					if (child.nodeKind() == 'element')//过滤字符串类型的子节点
						childName = child.name().toString();
					else
					{
						//  当此节点是字符串值时则直接付给父节点对象上
						setObjectProperty(parentVo, voName, child, voName);
						break;
					}
						
					if (vo.hasOwnProperty(childName))
					{
						// 如果属性不存在：默认会根据XML自动创建映射对象或者直接赋字符串数值；
						// 如果属性存在： 默认会更新映射对象的属性或者更新字符类型的属性；
						
						// 默认如果对象已经被创建，再次被XML映射时只是更新受影响的节点，相当于继承原对象；
						// 可以在XML上通过extend标签来标示是否启用继承，如果XML节点上此标签的值为false,
						// 则不继承重新创建对象并赋新值；如果对象上含有reNew， 则也不会被继承;
						// 字符串类型直接赋值无影响；
						
						var attr:Object = vo[childName];
						if (attr)// 此属性已经存在：
						{
							
							if (attr is IFreshElement)
							{
								// 默认不重置对象，仅当XML含有clear节点时才重置对象
								if (child.hasOwnProperty(XMLVOLib.CLEAR))
									(attr as IFreshElement).fresh();
							}
							
							// 节点不继承旧节点属性， 重新构建对象
							if (vo.hasOwnProperty(XMLVOLib.RE_NEW) || child.hasOwnProperty('@' + XMLVOLib.EXTEND) && child.('@' + XMLVOLib.EXTEND) == 'false')
							{
								temObject = getVOByXML(child);
								setObjectProperty(vo, childName, temObject, voName);
								
								if (temObject is IEditableObject)
									(temObject as IEditableObject).created();
							}
							else// 更新对象
							{
								if (child.children().length() == 1 && child.hasSimpleContent())// 将字符串值 直接付给对象
									setObjectProperty(vo, childName, child, voName);
								else
									fuck(child, attr, vo);// 将XML值映射给对象
							}
						}
						else // 属性对象不存在，创建并赋值对象
						{
							if (child.children().length() == 1 && child.hasSimpleContent())// 将字符串值 直接付给对象
								setObjectProperty(vo, childName, child, voName);
							else
							{
								temObject = getVOByXML(child);
								setObjectProperty(vo, childName, temObject, voName);
								
								if (temObject is IEditableObject)
									(temObject as IEditableObject).created();
							}
						}
					}
				}
				
			}
		}
		
		/**
		 * 根据XML信息返回一个对应的样式对象；
		 * 
		 * 并且同时给此对象应用XML的属性；
		 * 
		 * 没有注册此对象的话则认为其实字符类型， 直接赋值；
		 */		
		public static function getVOByXML(xml:XML):*
		{
			var result:*;
			var name:String = xml.name().toString();
			
			if (XMLVOLib.isRegistedClass(name))
			{
				result = XMLVOLib.createRegistedObject(name);
				
				if (result is IEditableObject)
					(result as IEditableObject).beforeUpdateProperties(xml);
				
				XMLVOMapper.fuck(xml, result);
				
			}
			else
			{
				result =  xml.toString();
			}
			
			return result;
		}
		
		/**
		 *  将XML与对象上共同含有的数据进行映射
		 */		
		public static function transformNodeAttributes(nodeAttributes:XMLList, vo:Object, voName:String):void
		{
			for each (var attribute:XML in nodeAttributes)
			{
				var attributeName:String = attribute.name().toString();
				if (vo.hasOwnProperty(attributeName))
					setObjectProperty(vo, attributeName, attribute, voName);
			}
		}
		
		/**
		 * 给对象的属性赋值，如果类型不匹配则是共享对象或者对象属性映射方式赋值;
		 */		
		private static function setObjectProperty(vo:Object, property:String, value:Object, voName:String):void
		{
			try
			{
				vo[property] = value;
			}
			catch(e:Error)
			{
				if (XMLVOLib.isRegistedXML(value.toString()))
					vo[property] = getInstanceFromLib(value);// 对象存在于共享库中
				else if (XMLVOLib.isObjectToProperyRegisted(voName + property))// 将值映射到对象上的某个对应属性
				{
					if (vo[property] == null) // 先创建后赋值
					{
						var mapVO:Object;
						mapVO = XMLVOLib.createRegistedObject(property);
						setObjectProperty(mapVO, XMLVOLib.getObjectToProperty(voName, property), value, property);
						vo[property] = mapVO;
					}
					else
					{
						setObjectProperty(vo[property], XMLVOLib.getObjectToProperty(voName, property), value, property);
					}
				}
			}
		}
		
		/**
		 * 将XML数据全部付给空对象
		 */		
		public static function pushXMLDataToVO(xml:XML, vo:Object):void
		{
			var attributeName:String
			for each (var attribute:XML in xml.attributes())
			{
				attributeName = attribute.name().toString();
				vo[attributeName] = attribute.toString();
			}
		}
		
		/**
		 * 将额外的不与VO对应的属性值付给VO
		 */		
		public static function pushAppedXMLDataToVO(xml:XML, vo:Object):void
		{
			var attributeName:String
			for each (var attribute:XML in xml.attributes())
			{
				attributeName = attribute.name().toString();
				
				if (!vo.hasOwnProperty(attributeName))
				{
					vo[attributeName] = attribute.toString();
				}
			}
		}
		
		/**
		 * 
		 * 将VO上的制定属性付给对象
		 * 
		 */		
		public static function pushAttributesToObject(sourceVO:Object, target:Object, attributes:Array):void
		{
			for each (var attribute:String in attributes)
			{
				target[attribute] = sourceVO[attribute];
			}
		}
		
		/**
		 * XML的继承，但是不会对原数据产生影响，只是生成新的数据；
		 */		
		public static function extendFrom(baseXML:*, targetXML:*):*
		{
			if (baseXML == targetXML) return targetXML;
			
			baseXML.setName(targetXML.name().toString());
			
			var node:*;
			var attributeName:String;
			for each (node in targetXML.attributes())
			{
				attributeName = '@' + node.name().toString();
				
				//if (!baseXML.hasOwnProperty(attributeName))
				 baseXML[attributeName] = node;
			}
			
			var childNodeName:String, preChildNodeName:String;
			for each (node in targetXML.children())
			{
				if (node.nodeKind() == 'element')
					childNodeName = node.name().toString();
				
				if (childNodeName && baseXML.hasOwnProperty(childNodeName))
				{
					if (childNodeName == preChildNodeName)
						baseXML.appendChild(node);
					else
						extendFrom(baseXML.child(childNodeName), node);
				}
				else
				{
					if (node.nodeKind() == 'element')
						baseXML.appendChild(node);
					else// 文字类型节点，新的替换旧的，只保留一个
					{
						baseXML.setChildren(node);
					}
				}
				
				preChildNodeName = childNodeName;
				
			}
			
			return baseXML;
		}
		
		
		
		
		//----------------------------------------------------------
		//
		// 数值转换类函数
		//
		//----------------------------------------------------------
		
		/**
		 * 将字符串类型的原始数值转换为  布尔类型
		 */		
		public static function boolean(source:Object):Boolean
		{
			if (source == 'true' || source == true)
				return true;
			else 
				return false;
		}
		
		/**
		 * 将逗号分隔类型的数据转换为数组;
		 * 
		 * @ifNumberArray, 是否将数组中的元素转化为数字类型
		 */		
		public static function setArrayValue(value:Object, ifNumberArray:Boolean = false):Object
		{
			if (String(value).indexOf(',') != - 1)
			{
				var result:Array = String(value).split(',');
				
				if (ifNumberArray)
					result.forEach(numberArray);
				
				return result;
			}
			else
			{
				return value;
			}
		}
		
		/**
		 */		
		public static function numberArray(item:*, index:int, array:Array):void
		{
			array[index] = Number(item);
		}
		
		/**
		 * 如果传递的是样式对象，直接赋值；
		 * 
		 * 如果是样式ID，根据ID全新构建样式元素
		 */		
		public static function getInstanceFromLib(value:Object):IStyleElement
		{
			var target:*;
			
			if (value is IStyleElement)
				target = value;
			else
				target = getVOByXML_ID(value.toString());
			
			return target;
		}
		
		/**
		 */		
		public static function getVOByXML_ID(id:String):IStyleElement
		{
			if (XMLVOLib.isRegistedXML(id))
			{
				var result:IStyleElement;
				var defination:Object = getStyleXMLBy_ID(id);
				result = XMLVOLib.createRegistedObject(defination.name().toString()) as IStyleElement;
				fuck(defination, result);
				
				return result;
			}
			
			return null;
		}
		
		/**
		 */		
		public static function getStyleXMLBy_ID(id:String):Object
		{
			return XMLVOLib.getXML(id);
		}
		
	}
}