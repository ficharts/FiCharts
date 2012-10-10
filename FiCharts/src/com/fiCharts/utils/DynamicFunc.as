package com.fiCharts.utils
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.StyleManager;
	
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;

	/**
	 * 将经常被使用的方法统一放到这里， 可以动态统一调用；
	 * 
	 * @author wallen
	 * 
	 */	
	public class DynamicFunc
	{
		public function DynamicFunc()
		{
			// 显示小数点前面的0；
			formatter.leadingZero = true;
			
			resetFormatter();
		}
		
		/**
		 */		
		public function resetFormatter():void
		{
			//关闭群组；
			formatter.useGrouping = false;
			formatter.fractionalDigits = 0;
		}
		
		/**
		 * 四舍五入数值
		 */		
		public function round(sourceValue:String, pecision:String):String
		{
			formatter.fractionalDigits = uint(pecision);
			
			return formatter.formatNumber(Number(sourceValue));
		}
		
		/**
		 */		
		public function useGrouping(sourceValue:String, ifGroup:String):String
		{
			formatter.useGrouping = XMLVOMapper.boolean(ifGroup);
			
			return formatter.formatNumber(Number(sourceValue));
		}
		
		/**
		 */		
		private var formatter:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);
		
		/**
		 * 调节颜色值得深浅
		 */		
		public function adjustColor(sourceColor:Object, value:Object):Object
		{
			return StyleManager.transformBright(sourceColor, Number(value));
		}
	}
}