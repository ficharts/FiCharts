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
		 */		
        public function CellData()
        {
            this.shape = new Shape();
        }

    }
}
