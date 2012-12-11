package com.fiCharts.utils.interactive
{
	public interface IDragCanvas
	{
		/**
		 * 
		 */		
		function startScroll():void;
		
		/*
		 */		
		function scrolling(offset:Number, sourceOffset:Number):void;
		
		/**
		 */		
		function stopScroll():void;
			
	}
}