(function() {
	
	$(document).ready(function() {

		var FichartsWeb = {};
		window.FichartsWeb = FichartsWeb;
		FichartsWeb.initMailLinkImg = function (path) {

			$("#footer-inner p.contact a").mouseover(function(value) {
				this.style.backgroundImage = "url(" + path + "images/mail_over.gif)";
			}).mouseout(function() {
				this.style.backgroundImage = "url(" + path + "images/mail_up.gif)";
			})
		}

		$.extend(
		{
			xmlToString: function(xmlObject) 
			{
				if (typeof xmlObject == 'string')
					return xmlObject;

				if (window.ActiveXObject) 
				{ // for IE  
        			return xmlObject.xml;  
    			} 
    			else 
    			{  
       				return (new XMLSerializer()).serializeToString(xmlObject);  
    			} 
			},

			stringToXML: function(strXML)  
			{  
			    if (window.ActiveXObject) 
			    {  
			        var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");  
			        xmlDoc.async = "false";  
			        xmlDoc.loadXML(strXML);  

			        return xmlDoc;  
			    } 
			    else 
			    {  
			        var parser = new DOMParser();  
			        var xmlDoc = parser.parseFromString(strXML,"text/xml");  

			        return xmlDoc;  
			    }  
			}  
		});

	});



	
})()