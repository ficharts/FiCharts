package com.dataGrid 
{
	import flash.display.Shape;

	/**
	 */	
    public class CellData extends Object
    {
		/**
		 */		
        public var label:String = "";
		
		/**
		 */		
        public var shape:Shape;
		
		/**
		 * 是否单元格的值已被验证， 是有效的
		 * 
		 * 无效的值会被 
		 */		
		public var ifVerified:Boolean = false;

		/**
		 */		
        public function CellData()
        {
            this.shape = new Shape();
        }

    }
}
