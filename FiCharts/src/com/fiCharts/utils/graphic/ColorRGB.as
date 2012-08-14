package com.fiCharts.utils.graphic
{
	public class ColorRGB 
	{
		private var CRGB:Array;
		private var CINT:Number;
		private var CStrF:String;
		private var CStrH:String;
		private var CStrJH:String;
		
		public function ColorRGB(a:Object="") 
		{
			if (!(typeof(a)=='string'&& a=="")) 
			{
				value(a);
			}
		}
		
		public function value(a:Object):void 
		{
			if (typeof(a)=='string') 
			{
				String16ToRGB(String(a));
			} else if (typeof(a)=='number') 
			{
				String16ToRGB(numberToRGB16(Number(a)));
			} 
			else if (typeof(a)=='object') 
			{
				String16ToRGB(ArrayToRGB16(a));
			}
		}
		
		private function ArrayToRGB16(a:Object):String 
		{
			var b:String = new String();
			var i:Number;
			
			for (i=0; i<a.length; i++) 
			{
				var bb:String=a[i].toString(16);
				if (bb.length==1) 
				{
					b+="0"+bb;
				} 
				else 
				{
					b+=bb;
				}
			}
			
			var ii:Number=6-b.length;
			for (i=0; i<ii; i++) 
			{
				b="0"+b;
			}
			
			return b;
		}
		
		private function numberToRGB16(a:Number):String 
		{
			var num16:String = new String();
			var bb:String;
			if (a<16777215 && a>0) 
			{
				num16=a.toString(16);
				if (num16.length<6) 
				{
					var ii:Number=6-num16.length;
					for (var i:Number=0; i<ii; i++) 
					{
						num16="0"+num16;
					}
				}
				bb= num16;
				
			} 
			else if (a<=0) 
			{
				bb= "000000";
			} 
			else 
			{
				bb= "ffffff";
			}
			
			return bb;
		}
		
		private function String16ToRGB(a:String):void 
		{
			var b:String="0123456789abcdef";
			var s:String=a.toLocaleLowerCase();
			var R:Number;
			var G:Number;
			var B:Number;
			if (s.substr(0,1)=="#") {
				s=s.replace(/#/gi,"");
				if (s.length==3) {
					var temp:String="";
					temp+=s.substr(0,1)+s.substr(0,1);
					temp+=s.substr(1,1)+s.substr(1,1);
					temp+=s.substr(2,1)+s.substr(2,1);
					s=temp;
				}
			} else {
				s=s.replace(/0x/gi,"");
			}
			if (s.length>6) {
				s=s.substr(0,6);
			}
			for (var i:Number=0; i<s.length; i++) {
				if (b.indexOf(s.charAt(i))==-1) {
					s=s.substr(0,i-1)+"f"+s.substr(i+1);
				}
			}
			CStrF="0x"+s;
			CStrH="#"+s;
			CStrJH="#"+HtoJ(s);
			CINT=Number("0x"+s);
			R=Number("0x"+s.substr(0,2));
			G=Number("0x"+s.substr(2,2));
			B=Number("0x"+s.substr(4,2));
			CRGB=[R,G,B];
		}
		
		private function HtoJ(a:String):String 
		{
			var b:Boolean=false;
			var s:String="";
			for (var i:Number=0; i<6; i+=2) {
				if (a.substr(i,1)!=a.substr(i+1,1)) {
					b=true;
				}
			}
			if (b) {
				return a;
			} else {
				s=a.substr(0,1)+a.substr(2,1)+a.substr(4,1);
				return s;
			}
		}
		
		public function get cRgb():Array 
		{
			return CRGB;
		}
		
		public function get cInt():Number 
		{
			return CINT;
		}
		
		public function get cStrH():String 
		{
			return CStrH;
		}
		
		public function get cStrJH():String 
		{
			return CStrJH;
		}
		
		public function get cStrF():String 
		{
			return CStrF;
		}
	}
}