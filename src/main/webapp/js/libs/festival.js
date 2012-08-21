(function($) {
	
	window.Festival = window.Festival || {};

	/**
	 * Get and execute a script, using cached version if available.
	 * 
	 * @param {String} url The URL to fetch
	 * @param {Object} options $.ajax options
	 * @return jqXHR
	 */
	Festival.getCachedScript = function(url, options) {
		
		// allow user to set any option except for dataType, cache, and url
		options = $.extend(options || {}, {
			dataType: 'script',
			cache: true,
			url: url
		});
		
	  // Use $.ajax() since it is more flexible than $.getScript
	  // Return the jqXHR object so we can chain callbacks
	  return $.ajax(options);
	};
	
	// Allows us to create unique names for our JSONP callbacks
	var cbCounter = 0;
	
	/**
	 * Get and execute the google maps API script, using cached version if available.
	 * 
	 * @param {Object} options $.ajax options
	 * @return jqXHR
	 */
	Festival.getGoogleMapsScript = function(options) {
		
		var cbName = 'getGoogleMapsScriptCallback' + cbCounter,
			onSuccess = options ? options.success : null;
		
		Festival[cbName] = function() {
			delete Festival[cbName];
			if(onSuccess) onSuccess();
		};
		
		if(onSuccess) options.success = null;
		
		cbCounter++;
		
		return Festival.getCachedScript('http://maps.google.com/maps/api/js?sensor=false&callback=festival.' + cbName, options);
	};
	
})(jQuery);