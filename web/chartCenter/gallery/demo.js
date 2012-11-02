(function()
{

    $(document).ready(function()
    {
        $('#xml').addClass('hide')

        var congfigURL = request('url')
        var style = request('style');
        var type = request('type');

        var myChart;

        if (type && type == 'pie'){
             myChart = new Pie2D({id: 'chart', width: '100%', height: '99%', configFile: congfigURL});
        }else{
            myChart = new Chart2D({id: 'chart', width: '100%', height: '99%', configFile: congfigURL});
        }

        if (typeof style !== 'undefined')
            myChart.setStyle(style);

        myChart.onConfigLoaded(function(evt){

             $('#configXML').text(evt.data)
             prettyPrint();
            
        });


        var currentTab = $('div.tab-control a').first();
        currentTab.toggleClass('tab-selected');
        

        $('div.tab-control a').each(function()
        {

            $(this).click(function(){

                if ($(this).attr('id') == currentTab.attr('id'))
                {
                    return false;
                }
                else
                {
                    currentTab.toggleClass('tab-selected');
                    currentTab = $(this);
                    currentTab.toggleClass('tab-selected');
                }

                if (currentTab.attr('id') == 'chartHeader')
                {
                    $('#chart').removeClass('hide')
                    $('#xml').addClass('hide');
                }
                else
                {
                   $('#chart').addClass('hide')
                    $('#xml').removeClass('hide');
                }

            })

        })


    })

    function request(paras)
    { 
        var url = location.href; 
        var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
        var paraObj = {};

        for (i=0; j=paraString[i]; i++)
        { 
            paraObj[j.substring(0,j.indexOf("="))] = j.substring(j.indexOf("=")+1,j.length); 
        } 

        var returnValue = paraObj[paras.toLowerCase()]; 

        if(typeof(returnValue)=="undefined")
        { 
            return ""; 
        }
        else
        { 
            return returnValue; 
        } 
    }


})()
    