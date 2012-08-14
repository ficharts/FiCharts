package com.fiCharts.utils
{  
    import flash.utils.Dictionary;  
      
	/**
	 * @author wallen
	 */	
    public class Map
    {    
		
		
        private var _keys:Array = null;  
        private var props:Dictionary = null;  
         
        /**
         * 
         * 
         */                  
        public function Map()
        {  
            clear();  
        }  
        
        public function clear():void
        {  
			props = new Dictionary();  
            _keys = new Array();  
        } 
         
        public function containsKey(key:*):Boolean
        {  
            return props[key] != null;  
        }  
        
        public function containsValue(value:*):Boolean
        {  
            var result:Boolean = false;  
            var len:uint = size;  
            
            if( len > 0 )
            {  
                for(var i:uint = 0 ; i < len ; i++)
                {  
                    if( props[_keys[i]] == value ) return true;  
                }  
            } 
            
            return false
        }  
        
        /**
         * 
         * @param key
         * @return 
         * 
         */                
        public function getValue(key:*):*
        {  
            return props[key];  
        } 
        
        /**
         * 
         * @param key
         * @param value
         * @return 
         * 
         */                 
        public function put(key:*,value:*):*
        {  
            var result:* = null;  
            
            if( this.containsKey(key) )
            {  
                    result = getValue(key);  
                    props[key] = value;  
            }
            else
            {  
                    props[key] = value;  
                    _keys.push(key);  
            }  
            
            return result;  
        }  
        
        /**
         * 
         * @param key
         * @return 
         * 
         */                
        public function remove(key:*) : void
        {  
            if(this.containsKey(key))
            {
                delete props[key];  
                
                var index:int = _keys.indexOf( key );
                
                if( index > -1 )
                {  
                	_keys.splice( index, 1 );
                }  
            }  
                
        }  
        
        /**
         * 
         * @param map
         * 
         */                
        public function putAll(map:Map):void
        {  
            clear();  
            var len:uint = map.size; 
             
            if(len > 0)
            {  
                var arr:Array = map.keys; 
                 
                for(var i:uint=0;i<len;i++)
                {  
                    put(arr[i],map.getValue(arr[i]));  
                }  
            }  
        }  
        
        /**
         * 
         * @return 
         * 
         */                
        public function get size():uint
        {  
            return this._keys.length;  
        }  
    
        /**
         * 
         * @return 
         * 
         */                
        public function isEmpty():Boolean
        {  
            return size < 1;  
        }
          
		/**
		 * @return 
		 */		
        public function values():Array
        {  
            var result:Array = new Array();  
            var len:uint = this.size;  
            
            if(len > 0)
            {  
                for(var i:uint = 0;i<len;i++)
                {  
                    result.push(this.props[this._keys[i]]);  
                }  
            }  
            
            return result;  
        }  
        
		/**
		 * @return 
		 */		
        public function get keys():Array
        {  
            return _keys;  
        }  
        
        /**
         * @return 
         */                 
        public function toString():String
        {  
            var out:String = "";  
            
            for( var i:uint=0; i< this.size; i++ )
            {  
                out += _keys[i] + ":"+ getValue( _keys[i] ) + "\n";  
            }  
            
            return out; 
        }  
    }  
}  
