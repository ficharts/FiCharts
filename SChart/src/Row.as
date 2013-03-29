package 
{
	/**
	 */
    public class Row extends Object
    {
		/**
		 */		
        private var _y:Number = 0;
		
		/**
		 */		
        private var _height:Number = 0;

		/**
		 */		
        public function Row()
        {
            return;
        }

		/**
		 */		
        public function get y():Number
        {
            return this._y;
        }

		/**
		 */		
        public function set y(value:Number):void
        {
            this._y = value;
        }

		/**
		 */		
        public function get height():Number
        {
            return this._height;
        }

		/**
		 */		
        public function set height(value:Number):void
        {
            this._height = value;
        }

    }
}
