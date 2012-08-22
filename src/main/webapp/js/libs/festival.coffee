class window.Festival
	
	@loadCss: (module) ->
		$('head').append('<link rel="stylesheet" href="festival/' + FestivalConfig.id + '/css/jquery.mobile-1.1.1.min.css" />')
		# TODO: Load module CSS and festival module CSS 
	
	@loadLang: (callback) ->
		@loadCachedScript('festival/' + FestivalConfig.id + '/js/lang.en-GB.min.js', success: callback)
	
	###
	Get and execute a script, using cached version if available.
	
	@param {String} url The URL to fetch
	@param {Object} options $.ajax options
	@return jqXHR
	###
	@loadCachedScript: (url, options) ->
		
		# allow user to set any option except for dataType, cache, and url
		options = $.extend(options || {}, 
			dataType: 'script'
			cache: true
			url: url
		)
		
		# Use $.ajax() since it is more flexible than $.getScript
		# Return the jqXHR object so we can chain callbacks
		$.ajax(options)
	
	# Allows us to create unique names for our JSONP callbacks
	@cbCounter: 0
	
	###
	Get and execute the google maps API script, using cached version if available.
	
	@param {Object} options $.ajax options
	@return jqXHR
	###
	@loadGoogleMapsScript: (options) ->
		
		cbName = 'getGoogleMapsScriptCallback' + @cbCounter
		onSuccess = if options then options.success else null
		
		Festival[cbName] = ->
			delete Festival[cbName]
			if(onSuccess) then onSuccess()
		
		if(onSuccess) then options.success = null
		
		@cbCounter++;
		
		@loadCachedScript('http://maps.google.com/maps/api/js?sensor=false&callback=Festival.' + cbName, options);