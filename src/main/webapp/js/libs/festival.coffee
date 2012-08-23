class window.Festival
	
	@loadCss: ->
		head = $('head')
		
		head.append('<link rel="stylesheet" href="festival/' + FestivalConfig.id + '/css/jquery.mobile-1.1.1.min.css?' + FestivalConfig.version + '" />')
		
		_.each(FestivalConfig.modules, (module) ->
			
			path = 'mod/' + module + '/css/' + module + '.min.css?' + FestivalConfig.version
			
			# Default module styles
			head.append('<link rel="stylesheet" href="' + path + '" />')
			
			# Allows festival to override module styles if necessary
			head.append('<link rel="stylesheet" href="festival/' + path + '" />')
		)
	
	@loadLang: (callback) ->
		# TODO: Load lang based on browser locale
		@loadCachedScript('festival/' + FestivalConfig.id + '/js/lang.en-GB.min.js?' + FestivalConfig.version, success: callback)
	
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
	@return jqXHR or null if the script has already been loaded
	###
	@loadGoogleMapsScript: (options) ->
		
		cbName = 'getGoogleMapsScriptCallback' + @cbCounter
		onSuccess = if options then options.success else null
		
		if window.google and window.google.maps 
			if(onSuccess) then onSuccess()
			return null
		
		Festival[cbName] = ->
			delete Festival[cbName]
			if(onSuccess) then onSuccess()
		
		if(onSuccess) then options.success = null
		
		@cbCounter++;
		
		@loadCachedScript('http://maps.google.com/maps/api/js?sensor=false&callback=Festival.' + cbName, options);