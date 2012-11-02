package com.fiCharts.utils.csv
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 *  Load and parse csv data to XML.
	 * 
	 *  @author wallen.
	 */	
	public class CSVLoader extends EventDispatcher
	{
		public function CSVLoader()
		{
			
		}
		
		/**
		 */		
		private var _codeType:String = 'GB2312';

		/**
		 */
		public function get codeType():String
		{
			return _codeType;
		}

		/**
		 * @private
		 */
		public function set codeType(value:String):void
		{
			_codeType = value;
		}

		
		/**
		 */		
		private var _columnNames : Array;

		public function get columnNames():Array
		{
			return _columnNames;
		}

		/**
		 *  This value must be setted as your csv column number.
		 *  
		 *  @param value
		 * 
		 */		
		public function set columnNames(value:Array):void
		{
			_columnNames = value;
		}

		/**
		 * @param url
		 */		
		public function loadCVS( url : String ) : void
		{
			var urlLoadler : URLLoader = new URLLoader();
			urlLoadler.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoadler.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, false );
			urlLoadler.addEventListener( Event.COMPLETE, loadedHandler, false, 0, false );
			urlLoadler.load( new URLRequest( url ) );
		}
		
		
		/**
		 * @param evt
		 */		
		private function ioErrorHandler( evt : IOErrorEvent ) : void
		{
			trace( 'IO_Error' );
		}
		
		/**
		 */		
		public var baseNodeName:String = 'data';
		
		/**
		 */		
		public var rowName:String = 'set';
		
		/**
		 * @param evt
		 */		
		private function loadedHandler( evt : Event ) : void
		{
			if ( !_columnNames  )
			{
				return;
			}
			
			var byt:ByteArray = evt.target.data;
			var source : Array = byt.readMultiByte(byt.bytesAvailable, codeType).split( '\r\n' );
			var rowsData : Array = new Array();
			
			for each ( var rowData : String  in source )
			{
				if ( rowData != '' )
				{
					rowsData.push( rowData.split( ',' ) );
				}
			}
			
			var resultXML : XML = <{baseNodeName}>
								  </{baseNodeName}>
				
			for each ( var rowArray : Array in rowsData )
			{
				var xmlNode : XML = <{rowName}>
									</{rowName}>
					
				var length : uint = rowArray.length;
				for ( var i : uint = 0; i < length; i ++ )
				{
					xmlNode.@[ _columnNames[ i ]  ]  = rowArray[ i ].toString();
				}
				
				resultXML.appendChild( xmlNode );
			}
			
			dispatchEvent( new CSVParseEvent( CSVParseEvent.PARSE_COMPLETE, resultXML ) );
		}
	}
}