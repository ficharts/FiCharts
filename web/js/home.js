(function () {
	$(document).ready(function() {
		FichartsWeb.initMailLinkImg("./");
		
		$('#links div.quickLink').each(function(){

			$(this).mouseover(function()
			{
				$('img', this).attr('src', './images/' + $(this).find('a').first().attr('id') + '_over.png')
				$('a.label', this).css('color', '#0088cc')

			}).mouseout(function()
			{
				$('img', this).attr('src', './images/' + $(this).find('a').first().attr('id') + '_up.png')
				$('a.label', this).css('color', '#888')
			})
		})


		$('#sina img').mouseover(function(){
			$(this).attr('src', './images/sina_over.jpg')
		}).mouseout(function(){
			$(this).attr('src', './images/sina_up.jpg')
		}) 

		$('#down img').mouseover(function(){
			$(this).attr('src', './images/buy_over.jpg')
		}).mouseout(function(){
			$(this).attr('src', './images/buy_up.jpg')
		})
		
	})
	
})()
