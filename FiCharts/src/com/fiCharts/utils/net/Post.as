package com.fiCharts.utils.net
{
	import com.fiCharts.utils.system.FiTrace;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	/**
	 */
	public class Post
	{
		private var data:Object;
		
		private var req:URLRequest;
		
		private static var _boundary:String = "";
		
		protected static const HTTP_SEPARATOR:String="\r\n";
		
		/**
		 */	
		public function Post(url:String, data:Object)
		{
			req = new URLRequest(url);
			req.method = URLRequestMethod.POST;
			this.data = data;
			
			this.setHeader(new URLRequestHeader("Cache-Control", "no-cache"));
			this.setHeader(new URLRequestHeader("Content-Type", "multipart/form-data; boundary=" + Post.getBoundary()));
		}
		
		/**
		 */	
		private function setHeader(header:URLRequestHeader):void
		{
			this.req.requestHeaders.push(header);
		}
		
		/**
		 */	
		public function sendfile():void
		{
			uploader.addEventListener(Event.COMPLETE, complete);
			uploader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			uploader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securyityHandler);
			uploader.dataFormat = URLLoaderDataFormat.BINARY;
			
			req.data = getMultipart();
			uploader.load(req);
		}
		
		/**
		 */		
		private function securyityHandler(e:SecurityErrorEvent):void
		{
			FiTrace.info("error-" + e.type + e.text + e.target.data);
		}
		
		/**
		 */		
		private var uploader:URLLoader = new URLLoader;;
		
		/**
		 */	
		private function errorHandler(e:IOErrorEvent):void
		{
			FiTrace.info("error-" + e.type + e.text + e.target.data);
		}
		
		/**
		 */	
		private function getMultipart():ByteArray
		{
			var body:ByteArray = new ByteArray;
			var key:String;
			
			for (key in this.data)
			{
				if (this.data[key] is ByteArray)
				{
					body.writeUTFBytes("--" + Post.getBoundary());
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeUTFBytes("Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" + "ficharts.jpg" + "\"");
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeUTFBytes("Content-Type: image/png");
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeBytes(this.data[key], 0, this.data[key].length);
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					
				}
				else if (this.data[key] is String)
				{
					body.writeUTFBytes("--" + Post.getBoundary());
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeUTFBytes("Content-Disposition: form-data; name=\"" + key + "\"");
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
					body.writeUTFBytes(this.data[key]);
					body.writeUTFBytes(Post.HTTP_SEPARATOR);
				}
			}
			
			body.writeUTFBytes("--" + Post.getBoundary() + "--");
			body.writeUTFBytes(Post.HTTP_SEPARATOR);
			
			return body;
		}
		
		/**
		 */	
		private function complete(e:Event):void
		{
			FiTrace.info("sendComplete");
		}
		
		/**
		 */	
		private static function getBoundary():String
		{
			var int32:int;
			if (_boundary.length == 0) {
				int32 = 0;
				while (int32 < 32) {
					_boundary = _boundary + String.fromCharCode(int(97 + Math.random() * 25));
					int32++;
				}
				
				_boundary = _boundary;
			}
			
			return _boundary;
		}
	}
}