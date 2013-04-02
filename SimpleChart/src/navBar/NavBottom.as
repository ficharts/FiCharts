package navBar
{
	import flash.display.Sprite;
	
	/**
	 */	
	public class NavBottom extends Sprite
	{
		public function NavBottom(main:SimpleChart)
		{
			super();
			this.main = main;
			
			currentNav = this.templateNav;
		}
		
		/**
		 */		
		public function toTemplatePage():void
		{
			this.currentNav.toTemplatePage(this);
		}
		
		/**
		 */		
		public function toEditPage():void
		{
			this.currentNav.toEditPage(this);
		}
		
		/**
		 */		
		public function toChartPage():void
		{
			this.currentNav.toChartPage(this);
		}
		
		/**
		 */		
		internal var main:SimpleChart;
		
		/**
		 */		
		internal var currentNav:INav;
		
		/**
		 */		
		internal var templateNav:INav = new TemplateNav;
		
		/**
		 */		
		internal var editNav:INav = new EditNav;
		
		/**
		 */		
		internal var chartNav:INav = new ChartNav;
		
	}
}