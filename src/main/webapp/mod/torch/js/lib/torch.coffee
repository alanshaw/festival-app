TorchView = Backbone.View.extend
	initialize: ->
		
		@$el
			.one('pageshow', => @render())
			.bind('pageshow', @turnOn)
			.bind('pagebeforehide', @turnOff)
	
	render: ->
		
		$.mobile.showPageLoadingMsg()
		
		backBtn = @$('[data-role="header"] [data-rel="back"]')
		
		$('.ui-btn-text', backBtn).text(FestivalLang.TorchView.btn.back)
		
		# Set the title
		@$('h1').text(FestivalLang.TorchView.title)
		
		$.mobile.hidePageLoadingMsg()
	
	turnOn: ->
		try
			window.plugins?.torch?.turnOn?.call(@)
		catch ex
			alert ex
	
	turnOff: ->
		try
			window.plugins?.torch?.turnOff?.call(@)
		catch ex
			alert ex

# Load the torch plugin dependency (to allow callback to iOS/Android)
$.getScript('mod/torch/js/lib/Torch.plugin.min.js', -> Torch.install())

$(document).bind('pageload', (event, data) -> new TorchView(el: $('#torch-page')) if /mod\/torch\/torch.html$/.test(data.url))