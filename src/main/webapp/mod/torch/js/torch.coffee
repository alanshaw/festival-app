TorchView = Backbone.View.extend
	initialize: ->
		
		@$el
			.one('pageshow', => @render())
			.bind('pageshow', @turnOn)
			.bind('pagehide', @turnOff)
	
	render: ->
		
		$.mobile.showPageLoadingMsg()
		
		backBtn = @$('[data-role="header"] [data-rel="back"]')
		
		$('.ui-btn-text', backBtn).text(FestivalLang.TorchView.btn.back)
		
		Festival.pageUrl('menu', null, (url) -> backBtn.attr('href', url))
		
		# Set the title
		@$('h1').text(FestivalLang.TorchView.title)
		
		$.mobile.hidePageLoadingMsg()
	
	turnOn: ->
		try
			window.plugins?.torch?.turnOn?.call(@)
		catch ex
			console.error(ex)
	
	turnOff: ->
		try
			window.plugins?.torch?.turnOff?.call(@)
		catch ex
			console.error(ex)

# Load the torch plugin dependency (to allow callback to iOS/Android)
$.getScript('mod/torch/js/lib/Torch.plugin.min.js', -> Torch.install())

$(document).bind('pageload', (event, data) -> new TorchView(el: $('#torch-page')) if /mod\/torch\/torch.html$/.test(data.url))