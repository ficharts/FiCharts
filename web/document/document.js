(function() {
	$(document).ready(function() {

		
		FichartsWeb.initMailLinkImg("../");

		var leftNavContorl = function() {

			var currentTitle;

			var addLiClickHandler = function(navLi) {

				$(navLi).click(function() {

					if(this.id == currentTitle.attr('id'))
						return false;

					$(this).toggleClass('currentArticle');
					currentTitle.removeClass('currentArticle');
					currentTitle = $(this);
					loadContent($('a', this).attr('href'));

					return false;
				})
			};
			
			var loadContent = function(url) {
				$("#docContent").load(url, "#data");
			};
			
			return {

				init : function() 
				{
					currentTitle = $("#leftNav li").eq(0);
					currentTitle.addClass('currentArticle');
					loadContent($('a', currentTitle).attr('href'));
					
					//loadContent($("#attributes a").attr('href'));

					$("#leftNav li").each(function() 
					{

						if(this.children.length > 1) 
						{
							$(this).attr('state', 'close')
							$(this).click(function() 
							{
								if($(this).attr('state') == 'close') 
								{
									$(this).children("a").find("span").text('-');
									$(this).attr("state", "open");
									
									$('ul', this).css('display', 'block').children('li').each(function() 
									{
										addLiClickHandler(this);
									});
									
									return false;
									
								} 
								else 
								{
									$(this).children("a").find("span").text('+');
									$(this).attr("state", "close");
									$('ul', this).css('display', 'none');
									
									$('ul', this).children('li').each(function() 
									{
										$(this).unbind('click');
									});
									
									return false;
								}
							})
						} 
						else 
						{
							addLiClickHandler(this);
						}

					})
				}
			}

		}();

		leftNavContorl.init();

	})
})()