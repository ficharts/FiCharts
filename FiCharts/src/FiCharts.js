(function(){
	
	var FiCharts = {}, 
	
	Chart2D = function(arg){
		this.constructor(arg);
		this.initChart(arg);
		return this;
    },
    
    Pie2D = function(arg){
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
	FiCharts.width = '400';
	FiCharts.height = '300';	
	FiCharts.style = 'white';
	FiCharts.usePreConfig = 1;
	
	
	//事件
	FiCharts.event = {};
	FiCharts.event.READY = "ready"; 
	FiCharts.event.RENDERED = "rendered";
	FiCharts.event.CONFIG_LOADED = "configLoaded";
	FiCharts.event.DATA_LOADED = "dataLoaded";
	FiCharts.event.ITEM_CLICKED = "itemClick";
	
	FiCharts.message = {};
	FiCharts.message.init = '初始化...';
	FiCharts.message.noData = '暂无数据';
	FiCharts.message.loadingData = '数据加载中...';
	FiCharts.message.loadingDataError = '数据加载失败';
	
	
	//-------------------------------
	//
	// 接受SWF的通讯枢纽
	//
	//-------------------------------
	
	FiCharts.ready = function(id) {
		FiCharts.getChartByID(id).ready();
	};
	
	FiCharts.configFileLoaded = function(id, data) {
		FiCharts.getChartByID(id).configLoaded(data);
	};
	
	FiCharts.dataFileLoaded = function(id, data) {
		FiCharts.getChartByID(id).dataLoaded(data);
	};
	
	FiCharts.itemClick = function(id, value) {
		FiCharts.getChartByID(id).itemClick(value);
	};
	
	FiCharts.rendered = function(id) {
		FiCharts.getChartByID(id).rendered();
	};
	
	FiCharts.getChartByID = function(id){
		return chartsMap[id];
	};
	
	FiCharts.debuger = function(id, info) {
		alert(info);
	};
	
	// 初始化图表的基本属性；
	init = function(chart, arg) {
		if (hasProp(arg.id)){
			chart.id = arg.id;
		}
		
		// id 参数为必选项， 可以只传递id， 此时arg为字符类型；
		if (typeof arg === "string") {
			chart.id = arg;
		};
		
		if (hasProp(arg.configFile)) {
			chart.configFile = arg.configFile;
		} else {
			chart.configFile = '';
		}
		
		if (hasProp(arg.style)) {
			chart.style = arg.style;
		} else {
			chart.style = '';
		}
		
		if (hasProp(arg.usePreConfig)) {
			chart.usePreConfig = arg.usePreConfig;
		} else {
			chart.usePreConfig = FiCharts.usePreConfig;
		}
		
		if (hasProp(arg.preConfigFile)) {
			chart.preConfigFile = arg.preConfigFile;
		} else {
			chart.preConfigFile = '';
		}
		
		chart.width = hasProp(arg.width) ? arg.width : FiCharts.width;
		chart.height = hasProp(arg.height) ? arg.height : FiCharts.height;
		
		chart.message = {};
		chart.message.init = FiCharts.message.init;
		chart.message.noData = FiCharts.message.noData;
		chart.message.loadingData = FiCharts.message.loadingData;
		chart.message.loadingDataError = FiCharts.message.loadingDataError;
		
		chart.ifConfigChanged = chart.ifDataChanged = chart.ifNeedRender = chart.ifConfigFileChanged = chart.ifReady = this.styleChanged = false;
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
			
			var flashvars = {};
			flashvars.id = this.id;
			flashvars.configFile = this.configFile;
			
			// 默认只要默认配置存在则使用预先配置； 
			flashvars.usePreConfig = this.usePreConfig;
			flashvars.preConfigFile = this.preConfigFile;// 外部预先配置文件；
						
			flashvars.initInfo = this.message.init;
			
			flashvars.loadingDataInfo = this.message.loadingData;
			flashvars.noDataInfo = this.message.noData;
			flashvars.loadingDataErrorInfo = this.message.loadingDataError;
			
				
			initSWF(this, flashvars);
			registerChart(this.id, this);
		};
		
		that.dispose = function() {
			this.id = null;
			this.configFile = null;
			this.usePreConfig = null;
			this.preConfigFile = null;
			this.message = null;
			this.style = null;
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
		
		that.onConfigLoaded = function(callback) {
			return this.addEventListener(FiCharts.event.CONFIG_LOADED, callback);
		};
		
		that.onDataLoaded = function(callback) {
			return this.addEventListener(FiCharts.event.DATA_LOADED, callback);
		};
		
		that.onRendered = function(callback) {
			return this.addEventListener(FiCharts.event.RENDERED, callback);
		};
		
		that.onClicked = function(callback) {
			return this.addEventListener(FiCharts.event.ITEM_CLICKED, callback);
		};
		
		
		
		//-------------------------------------
		//
		// SWF 向  JS 的回调方法 
		//
		//-------------------------------------
		
		that.ready = function() {
		    
		    this.ifReady = true;
		    
		    this.swf = doc.getElementById(this.id);
		    
			if (this.ifConfigChanged) {
				this.setConfigXML(this.configXML);
				this.ifConfigChanged = false;
			}
			
			if (this.ifDataChanged) {
				this.setDataXML(this.dataXML);
				this.ifDataChanged = false;
			}
			
			if (this.styleChanged)
			{
			    this.setStyle(this.style);
			    this.styleChanged = false;
			}
			
			if (this.ifNeedRender) {
				this.render();
				this.ifNeedRender = false;
			}
			
			this.dispatchEvent({type: FiCharts.event.READY, target: this});
			
			if (this.ifConfigFileChanged)
				this.setConfigFile(this.configFile);
			
		};
		
		that.configLoaded = function(value) {
			this.configXML = value
			this.dispatchEvent({type: FiCharts.event.CONFIG_LOADED, target: this, data: this.configXML});
		};
		
		that.dataLoaded = function(value) {
			this.dataXML = value;
			this.dispatchEvent({type: FiCharts.event.DATA_LOADED, target: this, data: this.dataXML});
		};
		
		that.rendered = function() {
			this.dispatchEvent({type: FiCharts.event.RENDERED, target: this});
		};
		
		that.itemClick = function(value) {
			this.dispatchEvent({type: FiCharts.event.ITEM_CLICKED, data: value, target: this})
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
		
		that.setConfigXML = function(value) {
			if (this.ifReady) {
				this.swf.setConfigXML(value);
			}else{
				this.ifConfigChanged = true;
			}
			
			this.configXML = value;
			return this;
		};
		
		that.setDataXML = function(value) {
			if (this.ifReady) {
				this.swf.setDataXML(value);
			}else{
				this.ifDataChanged = true;
			}
			
			this.dataXML = value;
			return this;
		};
		
		that.render = function() {
			if (this.ifReady) {
				this.swf.render();
			}else{
				this.ifNeedRender = true;
			}
			
			return this;
		};
		
		
		// 初始化完毕后方可调用此方法;
		that.setConfigFile = function(value) {
			if (this.ifReady)
				this.swf.setConfigFile(value);
			else
			    this.ifConfigFileChanged = true;
			    
			this.configFile = value;
			return this;
		};
		
		// 初始化完毕并且配置文件已经被加载后再可以调用此方法;
		that.setDataFile = function(value) {
			this.swf.setDataFile(value);
			
			return this;
		};
		
		// 当初始化完毕后调用此方法只是改变样式配置文件， 如果需要看到效果还需要调用 render()方法；
		that.setStyle = function(value) {
			if (this.ifReady) {
				this.swf.setStyle(value);
			} else {
				this.style = value; // 此时只是改变SWF初始化参数;
				this.styleChanged = true;
			}
			
			return this;
		};
		
		that.setJsonData = function(value) {
		    var length = value.length;
		    
		    var xmlString = "<data>";
		    for (var i = 0; i < length; i ++)
		    {
		       var item = "<set"
		       for (var atrribute in value[i])
		       {
		           item += " " + atrribute + "=" + "\'" + value[i][atrribute] + "\'";
		       }
		       item  += "/>"
		       xmlString += item;
		    }
		    
		    xmlString += "</data>"
		    
		    this.setDataXML(xmlString);
		    
		    return this;
		}
		
		return that;
	};
	
	//------------------------------
	//
	// 2D图表
	//
	//------------------------------
	
	win.Chart2D = Chart2D;
	Chart2D.swfURL = "Chart2D.swf";
	Chart2D.prototype = function() {
		
		var that = chartBase();
		that.constructor = function(arg) {
			this.swfURL = getSWFURL(Chart2D.swfURL);
			init(this, arg);
		};
		
		return that;
	}();
	
	//------------------------------
	//
	// 2D图表
	//
	//------------------------------
	
	win.Pie2D = Pie2D;
	Pie2D.swfURL = "Pie2D.swf";
	Pie2D.prototype = function() {
		
		var that = chartBase();
		that.constructor = function(arg) {
			init(this, arg);
			this.swfURL = getSWFURL(Pie2D.swfURL);
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
	            params.allowfullscreen = "true";
	            params.wmode = "transparent";
				
				flashvars.style = chart.style; // 此时SWF还未初始化， style 作为参数传入；
				
				// IE 下执行generateSWF时图表已经完成初始化，但 chart.swf还未被赋值，所以
				//
				// 需在ready方法中再次赋值swf，以保证对swf的方法调用成功
				chart.swf = generateSWF(attributes, params, flashvars);
				
				registerMouseWheelEvt(chart.swf);
				
			})
	};
	
	function registerMouseWheelEvt(target){
		
		var isFF = function(){
			return navigator.userAgent.indexOf("Firefox") != -1;
		}();
		
		var onMouseWheel = function(){
			
			if (target.ifDataScalable()){
				
				var event = window.event || arguments[0];
				
				if (isFF){
					target.onWebmousewheel(event.detail);
					event.preventDefault();
				}else{
					target.onWebmousewheel(event.wheelDelta);
					event.returnValue = false; 
				}
			}
		}
		
		target.onmouseover = function(){
			if (isFF){
				doc.addEventListener('DOMMouseScroll', onMouseWheel, false);
			}else{
				doc.onmousewheel = onMouseWheel;
			}
		}
		
		target.onmouseout = function(){
			if (isFF){
				doc.removeEventListener('DOMMouseScroll', onMouseWheel, false);
			}else{
				doc.onmousewheel = null;
			}
		}
	}
	
	
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
