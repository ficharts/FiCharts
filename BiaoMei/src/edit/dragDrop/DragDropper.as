package edit.dragDrop
{
	import com.fiCharts.utils.XMLConfigKit.XMLVOMapper;
	import com.fiCharts.utils.XMLConfigKit.style.Style;
	import com.fiCharts.utils.graphic.BitmapUtil;
	import com.fiCharts.utils.graphic.StyleManager;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import navBar.INav;

	/**
	 * 一个拖放控制器，包含一个发送者和接受者
	 * 
	 * 发送者负责拖放的发起与关闭，并将此消息传递至接受者，同时传递了一个拖放对象
	 * 
	 * 当拖放对象进入接受者中时，接受者会感应到并开始实时预处理拖放结果
	 * 
	 * 拖放结束后，成功则正式处理拖放结果，否则清空拖放对象
	 */	
	public class DragDropper 
	{
		public function DragDropper(root:Stage)
		{
			this.root = root;
			
			addIcon.visible = false;
			var iconData:BitmapData = new add;
			BitmapUtil.drawBitmapDataToUI(iconData, addIcon, iconData.width, iconData.height);
			
			addIcon.mouseEnabled = draggingUI.mouseEnabled = false;
			draggingUI.cacheAsBitmap = true;
			draggingUI.alpha = 0.8;
			XMLVOMapper.fuck(this.interactStyleXML, this.interactStyle);
		}
		
		/**
		 */		
		private var root:Stage;
		
		/**
		 */		
		private function goIntoReceiver(evt:MouseEvent):void
		{
			ifInReceiver = true;
			receiver.into();
			
			interactUI.graphics.clear();
		}
		
		/**
		 */		
		private function toOutReceiver(evt:MouseEvent):void
		{
			ifInReceiver = false;
			receiver.out();
			
			interactUI.graphics.clear();
		}
		
		/**
		 * 是否鼠标位于接受区域内，如果在，拖拽成功；
		 * 
		 * 如果不在拖拽失败； 
		 */		
		private var ifInReceiver:Boolean = false;
		
		/**
		 */		
		public function addReceiver(receiver:IDragDropReiver, receiveUI:Sprite):void
		{
			this.receiver = receiver;
			this.receiveUI = receiveUI;
			
			receiveUI.addChild(receiveFrameUI);
		}
		
		/**
		 */		
		public function addSender(sender:IDragDrapSender):void
		{
			this.sender = sender;
			this.sender.addEventListener(DragDropEvent.WILL_START_DRAG, startDragDrop);
			sender.addEventListener(MouseEvent.ROLL_OVER, overSender, false, 0, true);
			sender.addEventListener(MouseEvent.ROLL_OUT, outSender, false, 0, true);
		}
		
		/**
		 */		
		private function overSender(evt:MouseEvent):void
		{
			addIcon.visible = false;
		}
		
		/**
		 */		
		private function outSender(evt:MouseEvent):void
		{
			
		}
		
		/**
		 * 开始拖放过程
		 */		
		private function startDragDrop(evt:DragDropEvent):void
		{
			//sender.disEnable(); 
			
			//拖动图标
			var data:BitmapData = BitmapUtil.getBitmapData(evt.dragedUI, false);
			draggingUI.graphics.clear();
			BitmapUtil.drawBitmapDataToUI(data, draggingUI, data.width, data.height);
			
			startDartPos = evt.dragedUI.parent.localToGlobal(new Point(evt.dragedUI.x, evt.dragedUI.y))
			
			//添加偏移量让用户感觉可以拖动
			draggingUI.x = startDartPos.x + 5;
			draggingUI.y = startDartPos.y + 5;
			
			root.addChild(draggingUI);
			root.addChild(addIcon);
			
			startDragStagePos.x = root.mouseX;
			startDragStagePos.y = root.mouseY;
			
			receiveUI.addEventListener(MouseEvent.ROLL_OVER, goIntoReceiver, false, 0, true);
			receiveUI.addEventListener(MouseEvent.ROLL_OUT, toOutReceiver, false, 0, true);
			
			root.addEventListener(MouseEvent.MOUSE_MOVE, draggingHandler, false, 0, true);
			root.addEventListener(MouseEvent.MOUSE_UP, endDragDrop);
			
			receiver.startDragDrop(evt.dragParm);
			drawStartStateUI();
			
			interactUI.graphics.clear();
			receiveUI.addChild(interactUI);
		}
		
		/**
		 */		
		private function drawStartStateUI():void
		{
			receiveFrameUI.graphics.clear();
			receiveFrameUI.graphics.lineStyle(2, 0x4EA6EA, 0.6); 
			receiveFrameUI.graphics.drawRoundRect(- frameOffset, - frameOffset, 
				receiveUI.width + frameOffset * 2, receiveUI.height + frameOffset * 2, 0, 0);
		}
		
		/**
		 */		
		private var frameOffset:uint = 0;
		
		/**
		 */		
		private var startDartPos:Point;
		
		/**
		 */		
		private var startDragStagePos:Point = new Point;
		
		/**
		 * 拖动进行中,处理拖放图标的移动
		 */		
		private function draggingHandler(evt:MouseEvent):void
		{
			draggingUI.x = startDartPos.x + evt.stageX - startDragStagePos.x;
			draggingUI.y = startDartPos.y + evt.stageY - startDragStagePos.y;
			
			addIcon.x = draggingUI.x - addIcon.width / 2;
			addIcon.y = draggingUI.y - addIcon.height / 2;
			
			evt.updateAfterEvent();
			
			if (ifInReceiver)
				receiver.dragDropping(dragInteractUI);
		}
		
		/**
		 */		
		private function dragInteractUI(rec:Rectangle, color:uint = 0x4EA6EA, ifAdd:Boolean = false):void
		{
			this.color = color;
			
			interactUI.graphics.clear();
			StyleManager.setShapeStyle(interactStyle, interactUI.graphics, this);
			
			rec.x += interactUIOffset;
			rec.y += interactUIOffset;
			rec.width -= 2 * interactUIOffset;
			rec.height -= 2 * interactUIOffset; 
			
			interactStyle.tx = rec.x;
			interactStyle.ty = rec.y;
			interactStyle.width = rec.width;
			interactStyle.height = rec.height;
			interactUI.graphics.drawRoundRect(rec.x, rec.y, rec.width, rec.height, 
				interactStyle.radius, interactStyle.radius);
			
			StyleManager.drawRectCover(interactUI.graphics, interactStyle.getCover, this);
			
			if (ifAdd)
				addIcon.visible = true;
			else
				addIcon.visible = false;
		}
		
		/**
		 */		
		private var interactUIOffset:uint = 2;
		
		/**
		 */		
		public var color:uint;
		
		/**
		 */		
		private var interactStyle:Style = new Style;
		
		/**
		 */		
		private var interactStyleXML:XML = <style radius='0'>
												<border color='${color}' alpha='0.5'/>
												<fill type='linear' angle='90' color='${color}{adjustColor:1.3},${color}{adjustColor:1.1}' alpha='0.5,0.5'/>
												<cover>
													<border pixelHinting='true' color='${color}{adjustColor:1.6},${color}{adjustColor:1.1}' radioes='0, 150' angle='90' alpha='1,0' thikness='0.1'/>
													<fill type='linear' angle='90' color='${color}{adjustColor:1.6},${color}{adjustColor:1.1}' alpha='0.3,0' radioes='0, 150'/>	
												</cover>
											</style>
		
		/**
		 * 结束拖放过程
		 */		
		private function endDragDrop(evt:MouseEvent):void
		{
			//sender.enable();
			
			if (ifInReceiver)
			{
				receiver.stopDragDrop();
				ifInReceiver = false;		
				
				TweenLite.to(draggingUI, 0.3, {alpha: 0, onComplete: removeDraggingUI});
				addIcon.visible = false;
			}
			else
			{
				removeDraggingUI();
			}
			
			receiveUI.removeEventListener(MouseEvent.ROLL_OVER, goIntoReceiver);
			receiveUI.removeEventListener(MouseEvent.ROLL_OUT, toOutReceiver);
			
			root.removeEventListener(MouseEvent.MOUSE_MOVE, draggingHandler);
			root.removeEventListener(MouseEvent.MOUSE_UP, endDragDrop);
			
			receiveFrameUI.graphics.clear();
			interactUI.graphics.clear();
			receiveUI.removeChild(interactUI);
		}
		
		/**
		 */		
		private function removeDraggingUI():void
		{
			if (root.contains(draggingUI))
				root.removeChild(draggingUI);
			
			if (root.contains(addIcon))
				root.removeChild(addIcon);
			
			draggingUI.alpha = 0.8;
		}
		
		/**
		 * 正在被拖放元件的替身
		 */		
		private var draggingUI:Sprite = new Sprite;
		
		/**
		 */		
		private var addIcon:Sprite = new Sprite;
		
		/**
		 */		
		private var sender:IDragDrapSender;
		
		/**
		 */		
		private var receiver:IDragDropReiver;
		
		/**
		 * 拖放释放区域
		 */		
		private var receiveUI:Sprite;
		
		/**
		 * 用于拖放开启/关闭的视觉反馈UI
		 */		
		private var receiveFrameUI:Shape = new Shape;
		
		/**
		 * 用于拖放目标感应区块的视觉反馈UI
		 */		
		private var interactUI:Shape = new Shape;
		
		
	}
}