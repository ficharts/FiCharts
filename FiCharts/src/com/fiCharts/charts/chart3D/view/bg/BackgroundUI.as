package com.fiCharts.charts.chart3D.view.bg
{
	import com.fiCharts.charts.chart3D.model.vo.bg.BackGroundVO;
	import com.fiCharts.charts.chart3D.view.CubeUI;
	
	import flash.display.Sprite;
	
	public class BackgroundUI extends Sprite
	{
		private var backgroundVO:BackGroundVO;
		
		/**
		 */		
		public function BackgroundUI(backgroundVO:BackGroundVO)
		{
			super();
			
			this.backgroundVO = backgroundVO;
			bottomCube = new CubeUI(backgroundVO.bottomCube);
			backCube = new BgBackCubeUI(backgroundVO.backCube);
			addChild(bottomCube);
			addChild(backCube);
		}
		
		/**
		 */		
		public function render():void
		{
			this.x = backgroundVO.location2D.x;
			this.y = backgroundVO.location2D.y;
			
			bottomCube.render();
			backCube.render();
			
		}
		
		private var bottomCube:CubeUI;
		private var backCube:CubeUI;
	}
}