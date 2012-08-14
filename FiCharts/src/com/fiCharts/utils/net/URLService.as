package com.fiCharts.utils.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	[Event(name="getData", type="com.fiCharts.utils.net.URLServiceEvent")]
	
	/**
	 */	
	public class URLService extends EventDispatcher
	{
		public function URLService(target:IEventDispatcher=null)
		{
			super(target);
			init()
		}
		
		/**
		 */		
		private var urlLoader:URLLoader;
		
		/**
		 */		
		private function init():void
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler, false, 0, false );
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, false );
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler, false, 0, false );
		}
		
		/**
		 * @param url
		 * @param args
		 */		
		public function requestService(url:String, args:String = null):void
		{
			var request:URLRequest = new URLRequest();
			var variables:URLVariables = new URLVariables();
			
			if (args)
			{
				var veriableArray : Array = args.split( '|' );
				for each ( var item : String in veriableArray )
				{
					var pair : Array = item.split( '=' );
					variables[ pair[ 0 ] ] = pair[ 1 ];
				}
				
				request.data = variables;
			}
			
			this.url = request.url = url;
			
			variables.random = Math.random() * 1000;
			request.data = variables;
			
			urlLoader.load( request );
		}
		
		/**
		 */		
		private var url:String;
		
		/**
		 * @param evt
		 */		
		private function completeHandler(evt:Event):void
		{
			this.dispatchEvent(new URLServiceEvent(URLServiceEvent.GET_DATA, (evt.target as URLLoader).data));
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			this.dispatchEvent(new URLServiceEvent(URLServiceEvent.LOADING_ERROR, this.url));
		}
		
		private function securityHandler(evt:SecurityErrorEvent):void
		{
			this.dispatchEvent(new URLServiceEvent(URLServiceEvent.LOADING_ERROR, this.url));
		}
	}
}