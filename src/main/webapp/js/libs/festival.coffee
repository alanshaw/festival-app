class @Festival
	
	###
	Get and execute a script, using cached version if available.
	
	@param {String} url The URL to fetch
	@param {Object} options $.ajax options
	@return jqXHR
	###
	getCachedScript: (url, options) ->
		
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
	getGoogleMapsScript: (options) ->
		
		cbName = 'getGoogleMapsScriptCallback' + cbCounter
		onSuccess = if options then options.success else null
		
		Festival[cbName] = ->
			delete Festival[cbName]
			if(onSuccess) then onSuccess()
		
		if(onSuccess) then options.success = null
		
		Festival.cbCounter++;
		
		@getCachedScript('http://maps.google.com/maps/api/js?sensor=false&callback=festival.' + cbName, options);