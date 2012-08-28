TorchView = Backbone.View.extend
	initialize: ->
		
		@$el
			.one('pageshow', => @render())
			.bind('pageshow', @turnOn)
			.bind('beforepagehide', @turnOff)
	
	render: ->
		
		$.mobile.showPageLoadingMsg()
		
		backBtn = @$('[data-role="header"] [data-rel="back"]')
		
		$('.ui-btn-text', backBtn).text(FestivalLang.TorchView.btn.back)
		
		# Set the title
		@$('h1').text(FestivalLang.TorchView.title)
		
		$.mobile.hidePageLoadingMsg()
	
	turnOn: ->
		if(!window.plugins) then alert('no window.plugins') else alert('window.plugins')
		if(!cordova.exec) then alert('no cordova.exec') else alert('cordova.exec')
		window.plugins.torch.turnOn()
	
	turnOff: -> window.plugins.torch.turnOff()

$.getScript('js/libs/Torch.plugin.js')

$(document).bind('pageload', (event, data) -> new TorchView(el: $('#torch-page')) if /mod\/torch\/torch.html$/.test(data.url))