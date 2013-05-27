package com.biaomei.edit
{
	import com.biaomei.edit.chart.ChartProxy;
	import com.biaomei.edit.chart.SeriesHeaderEvt;
	import com.biaomei.edit.chart.SeriesProxy;
	import com.biaomei.edit.chart.header.SeriesHeader;
	import com.biaomei.edit.chartTypeBox.ChartTypePanel;
	import com.dataGrid.DataGrid;
	import com.dataGrid.DataGridEvent;
	import com.fiCharts.utils.StageUtil;
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.dec.NullPad;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.fiCharts.utils.interactive.TipCanvasControl;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextFormat;
	
	import ui.LabelBtn;
	import ui.LabelInput;
	import ui.dragDrop.DragDropper;
	import ui.dragDrop.IDragDropReiver;
	
	/**
	 * 图表数据和配置编辑页
	 * 
	 * 应默认就有一个序列，虽然数据为空；
	 * 
	 * 模板数据替换已有数据时应该给用户提供选择，替换还是保留已有数据
	 */	
	public class EditPage extends PageBase implements IDragDropReiver
	{
		public function EditPage(main:BiaoMei)
		{
			super();
			
			this.main = main;
			StageUtil.initApplication(this, init)
				
			this.h = 680;
		}
		
		
		/**
		 */
		private function clearGridDataHandler(evt:MouseEvent):void
		{
			dataGrid.clear();
		}
		
		/**
		 */		
		private function resetAllHandler(evt:MouseEvent):void
		{
			resetAll();
		}
		
		/**
		 * 重设表格数据、标题、序列
		 */		
		private function resetAll():void
		{
			this.chartProxy.reset();
			resetTitles();
			dataGrid.clear();
		}
		
		/**
		 */		
		private function stateDownForHeader(evt:MouseEvent):void
		{
			if (!chartProxy.hitTestPoint(stage.mouseX,stage.mouseY))
			{
				if (currentHeader)
				{
					currentHeader.close();
					currentHeader = null;					
				}
			}
		}
		
		/**
		 */		
		private function headerSelectedHandler(evt:SeriesHeaderEvt):void
		{
			if (currentHeader)
				currentHeader.close();
			
			currentHeader = evt.header;
			currentHeader.open();
		}
		
		/**
		 */		
		private var currentHeader:SeriesHeader;
		
		/**
		 */		
		private function updateDataGridSizeHandler(evt:DataGridEvent):void
		{
			evt.stopPropagation();
			
			dataGrid.fillColumnBG(0);
			this.h = this.dataGrid.gridH + 200;
			this.layoutVTitleY();
			this.layoutHTitileY();
			renderBG();
			
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		private function layoutHTitileY():void
		{
			var py:Number = this.h / 2 + (this.dataGrid.height + this.dataGrid.y) / 2 - hTitleLabel.h / 2;
			
			TweenLite.to(hTitleLabel, 0.3, {y : py});
		}
		
		/**
		 */		
		private function layoutVTitleY():void
		{
			var py:Number = h / 2 + vTitleLabel.w / 2;
			
			TweenLite.to(vTitleLabel, 0.3, {y : py});
		}
		
		/**
		 */		
		private function vTitleSelected(evt:Event):void
		{
			TweenLite.to(vTitleLabel, 0.3, {rotation: 0, onComplete: finishSelectedVtitle});
		}
		
		/**
		 */		
		private function finishSelectedVtitle():void
		{
			vTitleLabel.activit();
		}
		
		/**
		 */		
		private function vTitleUnSelected(evt:Event):void
		{
			vTitleLabel.toImgMode();
			TweenLite.to(vTitleLabel, 0.3, {rotation: - 90});
		}
		
		/**
		 */		
		private function resizeTitle(evt:Event):void
		{
			var px:Number = (this.w - titleLabel.w) / 2;
				
			TweenLite.to(titleLabel, 0.3, {x : px});
		}
		
		/**
		 */		
		private function resizeVTitle(evt:Event):void
		{
			layoutVTitleY();
		}
		
		/**
		 */		
		private function resizeHTitle(evt:Event):void
		{
			var px:Number =  (this.w - hTitleLabel.w) / 2;
				
			TweenLite.to(hTitleLabel, 0.3, {x : px});
		}
		
		/**
		 */		
		private function titleChanged(evt:Event):void
		{
			this.chartProxy.title = titleLabel.text;
		}
		
		/**
		 */		
		private function hTitleChanged(evt:Event):void
		{
			this.chartProxy.hTitle = hTitleLabel.text;
		}
		
		/**
		 */		
		private function vTitleChanged(evt:Event):void
		{
			chartProxy.vTitle = vTitleLabel.text;
		}
		
		/**
		 */		
		private var titleLabel:LabelInput = new LabelInput;
		
		/**
		 */		
		private var hTitleLabel:LabelInput = new LabelInput;
		
		/**
		 */		
		private var vTitleLabel:LabelInput = new LabelInput;
		
		/**
		 */		
		private var dis:uint = 3;
		
		/**
		 * 主程序
		 */		
		private var main:BiaoMei;
		
		/**
		 */		
		public function loadChartTemplate(config:XML):void
		{
			configXML = config.copy();
			
			if (configXML.children().length() == 0)
			{
				// 空模板，重设
				resetAll();
			}
			else if (this.dataGrid.ifHasData)//已存在数据和序列定义，仅更新序列及图表配置
			{
				dataControl.importChartConfigTemplate();
			}
			else// 没有数据时， 根据模板数据全新创建图表
			{
				dataGrid.clear();// 要先清空
				dataControl.importChartConfigTemplate();
				dataControl.importChartDataTemplate();
			}
		}
		
		/**
		 */		
		internal function resetTitles():void
		{
			titleLabel.reset();
			hTitleLabel.reset();
			vTitleLabel.reset();
		}
		
		/**
		 */		
		internal function upateTitlesData():void
		{
			titleLabel.text = chartProxy.title;
			hTitleLabel.text = chartProxy.hTitle;
			vTitleLabel.text = chartProxy.vTitle;
		}
		
		/**
		 * 表格数据，默认来自图表模板中，如表格中的数据已被修改则
		 * 
		 * 再次创建图表时沿用已有的数据，只更新图表配置部分；
		 * 
		 * 除非遇到特殊的图表类型，如气泡图则采用模板数据
		 */		
		public var data:Array = [];
		
		/**
		 * 动态获取图表的配置文件
		 */		
		public function getChartConfigXMLForRender():XML
		{
			if (ifDataChanged)
				currentConfig = this.chartProxy.getConfigXMLForRender();;
				
			return currentConfig;
		}
		
		/**
		 */		
		public function get ifDataChanged():Boolean
		{
			if (this.dataGrid.ifDataChanged || this.chartProxy.seriesChanged)
				return true;
			else
				return false;
		}
		
		/**
		 */		
		public function chartRenderd():void
		{
			this.dataGrid.ifDataChanged = this.chartProxy.seriesChanged = false;
		}
		
		/**
		 */		
		private var currentConfig:XML;
		
		/**
		 */		
		private var currentData:Array;
		
		/**
		 * 动态获取图表的数据
		 */		
		public function getChartDataForRender():Array
		{
			var result:Array = [];
			
			if (ifDataChanged)
				currentData = chartProxy.getDataForRender();
			
			return currentData;
		}
		
		/**
		 */		
		internal var configXML:XML = null;
			
		/**
		 * 图表的代理器，负责图表配置，坐标轴配置模型
		 */			
		internal var chartProxy:ChartProxy = new ChartProxy;
		
		/**
		 */		
		internal var dataGrid:DataGrid = new DataGrid;
		
		/**
		 * 表格宽度
		 */		
		private var _gridW:Number = 0;
		
		/**
		 * 表格高度
		 */		
		private var _girdH:Number = 0;
		
		/**
		 */
		public function get girdH():Number
		{
			return _girdH; 
		}
		
		/**
		 * @private
		 */
		public function set girdH(value:Number):void
		{
			_girdH = value;
		}
		
		/**
		 */
		public function get gridW():Number
		{
			return _gridW;
		}
		
		/**
		 * @private
		 */
		public function set gridW(value:Number):void
		{
			_gridW = value;
		}
		
		
		
		
		
		//--------------------------------------------------
		//
		//
		// 拖放控制
		//
		//--------------------------------------------------
		
		/**
		 * 
		 *  1.先找到序列对应的字段列范围
		 * 
		 *  2.判断是否可以再次新建序列或者替换已有序列
		 * 
		 *  3.如果都不行则啥都不干
		 * 
		 */		
		public function dragDropping(drawFun:Function):void
		{
			ifCanAddSeries = ifCanExchangeSeries = false;
			
			var interactRec:Rectangle = new Rectangle;
			var columnLen:uint = this.dataGrid.columns.length;
			
			var leftX:Number = 0;
			var rightX:Number = 0;
			var step:uint;
			
			step = this.chartProxy.getColumnLenByChartType(draggingSeriesType);
			
			for (var i:uint = 1; i < columnLen; i += 1)
			{
				if (i + step >= columnLen)
					rightX = dataGrid.gridW;
				else
					rightX = dataGrid.columns[i + step].x;
				
				leftX = dataGrid.columns[i].x;
				
				interactRec.x = leftX;
				interactRec.y = 0;
				interactRec.width = rightX - leftX;
				interactRec.height = dataGrid.gridH;
				
				if (dataGrid.mouseX > leftX && dataGrid.mouseX < rightX)
				{
					dropStartColumnIndex = i;
					dropEndColumnIndex = i + step - 1;
					
					// 是否有空间来放下新序列
					if (this.ifHaveSpace(dropStartColumnIndex, dropEndColumnIndex))
					{
						if (this.chartProxy.ifCanAddSeries(draggingSeriesType))
						{
							ifCanAddSeries = true;
							drawFun(interactRec, rightColor, true);
						}
						else
						{
							drawFun(interactRec, wrongColor, false);
							ifCanAddSeries = false;
						}
					}
					else // 碰撞了已有序列
					{
						if (chartProxy.ifCanChangeSeries(draggingSeriesType, dropStartColumnIndex, dropEndColumnIndex))
						{
							ifCanExchangeSeries = true;	
							drawFun(interactRec, rightColor, true);
						}
						else
						{
							ifCanExchangeSeries = false;
							drawFun(interactRec, wrongColor, false);
						}
					}
					
					//找到了基于当前序列的投掷字段列
					break;
				}
				
			}
		}
		
		/**
		 */		
		private var rightColor:uint = 0x4EA6EA//0x728F1C;
		
		/**
		 */		
		private var wrongColor:uint = 0xFDB52F;
		
		/**
		 * 是否可以改变序列类型 
		 */		
		private var ifCanExchangeSeries:Boolean = false;
		
		/**
		 * 拖放完成时，是否可以拖放； 
		 */		
		private var ifCanAddSeries:Boolean = false;
		
		/**
		 * 判断是否有空余表格放得下序列
		 */		
		private function ifHaveSpace(start:uint, end:uint):Boolean
		{
			var result:Boolean = true;
			
			for each (var series:SeriesProxy in this.chartProxy.series)
			{
				if ((start >= series.startColumnIndex && start <= series.endColumnIndex) || 
					(end >= series.startColumnIndex && end <= series.endColumnIndex))
				{
					result = false;
					
					break;
				}
			}
			
			return result;
		}
		
		/**
		 */		
		public function startDragDrop(parm:Object):void
		{
			draggingSeriesType = parm.toString();
		}
		
		/**
	     *  正在进行拖放的序列类型
		 */		
		private var draggingSeriesType:String;
			
		/**
		 * 这里创建序列，创建序列时，先拟定字段和坐标轴数据类型
		 * 
		 * 创建图图表时在动态生成地段名、智能分析出数据类型和前缀与后缀
		 */			
		public function stopDragDrop():void
		{
			var newSeries:SeriesProxy;
			
			if(ifCanAddSeries)// 添加序列
			{
				newSeries = this.chartProxy.getSeriesByType(draggingSeriesType);
				setSeriesColumns(newSeries, dropStartColumnIndex, dropEndColumnIndex);
				newSeries.setField();
				chartProxy.addSeries(newSeries);
				newSeries.verifyFieldData(this.dataGrid.verifyColumnData);
			}
			else if (ifCanExchangeSeries)// 改变序列类型, 先删除，在创建
			{
				var oldSeries:SeriesProxy;
				oldSeries = chartProxy.getSeriesByIndexRange(dropStartColumnIndex, dropEndColumnIndex);
				oldSeries.del();
				
				newSeries = this.chartProxy.getSeriesByType(draggingSeriesType);
				setSeriesColumns(newSeries, dropStartColumnIndex, dropEndColumnIndex);
				newSeries.setField();
				chartProxy.addSeries(newSeries);
				
				newSeries.reName(oldSeries.name);
				
				newSeries.verifyFieldData(this.dataGrid.verifyColumnData);
			}
			else// 此时无法加入序列
			{
				newSeries = chartProxy.getSeriesByIndexRange(dropStartColumnIndex, dropEndColumnIndex);
				
				if (newSeries)
					newSeries.shake();
			}
		}
		
		/**
		 * 设置序列的列序号及所包含的表格列
		 */		
		internal function setSeriesColumns(series:SeriesProxy, startFieldIndex:uint, endFieldIndex:uint):void
		{
			series.columns.push(this.dataGrid.columns[0]);
			series.columns = series.columns.concat(this.dataGrid.columns.slice(startFieldIndex, endFieldIndex + 1));
			
			series.startColumnIndex = startFieldIndex;
			series.endColumnIndex = endFieldIndex;
		}
		
		/**
		 */		
		public function into():void
		{
			
		}
		
		/**
		 */		
		public function out():void
		{
		}
		

		
		
		
		
		//------------------------------------------------------------
		//
		// 初始化
		//
		//------------------------------------------------------------
		
		/**
		 */		
		private function init():void
		{
			dataControl = new DataControl(this);
			
			dataGrid.addEventListener(DataGridEvent.UPDATA_SEIZE, updateDataGridSizeHandler, false, 0, true);
			dataGrid.gridW = 810;
			dataGrid.gridH = this.h - 180 - gutterTop// 上下空白;
			
			dataGrid.x = (this.w - dataGrid.gridW) * 0.5;
			dataGrid.y = gutterTop + (this.h - gutterTop - dataGrid.gridH) * 0.5;
			addChild(dataGrid);
			
			dataGrid.preRender();
			dataGrid.fillColumnBG(0);
			dataGrid.setColumnTextFormat(0, new TextFormat("微软雅黑", 12, 0, false, true));
			
			// 背景
			renderBG();
			
			chartProxy.x = dataGrid.x;
			chartProxy.y = dataGrid.y;
			addChild(chartProxy);
			
			initTitles();
			initEditPanel();
			
			this.addChild(chartTypePanel);
			chartTypePanel.render();
			chartTypePanel.x = this.dataGrid.x + dataGrid.gridW - chartTypePanel.w;
			chartTypePanel.y = dataGrid.y;
			
			var rect:Rectangle = this.getBounds(this);
			chartTypePanel.setDragRect(rect);
			
			//拖放控制器
			dragDropper = new DragDropper(stage);
			dragDropper.addSender(chartTypePanel);
			dragDropper.addReceiver(this, dataGrid, 90);
			
			chartProxy.addEventListener(SeriesHeaderEvt.HEADER_SELECT, headerSelectedHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stateDownForHeader, false, 0, true);
		}
		
		/**
		 */		
		private function initEditPanel():void
		{
			addChild(editPanel);
			
			XMLVOMapper.fuck(editPanleStyleXML, editPanelStyle);
			
			editPanel.graphics.clear();
			editPanelStyle.width = this.w;
			editPanelStyle.height = gutterTop;
			StyleManager.drawRect(editPanel, editPanelStyle);
			
			importBtn.w = 80;
			importBtn.h = 26;
			importBtn.x = 20;
			importBtn.y = (gutterTop - importBtn.h) / 2;
			importBtn.text = "导入文件";
			importBtn.tips = "导入包含数据和图表配置的文件"
			importBtn.labelStyleXML = btnLabelStyle;
			importBtn.bgStyleXML = btnStyle;
			importBtn.render();
			importBtn.addEventListener(MouseEvent.CLICK, dataControl.browseFileHandler, false, 0, true);
			editPanel.addChild(importBtn);
			
			clearGridDataBtn.w = resetBtn.w = 80;
			clearGridDataBtn.h = resetBtn.h = 26;
			
			resetBtn.x = importBtn.x + importBtn.w + 10;
			
			clearGridDataBtn.x = resetBtn.x + resetBtn.w  + 10;
			clearGridDataBtn.y = resetBtn.y = (gutterTop - clearGridDataBtn.h) / 2;
			
			clearGridDataBtn.text = "清空表格";
			clearGridDataBtn.tips = "删除表格中的数据";
			
			resetBtn.text = "重设所有";
			resetBtn.tips = "清空表格数据和图表配置";
			
			clearGridDataBtn.labelStyleXML = resetBtn.labelStyleXML = btnLabelStyle;
			clearGridDataBtn.bgStyleXML = resetBtn.bgStyleXML = btnStyle;
			
			clearGridDataBtn.render();
			resetBtn.render();
			clearGridDataBtn.addEventListener(MouseEvent.CLICK, clearGridDataHandler, false, 0, true);
			resetBtn.addEventListener(MouseEvent.CLICK, resetAllHandler, false, 0, true);
			editPanel.addChild(clearGridDataBtn);
			editPanel.addChild(resetBtn);
		}
		
		/**
		 */		
		private var importBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var resetBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var clearGridDataBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var gutterTop:uint = 50;
		
		/**
		 */		
		private var editPanel:Sprite = new Sprite;
		
		
		/**
		 */		
		private var editPanelStyle:Style = new Style;
		
		/**
		 */		
		private var editPanleStyleXML:XML = <style>
												<border color="EEEEEE"/>
												<fill color="#EFEFEF, #EFEFEF" alpha="0.3,0.3" angle="-90"/>
											</style>
		
		/**
		 */		
		override public function renderBG():void
		{
			super.renderBG();
			this.graphics.beginFill(0xEEEEEE);
			this.graphics.drawRoundRect(dataGrid.x - dis, dataGrid.y - dis, 
				dataGrid.gridW + 2 * dis, dataGrid.gridH + 2 * dis, 5, 5);
		}
		
		/**
		 */		
		private function initTitles():void
		{
			titleLabel.defaultTxt = "请输入主标题";
			titleLabel.w = 30;
			titleLabel.render();
			titleLabel.x = (this.w - titleLabel.w) / 2;
			titleLabel.y = gutterTop + 15;
			titleLabel.addEventListener(Event.CHANGE, titleChanged, false, 0, true);
			titleLabel.addEventListener(Event.RESIZE, resizeTitle, false, 0, true);
			this.addChild(titleLabel);
			
			hTitleLabel.defaultTxt = '请输入横轴标题';
			hTitleLabel.setTextFormat(14);
			hTitleLabel.w = 30;
			hTitleLabel.render();
			hTitleLabel.x = (this.w - hTitleLabel.w) / 2;
			layoutHTitileY();
			hTitleLabel.addEventListener(Event.CHANGE, hTitleChanged, false, 0, true);
			hTitleLabel.addEventListener(Event.RESIZE, resizeHTitle, false, 0, true);
			this.addChild(hTitleLabel);
			
			vTitleLabel.defaultTxt = '请输入纵轴标题';
			vTitleLabel.setTextFormat(14);
			vTitleLabel.w = 30;
			vTitleLabel.render();
			vTitleLabel.toImgMode();
			vTitleLabel.setRotation(- 90);
			vTitleLabel.x = (this.dataGrid.x - vTitleLabel.h) / 2;
			layoutVTitleY();
			vTitleLabel.addEventListener(Event.CHANGE, vTitleChanged, false, 0, true);
			vTitleLabel.addEventListener(Event.RESIZE, resizeVTitle, false, 0, true);
			
			vTitleLabel.addEventListener(Event.SELECT, vTitleSelected, false, 0, true);
			vTitleLabel.addEventListener(Event.MOUSE_LEAVE, vTitleUnSelected, false, 0, true);
			
			this.addChild(vTitleLabel);
		}
		
		/**
		 */		
		private var btnStyle:XML = <states>
										<normal radius="3">
											<border color="#DDDDDD" pixelHinting="true"/>
											<fill color='#EEEEEE' alpha='1'/>
										</normal>
										<hover radius="3">
											<border color="#CCCCCC" pixelHinting="true"/>
											<fill color='#DDDDDD' alpha='1'/>
										</hover>
										<down radius="3">
											<border color="#BBBBBB" pixelHinting="true"/>
											<fill color='#CCCCCC' alpha='1'/>
										</down>
									</states>;
		
		/**
		 */		
		private var btnLabelStyle:XML = <label>
											<format color='666666' font='微软雅黑' size='12' letterSpacing="2"/>
											<text>
												<effects>
													<shadow color='FFFFFF' distance='1' angle='90' blur='1' alpha='0.9'/>
												</effects>
											</text>
										</label>
			
		
		
		
		
		
		//------------------------------------------------------------
		//
		//
		// 导入导出数据， 图表数据与表格数据时分开的
		// 
		//
		//--------------------------------------------------------------
		
		/**
		 * 
		 */		
		public function importData():void
		{
			
		}
		
		/**
		 * 导出包含图表配置和数据的文件
		 */		
		public function exportData():void
		{
			return dataControl.exportData(); 
		}
		
		/**
		 * 对于大多数图表类型，dropStartColumnIndex 与  dropEndColumnIndex
		 * 
		 * 值是相等的，为字段列序号， 气泡及堆积图才会有区别
		 */		
		private var dropStartColumnIndex:uint = 0;
		
		/**
		 */		
		private var dropEndColumnIndex:uint = 0;
		
		/**
		 * 图类型面板，从这里创建序列和修改序列类型
		 */		
		private var chartTypePanel:ChartTypePanel = new ChartTypePanel;
		
		/**
		 */		
		private var dragDropper:DragDropper;
		
		/**
		 */		
		private var dataControl:DataControl;
		
	}
}