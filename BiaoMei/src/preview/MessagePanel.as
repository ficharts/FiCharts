package preview
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.LabelStyle;
	import com.fiCharts.utils.XMLConfigKit.style.LabelUI;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	
	import fl.controls.Label;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class MessagePanel extends Sprite
	{
		public function MessagePanel()
		{
			super();
			
			XMLVOMapper.fuck(labelStyleXML, textStyle);
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			this.addChild(labelUI);
		}
		
		/**
		 */		
		public function alert(value:String):void
		{
			
		}
		
		/**
		 */		
		private var labelUI:Label = new LabelUI;
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var textStyle:LabelStyle = new LabelStyle;
		
		/**
		 */		
		private var bgStyleXML:XML = <style>
				<fill color="555555" alpha="0.7"/>
			</style>
		
		
		/**
		 */			
		private var labelStyleXML:XML = <label>
											<format color='FFFFFF' font='Constantia' size='30' letterSpacing="3"/>
												<text>
													<effects>
														<shadow color='555555' distance='1' angle='90' blur='1' alpha='0.9'/>
													</effects>
												</text>
										</label>
			
		/**
		 */		
		public var w:uint = 200;
		
		/**
		 */		
		public var h:uint = 100;
	}
}