SurvivalView = Backbone.View.extend
	
	initialize: ->
		
		@$el.one('pageshow', => @render())
	
	render: ->
		
		$.mobile.showPageLoadingMsg()
		
		backBtn = @$('[data-role="header"] [data-rel="back"]')
		
		# Set the back button title
		$('.ui-btn-text', backBtn).text(FestivalLang.SurvivalView.btn.back)
		
		# Set the correct page URL for the back button
		Festival.pageUrl('menu', null, (url) -> backBtn.attr('href', url))
		
		# Set the title
		@$('h1').text(FestivalLang.SurvivalView.title)
		
		$.mobile.hidePageLoadingMsg()

$(document).bind('pageload', (event, data) -> new SurvivalView(el: $('#survival-page')) if /mod\/survival\/survival.html$/.test(data.url))