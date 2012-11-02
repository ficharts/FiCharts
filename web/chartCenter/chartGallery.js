(function() {

	$(document).ready(function()
	{

		var configXML;
		var htmlContent = '';
		var chartShotContent;

		$.get('./config.xml', function(data)
		{

			if( typeof data == 'string'){
				configXML = $.stringToXML(data);
			}
			else{
				configXML = data;
			};


			// 根据配置文件初始化
			$(configXML).find('chart').each(function()
			{
				htmlContent += '<p class="chartTypeTitle">' + $(this).attr('title') + '</p>';

				chartShotContent = ''
				$(this).find('item').each(function()
				{

					var url = $(this).attr('demoURL');
					if (typeof $(this).attr('style') != 'undefined')
						url += '&style=' + $(this).attr('style');
						url +=  '&type=' + $(this).attr('type');

					chartShotContent += '<div class="chart-shot">';
					chartShotContent += '<a class="chart-link" href=' + './gallery/demo.html?url=' + url  + '><img src=' + $(this).attr('imgURL') + '></a>'
					chartShotContent += '<a class="chart-over" href=' + './gallery/demo.html?url='+ url  + '><strong>' + $(this).attr('title') + '</strong><span>' + $(this).attr('desc') + '</span></a>'
					chartShotContent += '</div>'
					
				})

				htmlContent += chartShotContent;
	
			})

			$('#centerContent').html(htmlContent);

	
			// 添加鼠标状态与点击事件
			$('div.chart-shot').each(function()
			{

				var link = $('a', this).last();
				var title = link.find('strong').text();

				// 默认隐藏
				link.css('opacity', 0)

				link.mouseover(function()
				{
					link.css('opacity', 1);
				})

				link.mouseout(function()
				{
					$(this).css('opacity', 0);
				})

				// 点击后弹出新窗口
				link.click(function(event)
				{
					if (window.event) 
					{
						window.event.returnValue = false;
						window.event.cancelBubble = true;
					} 
					else if (event) 
					{
						event.stopPropagation();
						event.preventDefault();
					} 

					openChart(link.attr('href'), title)

					return false;
				})

				
			})

		})

	});


	var openChart = function(path, title)
	{
		var width = 800;
		var height = 500;
		var left = (screen.width) ? (screen.width - width)/2 : 0;
		var top = (screen.height) ? (screen.height - height)/2 : 0; 

		window.open(path, title, 'scrollbars=1,resizable=1, width=' + width + ', height=' + height + ', left=' + left + ', top=' + top);

		return false;
	};
	
})()