package com.fiCharts.charts.chart2D.encry
{
	import com.adobe.images.PNGEncoder;
	import com.fiCharts.charts.chart2D.core.Chart2DStyleSheet;
	import com.fiCharts.charts.chart2D.core.events.Chart2DEvent;
	import com.fiCharts.charts.common.IChart;
	import com.fiCharts.charts.common.language.LanguageConfig;
	import com.fiCharts.ui.text.Label;
	import com.fiCharts.utils.ExternalUtil;
	import com.fiCharts.utils.RexUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.layout.LayoutManager;
	import com.fiCharts.utils.net.URLService;
	import com.fiCharts.utils.net.URLServiceEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;

	/**
	 * 这是所有图表的主程序基类，负责初始化过程，包含对外接口；
	 */	
	public class ChartShellBase extends Sprite
	{
		/**
		 */		
		public static const MIN_SIZE:uint = 150;
		
		/**
		 */		
		public function ChartShellBase()
		{
			super();
		}
		
		/**
		 * 注入图表的配置文件， 此配置文件包含默认的样式模板, 菜单语言配置等；
		 */		
		protected function setDefaultConfig(value:String):void
		{
			var defaultConfig:XML = XML(value);
			
			for each (var item:XML in defaultConfig.styles.children())
				Chart2DStyleSheet.pushTheme(XML(item.toXMLString()));
			
			languageXML = XML(defaultConfig.menu.toXMLString());
		}
		
		
		
		
		//-------------------------------------------------
		//
		// 公共接口, 这些接口可以用在AS项目或者AIR移动项目中
		//
		//-------------------------------------------------
		
		/**
		 * 在被添加到显示列表之前就要设置用户配置文件， 
		 * 
		 * 只要一被添加进显示列表则开始初始化 Chart， 将用户配置文件作为参数传入；
		 */		
		public function setUserConfig(value:XML):void
		{
			embedCustomConfig = value;
		}
		
		/**
		 */		
		protected var embedCustomConfig:XML;
		
		/**
		 */		
		protected var customConfig:XML;
		
		/**
		 */		
		public function setConfigFile(value:String):void
		{
			requestConfigURL(value);
		}
		
		/**
		 */		
		public function setConfigXML(value:String):void
		{
			setConfigXMLHandler(value);
		}
		
		/**
		 */		
		public function render():void
		{
			this.renderHandler();
		}
		
		/**
		 */		
		public function setDataXML(value:String):void
		{
			getXMLDataHandler(value);
		}
		
		/**
		 */		
		public function setDataFile(value:String):void
		{
			requestDataURL(value);
		}
		
		/**
		 */		
		public function setStyle(value:String):void
		{
			setStyleHandler(value);
		}
		
		
		
		//---------------------------------------------------------
		//
		// 初始化
		//
		//---------------------------------------------------------
		
		/**
		 */
		protected function init():void
		{
			initLanguage();
			initMenu();
			initInterfaces();
			
			// 存在外部配置文件的话， 先加载外部配置文件， 加载成功后
			// 应用配置文件， 如果存在嵌入配置文件， 则外部配置文件需要继承
			// 嵌入的配置文件；嵌入配置文件优先级最高；
			if (RexUtil.ifTextNull(customStyleFileURL) == false)
				loadCustomStyle(customStyleFileURL);
			else
				lauchApp();
		}
		
		// ----------------------------------------
		//
		// 加载外部配置文件
		//
		//-----------------------------------------
		private function loadCustomStyle(url:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, loadCustomStyleFileComplete, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			urlLoader.load(new URLRequest(url));
		}
		
		/**
		 */		
		private function loadCustomStyleFileComplete(evt:Event):void
		{
			var externalConfigByte:ByteArray = (evt.target as URLLoader).data;
			externalConfigByte.uncompress();
			
			var externalCustomConfig:XML = XML(externalConfigByte.toString());
			
			// 
			// 预先配置文件有两种： 嵌入式和外部加载方式，且嵌入优先于外部加载方式；
			// 两者同时存在时， 外部加载的要继承预先嵌入的， 作为自定义样式附给图表
			//
			if (this.embedCustomConfig)
				this.customConfig = XMLVOMapper.extendFrom(embedCustomConfig, externalCustomConfig);
			else
				customConfig = externalCustomConfig;
			
			this.lauchApp();
		}
		
		/**
		 */		
		private function errorHandler(evt:Event):void
		{
			this.lauchApp();
		}
		
		
		//-----------------------------------------------
		//
		// 语言与邮件菜单
		//
		//-----------------------------------------------
		
		/**
		 * 初始化语言配置
		 */		
		private function initLanguage():void
		{
			XMLVOMapper.fuck(languageXML, languageConfig);
		}
		
		/**
		 */		
		private var languageConfig:LanguageConfig = new LanguageConfig;
		
		/**
		 * 语言配置
		 */		
		protected var languageXML:XML;
		
		/**
		 * 右键菜单；
		 */		
		private function initMenu():void
		{
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var item:ContextMenuItem;
			
			item = new ContextMenuItem(languageConfig.saveAsImage);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveImageHandler);
			myContextMenu.customItems.push(item);
			
			item = new ContextMenuItem(languageConfig.about + " FiCharts");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
			myContextMenu.customItems.push(item);
			
			item = new ContextMenuItem(languageConfig.version + " 1.2.0 Beta");
			item.enabled = false;
			myContextMenu.customItems.push(item);
			
			this.contextMenu = myContextMenu;
		}
		
		/**
		 */		
		private function saveImageHandler(evt:Event):void
		{
			var imageByteArray:ByteArray = PNGEncoder.encode(BitmapUtil.draw(this));
			var file:FileReference = new FileReference();
			file.save(imageByteArray, 'fichart.png');
		}
		
		/**
		 */		
		private function menuItemSelectHandler(evt:ContextMenuEvent):void
		{
			flash.net.navigateToURL(new URLRequest('http://www.ficharts.com'), '_blank');
		}
		
		//----------------------------------------------------
		//
		// 外部配置及数据接口处理
		//
		//-----------------------------------------------------
		protected function initInterfaces():void
		{
			ExternalUtil.addCallback("setConfigXML", setConfigXMLHandler);
			ExternalUtil.addCallback("setConfigFile", requestConfigURL);
			
			ExternalUtil.addCallback("setStyle", setStyleHandler);
			ExternalUtil.addCallback('setCustomStyle', setCustomStyleHandler);
			
			ExternalUtil.addCallback("setDataXML", getXMLDataHandler);
			ExternalUtil.addCallback("setDataFile", requestDataURL);
			
			ExternalUtil.addCallback("setCSVData", requestCSVData);
			ExternalUtil.addCallback("render", renderHandler);
			
			// Flash的初始化参数配置
			configFileURL = stage.loaderInfo.parameters['configFile'];
			style = stage.loaderInfo.parameters['style'];
			
			customStyleFileURL = stage.loaderInfo.parameters['customStyleFile'];
			
			id = stage.loaderInfo.parameters['id'];
			this.noDataInfo = stage.loaderInfo.parameters['noDataInfo'];
			this.loadingDataInfo = stage.loaderInfo.parameters['loadingDataInfo'];
			this.loadingDataErrorInfo = stage.loaderInfo.parameters['loadingDataErrorInfo'];
		}
		
		/**
		 */		
		private var configFileURL:String;
		private var style:String;
		private var customStyleFileURL:String;
		
		//------------------------------------
		//
		// 图表构建与启动
		//
		//------------------------------------
		/**
		 * 应用图表初始化配置项， 创建并 启动图表；
		 */		
		private function lauchApp():void
		{
			initChart();
			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			
			infoLabel = new Label();
			addChild(infoLabel);
			
			// 初始化完毕后提示无数据
			updateInfoLabel(noDataInfo);
			
			//
			// 如果有预先设置好的自定义配置， 将其设置为自定义样式；
			//
			if (this.customConfig)
				chart.setCustomStyle(customConfig);
			
			if (RexUtil.ifTextNull(style) == false)
				setStyleHandler(style);
			
			ExternalUtil.call("FiCharts.ready", id);
			
			//如果配置了配置文件的路径，则直接加载；
			if (RexUtil.ifTextNull(configFileURL) == false)
				requestConfigURL(configFileURL);
		}
		
		/**
		 */
		protected function resizeChart():void
		{
			chart.chartWidth = stage.stageWidth;
			chart.chartHeight = stage.stageHeight;
		}
		
		/**
		 * 初始化一些全局事件， 当图表被添加进显示列表以后才开始创建图表；
		 */		
		protected function initChart():void
		{
			// 子类需先创建图表
			addChild(chart as DisplayObject);
			(chart as EventDispatcher).addEventListener(Chart2DEvent.RENDERED, renderedHandler, false, 0, true);
			(chart as EventDispatcher).addEventListener(Chart2DEvent.ITEM_CLICKED, itemClickHandler, false, 0, true);
		}
		
		/**
		 */		
		private function itemClickHandler(evt:Chart2DEvent):void
		{
			evt.stopPropagation();
			ExternalUtil.call('FiCharts.itemClick', id, evt.dataItem.metaData);
		}
		
		/**
		 */		
		protected function renderedHandler(evt:Chart2DEvent):void
		{
			evt.stopPropagation();
			ExternalUtil.call('FiCharts.rendered', id);
		}
		
		/**
		 */		
		protected function renderHandler():void
		{
			this.infoLabel.visible = false;
			chart.render();
		}
		
		/**
		 */		
		protected function resizeHandler(evt:Event):void
		{
			if (stage.stageWidth <=  ChartShellBase.MIN_SIZE || stage.stageHeight <= ChartShellBase.MIN_SIZE)
				return;
			
			if (infoLabel.visible)
				LayoutManager.stageCenter(infoLabel, stage);
			
			resizeChart();
			chart.render();
		}
		
		/**
		 */		
		protected var chart:IChart;
		
		/**
		 */		
		private function updateInfoLabel(info:String):void
		{
			if(this.infoLabel.visible == false) infoLabel.visible = true;
				
			this.infoLabel.reLabel(info);
			LayoutManager.stageCenter(infoLabel, stage);
		}
		
		/**
		 * 信息提示标签;
		 */		
		private var infoLabel:Label;
		
		/**
		 */		
		private var noDataInfo:String;
		
		/**
		 */		
		private var loadingDataErrorInfo:String;
		
		/**
		 */		
		private var loadingDataInfo:String;
		
		/**
		 */		
		private var id:String;
		
		
		
		
		//----------------------------------------
		//
		// 配置接口
		//
		//----------------------------------------
		
		private function requestConfigURL(url:String, args:String = null):void
		{
			updateInfoLabel(loadingDataInfo);
			
			var urlService:URLService = new URLService();
			urlService.addEventListener(URLServiceEvent.GET_DATA, getConfigServiceHandler, false, 0, true);
			urlService.addEventListener(URLServiceEvent.LOADING_ERROR, loadingDataErrorHandler, false, 0, true);
			urlService.requestService(url, args);
		}
		
		/**
		 */		
		private function getConfigServiceHandler(evt:URLServiceEvent):void
		{
			setConfigXMLHandler(evt.data);
			renderHandler();
			ExternalUtil.call("FiCharts.configFileLoaded", id, evt.data);
		}
		
		/**
		 */
		private function setConfigXMLHandler(value:String):void
		{
			chart.configXML = XML(value);
		}
		
		/**
		 */		
		private function setStyleHandler(value:String):void
		{
			chart.setStyle(value);
		}
		
		private function setCustomStyleHandler(value:String):void
		{
			chart.setCustomStyle(XML(value));
		}
		
		
		
		//----------------------------------------
		//
		// 数据接口
		//
		//----------------------------------------
		
		/**
		 */
		private function requestDataURL(url:String, args:String = null):void
		{
			updateInfoLabel(loadingDataInfo);
			
			var urlService:URLService = new URLService();
			urlService.addEventListener(URLServiceEvent.GET_DATA, getDataServiceHandler, false, 0, true);
			urlService.addEventListener(URLServiceEvent.LOADING_ERROR, loadingDataErrorHandler, false, 0, true);
			urlService.requestService(url, args);
		}
		
		/**
		 * @param evt
		 */
		private function getDataServiceHandler(evt:URLServiceEvent):void
		{
			getXMLDataHandler(evt.data);
			renderHandler();
			ExternalUtil.call("FiCharts.dataFileLoaded", id, evt.data);
		}
		
		/**
		 * 获取到了数据文件
		 */
		private function getXMLDataHandler(value:String):void
		{
			chart.dataXML = XML(value);
		}
		
		/**
		 */		
		private function requestCSVData(value:String):void
		{
			
		}
		
		/**
		 */		
		private function loadingDataErrorHandler(evt:URLServiceEvent):void
		{
			updateInfoLabel(loadingDataErrorInfo + ": " + evt.data);
		}
		
	}
}