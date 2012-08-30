class window.Festival
	
	@init: ->
		
		# Setting default page transition to slide
		$.mobile.defaultPageTransition = 'slide'
		
		$.mobile.buttonMarkup.hoverDelay = 100
		
		head = $('head')
		
		scripts = []
		
		for module in FestivalConfig.modules
			
			cssPath = 'mod/' + module + '/css/' + module + '.min.css?' + FestivalConfig.version
			jsPath = 'mod/' + module + '/js/' + module + '.min.js?' + FestivalConfig.version
			
			# Default module styles
			head.append('<link rel="stylesheet" href="' + cssPath + '" />')
			
			# Allows festival to override module styles if necessary
			head.append('<link rel="stylesheet" href="festival/' + FestivalConfig.id + '/' + cssPath + '" />')
			
			# Default module script
			scripts.push(jsPath)
			
			# Allows festival to override module script if necessary
			scripts.push('festival/' + FestivalConfig.id + '/' + jsPath)
		
		scripts.push('festival/' + FestivalConfig.id + '/js/lang.' + @lang + '.min.js?' + FestivalConfig.version)
		
		scriptsLoaded = 0
		
		onScriptLoaded = ->
			scriptsLoaded++
			# When all scripts are loaded, show the menu page using the fade in transition
			if(scriptsLoaded == scripts.length) then Festival.changePage('menu', null, null, transition: 'fade')
		
		for script in scripts
			@loadCachedScript(
				script
				statusCode:
					200: onScriptLoaded
					404: onScriptLoaded
			)
		
		# Prevent double call
		@init = null
	
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
	# @private
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
		
		@cbCounter++
		
		@loadCachedScript('http://maps.google.com/maps/api/js?libraries=geometry&sensor=false&callback=Festival.' + cbName, options)
	
	# Alias the backbone localstorage Store object here so we can easily replace if necessary 
	@Store: window.Store
	
	# TODO: Lang code based on browser locale
	@lang: 'en-GB'
	
	# @private
	@knownPages: []
	
	@rootUrl: window.location.href.replace('index.html', '')
	
	###
	Get a page URL taking into account localization and festival specific overrides.
	
	For festival named "fest", module named "foo", page named "bar" and language en-GB, the following URLs will be considered:
	
	1. /festival/fest/mod/foo/bar.en-GB.html
	2. /mod/foo/bar.en-GB.html
	3. /mod/foo/bar.html
	
	@param {String} module Name of the module the page belongs to
	@param {String} [page] Name of the module page (without the .html suffix), assumed <module>.html if not set.
	@param {Function} callback Callback function passed the page URL when it is determined
	###
	@pageUrl: (module, page = '', callback) -> 
		
		if page is '' then page = module
		
		# URLs to be considered
		urls = [
			@rootUrl + 'festival/' + FestivalConfig.id + '/mod/' + module + '/' + page + '.' + @lang + '.html',
			@rootUrl + 'mod/' + module + '/' + page + '.' + @lang + '.html',
			@rootUrl + 'mod/' + module + '/' + page + '.html'
		]
		
		for url in urls
			if _.indexOf(@knownPages, url) isnt -1
				callback(url)
				return
		
		$.ajax
			cache: true
			url: urls[0]
			statusCode:
				200: =>
					@knownPages.push(urls[0])
					callback(urls[0])
				404: =>
					$.ajax
						cache: true
						url: urls[1]
						statusCode:
							200: =>
								@knownPages.push(urls[1])
								callback(urls[1])
							404: =>
								$.ajax
									cache: true
									url: urls[2]
									statusCode:
										200: =>
											@knownPages.push(urls[2])
											callback(urls[2])
										404: -> console.error(page + ' not found for module ' + module + '. URLs considered: ' + urls)
	
	###
	Change to a different module page taking into account localization and festival specific overrides.
	
	For festival named "fest", module named "foo", page named "bar" and language detected to be en-GB, the following URLs will be considered:
	
	1. /festival/fest/mod/foo/bar.en-GB.html
	2. /mod/foo/bar.en-GB.html
	3. /mod/foo/bar.html
	
	@param {String} module Name of the module the page belongs to
	@param {String} [page] Name of the module page (without the .html suffix), assumed <module>.html if not set.
	@param {String} [suffix] The URL suffix (querystring or hash part)
	@param {Object} [changePageOpts] Options for the $.mobile.changePage function
	###
	@changePage: (module, page = '', suffix = '', changePageOpts = {}) -> 
		@pageUrl(module, page, (url) -> $.mobile.changePage(url + suffix, changePageOpts))
