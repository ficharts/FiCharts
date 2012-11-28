package com.fiCharts.utils
{
	public class ArrayUtil
	{
		public function ArrayUtil()
		{
		}
		
		/**
		 * 移除数组中的元素， 数据量大时如果用 indexOf 判断在push到数组里
		 * 
		 * 的话很耗性能， 用此方法至少提升10倍性能
		 * 
		 * 剔除数组中重复的元素, 并保持原顺序
		 */		
		public static function removeDubItem(arr:Array):void
		{
			var item:Object;
			var a:Object = {};
			var temArr:Array = [];
			var index:uint = 0;
			
			for each (item in arr)
			{
				if (a[item] == null)
				{
					a[item] = "";
					
					temArr[index] = item;
					index ++;
				}
			}
			
			arr.length = 0;
			index = 0;
			for each (item in temArr)
			{
				arr[index] = item;
				index ++;
			}
		}
	}
}