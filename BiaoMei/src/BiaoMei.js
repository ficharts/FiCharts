(function(){
	
	var FiCharts = {}, 
	
	BiaoMei = function(arg){
		this.constructor(arg);
		this.initChart(arg);
		return this;
    },

	UNDEF = "undefined",
	OBJECT = "object",
	SHOCKWAVE_FLASH = "Shockwave Flash",
	SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
	FLASH_MIME_TYPE = "application/x-shockwave-flash",
	ON_READY_STATE_CHANGE = "onreadystatechange",
	
	win = window,
	doc = document,
	nav = navigator,
	
	plugin = false,
	isDomLoaded = false,
	domLoadFnArr = [],
	listenersArr = [],
	
	chartsMap = {},
	chartsArray = [],
	
	//------------------------------------
	//
	// 浏览器与播放器信息
	//
	//------------------------------------
	ua = function() {
		var w3cdom = typeof doc.getElementById != UNDEF && typeof doc.getElementsByTagName != UNDEF && typeof doc.createElement != UNDEF,
			u = nav.userAgent.toLowerCase(),
			p = nav.platform.toLowerCase(),
			windows = p ? /win/.test(p) : /win/.test(u),
			mac = p ? /mac/.test(p) : /mac/.test(u),
			webkit = /webkit/.test(u) ? parseFloat(u.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false, // returns either the webkit version or false if not webkit
			ie = !+"\v1", 
			playerVersion = [0,0,0],
			d = null;
		if (typeof nav.plugins != UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] == OBJECT) {
			d = nav.plugins[SHOCKWAVE_FLASH].description;
			if (d && !(typeof nav.mimeTypes != UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { // navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin indicates whether plug-ins are enabled or disabled in Safari 3+
				plugin = true;
				ie = false; 
				d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
				playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
				playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
				playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
			}
		}
		else if (typeof win.ActiveXObject != UNDEF) {
			try {
				var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
				if (a) { 
					d = a.GetVariable("$version");
					if (d) {
						ie = true; 
						d = d.split(" ")[1].split(",");
						playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
					}
				}
			}
			catch(e) {}
		}
		return { w3:w3cdom, pv:playerVersion, wk:webkit, ie:ie, win:windows, mac:mac };
	}(),
	
	//----------------------------------------
	//
	// Dom 加载与页面初始化
	//
	//----------------------------------------
	
	onDomLoad = function() {
		if (!ua.w3) { return; }
		if ((typeof doc.readyState != UNDEF && doc.readyState == "complete") || (typeof doc.readyState == UNDEF && (doc.getElementsByTagName("body")[0] || doc.body))) { // function is fired after onload, e.g. when script is inserted dynamically 
			callDomLoadFunctions();
		}
		if (!isDomLoaded) {
			if (typeof doc.addEventListener != UNDEF) {
				doc.addEventListener("DOMContentLoaded", callDomLoadFunctions, false);
			}		
			if (ua.ie && ua.win) {
				doc.attachEvent(ON_READY_STATE_CHANGE, function() {
					if (doc.readyState == "complete") {
						doc.detachEvent(ON_READY_STATE_CHANGE, arguments.callee);
						callDomLoadFunctions();
					}
				});
				if (win == top) { 
					(function(){
						if (isDomLoaded) { return; }
						try {
							doc.documentElement.doScroll("left");
						}
						catch(e) {
							setTimeout(arguments.callee, 0);
							return;
						}
						callDomLoadFunctions();
					})();
				}
			}
			if (ua.wk) {
				(function(){
					if (isDomLoaded) { return; }
					if (!/loaded|complete/.test(doc.readyState)) {
						setTimeout(arguments.callee, 0);
						return;
					}
					callDomLoadFunctions();
				})();
			}
			addLoadEvent(callDomLoadFunctions);
		}
	}();
	
	function callDomLoadFunctions() {
		if (isDomLoaded) { return; }
		try { 
			var t = doc.getElementsByTagName("body")[0].appendChild(doc.createElement("span"));
			t.parentNode.removeChild(t);
		}
		catch (e) { return; }
		isDomLoaded = true;
		var dl = domLoadFnArr.length;
		for (var i = 0; i < dl; i++) {
			domLoadFnArr[i]();
		}
	};
	
	function addDomLoadEvent(fn) {
		if (isDomLoaded) {
			fn();
		}
		else { 
			domLoadFnArr[domLoadFnArr.length] = fn; 
		}
	};
	
	function addLoadEvent(fn) {
		if (typeof win.addEventListener != UNDEF) {
			win.addEventListener("load", fn, false);
		}
		else if (typeof doc.addEventListener != UNDEF) {
			doc.addEventListener("load", fn, false);
		}
		else if (typeof win.attachEvent != UNDEF) {
			addListener(win, "onload", fn);
		}
		else if (typeof win.onload == "function") {
			var fnOld = win.onload;
			win.onload = function() {
				fnOld();
				fn();
			};
		}
		else {
			win.onload = fn;
		}
	};
	
	
	//------------------------------
	//
	// 全局静态属性
	//
	//------------------------------
	
	win.FiCharts = FiCharts;
	FiCharts.width = '100%';
	FiCharts.height = '100%';	

	//事件
	FiCharts.event = {};
	FiCharts.event.READY = "ready"; 
	FiCharts.event.RENDERED = "rendered";

	
	//-------------------------------
	//
	// 接受SWF的通讯枢纽
	//
	//-------------------------------
	
	FiCharts.beforeInit = function(id) {
		
		var chart = FiCharts.getChartByID(id);
		
		// IE 下 初始化顺序较奇葩，这里处理较稳妥，防止swf为空
		if (chart.swf == null)
			chart.swf = doc.getElementById(chart.id);
		
		chart.beforeInit();
	};
	
	FiCharts.ready = function(id) {
		FiCharts.getChartByID(id).ready();
	};
	
	
	// 初始化图表的基本属性；
	init = function(chart, arg) {
		
		var chartW = FiCharts.width;
		var chartH = FiCharts.height;
		
		chart.configFile = '';
		chart.style = '';
		
		if (hasProp(arg.id)){
			chart.id = arg.id;
		}
		
		// id 参数为必选项， 可以只传递id， 此时arg为字符类型；
		if (typeof arg === "string") {
			
			var args = arg.split(",");
			
			if (args.length == 1){
				chart.id = args[0];
			}else if (args.length == 2){
				chart.id = args[0];
				chart.configFile = args[1];
			}else if (args.length == 3){
				chart.id = args[0];
				chartW = args[1];
				chartH = args[2];
			}else if (args.length == 4){
				chart.id = args[0];
				chartW = args[1];
				chartH = args[2];
				chart.configFile = args[3];
			}
		};
		
		if (hasProp(arg.configFile)) {
			chart.configFile = arg.configFile;
		}
		
		if (hasProp(arg.style)) {
			chart.style = arg.style;
		}
		
		chart.width = hasProp(arg.width) ? arg.width : chartW;
		chart.height = hasProp(arg.height) ? arg.height : chartH;
		
			
	};
	
	
	//--------------------------------------------------
	//
	// 所有图表的基类, 属性与方法进行了分离， 避免属性被污染；
	//
	//---------------------------------------------------
	function chartBase(){
		var that = {};
		
		//------------------------------
		//
		// 初始化
		//
		//------------------------------
		that.constructor = function(arg) {
			init(this, arg);
		};
		
		that.initChart = function (arg) {
			registerChart(this.id, this);
			
			var flashvars = {};
			flashvars.id = this.id;
	
			initSWF(this, flashvars);
		};
		
		that.dispose = function() {
			this.id = null;		
			this.swf = null;
			removeSWF(this.id);
		};
		
		
		//--------------------------------------------------
		//
		// 事件处理
		//
		//--------------------------------------------------
		that.addEventListener = function(event, callback) {
	        if (this.listeners == null) this.listeners = {};
	        if (this.listeners[event] == null) this.listeners[event] = [];
	        this.listeners[event].push(callback);
			
			return this;
	    };
	
	    that.removeEventListener = function(event, callback) {
	        if (this.listeners == null || this.listeners[event] == null) return;
	
	        var index = -1;
	        for (var i = 0; i < this.listeners[event].length; i++) {
	            if (this.listeners[event][i] == callback) {
	                index = i;
	                break;
	            }
	        }
	        if (index != -1)
	            this.listeners[event].splice(index, 1);
				
			return this;
	    };
	
	    that.dispatchEvent = function(e) {
	        if (e == null || e.type == null) return;
	        e.target = this;
	        if (this.listeners == null || this.listeners[e.type] == null) return;
	        var len = this.listeners[e.type].length;
			
	        for (var i = 0; i < len; i++) {
	            this.listeners[e.type][i](e);
	        }
	    };
		
		
		//----------------------------------------
		//
		// 为了简化事件的添加，定义了一些简便的方法；
		//
		//----------------------------------------
		
		that.onReady = function(callback) {
			return this.addEventListener(FiCharts.event.READY, callback);
		};
		
		
		
		
		
		
		//-------------------------------------
		//
		// SWF 向  JS 的回调方法 
		//
		//-------------------------------------
		
		
		// 此方法在swf已经被创建但未内部初始化之前被调用
		// 这是图表调用外部的第一个方法，之后是 ready
		that.beforeInit = function(){
			 
			 // 设置了此模式后，图表会自动适应容器尺寸，当宽高设为100%时
			 // 容器尺寸缩放，图表自动调整自己的尺寸，并完成渲染；
			 this.swf.setWebMode();
		};
		
		// 此方法在图表完成整个初始化后被创建
		that.ready = function() {
		    
		    this.ifReady = true;
		    
			
			this.dispatchEvent({type: FiCharts.event.READY, target: this});
			
		};
		
		
		
		
		
		
		//-------------------------------
		//
		// 供外部使用的接口
		//
		//-------------------------------
		
		that.setSize = function(width, height) {
			if (this.ifReady) {
				this.swf.width = width;
				this.swf.height = height;
			} else {
				this.width = width;
				this.height = height;
			};
			
			return this;
		};
		
		

		return that;
	};
	
	//------------------------------
	//
	// 2D图表
	//
	//------------------------------
	
	win.BiaoMei = BiaoMei;
	BiaoMei.swfURL = "BiaoMei.swf";
	BiaoMei.prototype = function() {
		
		var that = chartBase();
		that.constructor = function(arg) {
			this.swfURL = getSWFURL(BiaoMei.swfURL);
			init(this, arg);
		};
		
		return that;
	}();
	
	
	
	
	
	//------------------------------
	//
	// 设置SWF的属性配置
	//
	//------------------------------
	function initSWF(chart, flashvars) {
		addDomLoadEvent(function() {
				var attributes = {}; // 每构建一个新实例则创建一个新私有属性对象
	            attributes.id = chart.id;
	            attributes.name = chart.id;
	            attributes.align = "middle";
				attributes.width = chart.width.toString().replace(/\%$/,"%25");
				attributes.height = chart.height.toString().replace(/\%$/,"%25");
				attributes.data = chart.swfURL;

				var params = {};
	            params.quality = "high";
	            params.allowscriptaccess = "sameDomain";
	            params.allowfullscreen = "false";
	            params.wmode = "transparent";
				
				chart.swf = generateSWF(attributes, params, flashvars);
				
			})
	};
	
	
	
	
	//------------------------------------------------
	//
	// 嵌入SWF到网页中
	//
	//------------------------------------------------
	
	function generateSWF(attributes, params, flashVars) {
		var r, el = doc.getElementById(attributes.id);
		if (flashVars && typeof flashVars === OBJECT) {
			for (var k in flashVars) { 
				if (typeof params.flashvars != UNDEF) {
					params.flashvars += "&" + k + "=" + flashVars[k];
				}
				else {
					params.flashvars = k + "=" + flashVars[k];
				}
			}
		}
					
		if (ua.wk && ua.wk < 312) { return r;};
		if (!hasPlayerVersion('10.0.0')) {
			addLoadEvent(function() {
				el.innerHTML = '<a href="http://get.adobe.com/cn/flashplayer/?no_redirect">需要安装Flash播放器<a/>';
			})
			
			return r;
		}else {
			if (el) {
				if (ua.ie && ua.win) { 
					var att = "";
					for (var i in attributes) {
						if (attributes[i] != Object.prototype[i]) { 
							if (i.toLowerCase() == "data") {
								params.movie = attributes[i];
							}
							else if (i.toLowerCase() == "styleclass") { 
								att += ' class="' + attributes[i] + '"';
							}
							else if (i.toLowerCase() != "classid") {
								att += ' ' + i + '="' + attributes[i] + '"';
							}
						}
					}
					
					var par = "";
					for (var j in params) {
						if (params[j] != Object.prototype[j]) { 
							par += '<param name="' + j + '" value="' + params[j] + '" />';
						}
					}
					
					el.outerHTML = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' + att + '>' + par + '</object>';
					r = doc.getElementById(attributes.id);	
					
				}else { 
					var o = doc.createElement(OBJECT);
					o.setAttribute("type", FLASH_MIME_TYPE);
					for (var m in attributes) {
						if (attributes[m] != Object.prototype[m]) {
							if (m.toLowerCase() == "styleclass") { 
								o.setAttribute("class", attributes[m]);
							}
							else if (m.toLowerCase() != "classid") { 
								o.setAttribute(m, attributes[m]);
							}
						}
					}
					for (var n in params) {
						if (params[n] != Object.prototype[n] && n.toLowerCase() != "movie") { 
							createObjParam(o, n, params[n]);
						}
					}
					el.parentNode.replaceChild(o, el);
					r = o;
				}
			}
			
			return r;
		}
		
	};
	
	function createObjParam(el, pName, pValue) {
		var p = doc.createElement("param");
		p.setAttribute("name", pName);	
		p.setAttribute("value", pValue);
		el.appendChild(p);
	};
	
	function hasPlayerVersion(rv) {
		var pv = ua.pv, v = rv.split(".");
		v[0] = parseInt(v[0], 10);
		v[1] = parseInt(v[1], 10) || 0; // supports short notation, e.g. "9" instead of "9.0.0"
		v[2] = parseInt(v[2], 10) || 0;
		return (pv[0] > v[0] || (pv[0] == v[0] && pv[1] > v[1]) || (pv[0] == v[0] && pv[1] == v[1] && pv[2] >= v[2])) ? true : false;
	}
	
	// 回收
	var cleanup = function() {
		if (ua.ie && ua.win) {
			window.attachEvent("onunload", function() {
				
				var ll = listenersArr.length;
				for (var i = 0; i < ll; i++) {
					listenersArr[i][0].detachEvent(listenersArr[i][1], listenersArr[i][2]);
				}
				
				var il = chartsArray.length;
				for (var j = 0; j < il; j++) {
					removeChart(chartsArray[j]);
					chartsArray[j] = null;
				}
				
				chartsMap = chartsArray = null;
				
				for (var k in ua) {
					ua[k] = null;
				}
				
				ua = null;
			});
		}
	}();
	
	
	
	//-------------------------------
	//
	// 供内部使用的私有方法
	//
	//-------------------------------
	
	function getSWFURL(swfURL) {
		var url;
		var items = doc.getElementsByTagName('script');
		var length = items.length;
		var src;
		for (var i = 0; i < length; i ++)
		{
			src = items[i].src;
			if (src.indexOf('FiCharts.js') != - 1)
			{
				src = src.slice(0, src.indexOf('FiCharts.js'))
				url = src + swfURL;
			}
		}
		
		if (hasProp(url))
			return url;
		else
			return swfURL;
	};
	
	function registerChart(id, chart){
		chartsMap[id] = chart;
		chartsArray[chartsArray.length] = chart;
	};
	
	function removeChart(chart){
		chart.dispose();
		chartsMap[chart.id] = null;
	};
	
	function removeSWF(id) {
		var obj = doc.getElementById(id);
		if (obj && obj.nodeName == "OBJECT") {
				obj.style.display = "none";
				(function(){
					if (obj.readyState == 4) {
						for (var i in obj) {
							if (typeof obj[i] == "function") {
								obj[i] = null;
							}
						}
						obj.parentNode.removeChild(obj);
					}else {
						setTimeout(arguments.callee, 10);
					}
				})();
		}
	};
	
	function hasProp(target) {
		 return typeof target != "undefined"; 
	};
	
	function addListener(target, eventType, fn) {
		target.attachEvent(eventType, fn);
		listenersArr[listenersArr.length] = [target, eventType, fn];
	};
	
})();
