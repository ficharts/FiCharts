package 
{
	import flash.display.Sprite;

	/**
	 */
    public class DataGrid extends Sprite
    {
        private var columns:Vector.<Column>;
        private var rows:Vector.<Row>;
        private var grid:Grid;
        private var editCanvas:EditCanvas;

		/**
		 */		
        public function DataGrid()
        {
            this.columns = new Vector.<Column>;
            this.rows = new Vector.<Row>;
            this.grid = new Grid();
            this.editCanvas = new EditCanvas();
            addChild(this.grid);
			
            this.editCanvas.columns = this.columns;
            this.editCanvas.rows = this.rows;
            this.editCanvas.w = this.gridW;
            this.editCanvas.h = this.gridH;
			
            addChild(this.editCanvas);
        }

		/**
		 */		
        public function render() : void
        {
            this.grid.render(this.columns, this.rows);
        }

		/**
		 */		
        public function get gridW() : Number
        {
            return this.grid.w;
        }

		/**
		 */		
        public function set gridW(param1:Number) : void
        {
            this.grid.w = param1;
        }

		/**
		 */		
        public function get gridH() : Number
        {
            return this.grid.h;
        }

		/**
		 */		
        public function set gridH(param1:Number) : void
        {
            this.grid.h = param1;
        }

    }
}
