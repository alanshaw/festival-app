TentView = Backbone.View.extend
	
	watchId: null
	map: null
	tentLocationMarker: null
	userLocationMarker : null
	
	initialize: ->
		
		@$el
			.one('pageshow', => @render())
			.bind('pageshow', => @watchPosition())
			.bind('pagehide', => @onPageHide())
	
	render: ->
		
		$.mobile.showPageLoadingMsg()
		
		backBtn = @$('[data-role="header"] [data-rel="back"]')
		
		# Hide the back button if there is only 1 module
		if(_.without(FestivalConfig.modules, 'menu').length == 1) then backBtn.hide() else $('.ui-btn-text', backBtn).text(FestivalLang.TentView.btn.back)
		
		# Set the title
		@$('h1').text(FestivalLang.TentView.title)
		
		Festival.loadGoogleMapsScript(
			success: => 
				
				# Resize the map to the screen height
				@$("#tent-map").height(@$el.height())
				
				latlng = new google.maps.LatLng(FestivalConfig.position.coords.latitude, FestivalConfig.position.coords.longitude)
				
				@map = new google.maps.Map(@$("#tent-map")[0],
					zoom: 16,
					center: latlng,
					mapTypeId: google.maps.MapTypeId.ROADMAP
					navigationControl: false,
					scaleControl: false,
					streetViewControl: false,
					mapTypeControl: true
				)
				
				@userLocationMarker = new google.maps.Marker(
					map: @map
					position: latlng
					title: 'tent-map-bluedot', # style hook to add pulsate
					icon: new google.maps.MarkerImage(
						'img/bluedot@2x.png',
						null, # size
						null, # origin
						new google.maps.Point(8, 8), # anchor (move to center of marker)
						new google.maps.Size(17, 17) # scaled size (required for Retina display icon)
					),
					optimized: false
				)
				
				# Load the user's tent location from storage
				tentLocation = new Location(id: 'tent')
				
				# Create 'Set location' button
				saveBtn = $('<a href="#" data-icon="home" class="ui-btn-right"/>')
					.text(FestivalLang.TentView.btn.save)
					.bind('tap', =>
						
						tentLocation
							.set('name', FestivalLang.TentView.tentLocation.name)
							.set('latitude', @userLocationMarker.getPosition().lat())
							.set('longitude', @userLocationMarker.getPosition().lng())
							.save()
						
						@addTentLocation(tentLocation, @map)
						
						$('.ui-btn-text', saveBtn).text(FestivalLang.TentView.btn.relocate)
					)
					.appendTo(@$('[data-role="header"]'))
					.button()
				
				tentLocation.fetch
					success: =>
						$('.ui-btn-text', saveBtn).text(FestivalLang.TentView.btn.relocate)
						@addTentLocation(tentLocation, @map)
				
				$.mobile.hidePageLoadingMsg()
				
			error: -> 
				$.mobile.hidePageLoadingMsg()
				alert 'Failed to load Google Map'
		)
	
	###
	Adds the tent location to the map by adding a google.maps.Marker.
	Also removes the old marker if there is one
	
	@param {Location} location The location at which to add the tent
	###
	addTentLocation: (location) ->
		
		@tentLocationMarker?.setMap(null)
		
		# TODO: Detect if image exists in festival theme directory and use fallback if not
		@tentLocationMarker = new google.maps.Marker
			map: @map
			position: new google.maps.LatLng(location.get('latitude'), location.get('longitude'))
			title: location.get('name')
			# http://mapicons.nicolasmollet.com/markers/tourism/camping/
			icon: new google.maps.MarkerImage(
				'../../festival/' + FestivalConfig.id + '/mod/tent/img/icon-tent@2x.png',
				null, # size
				null, # origin
				null, # anchor (move to center of marker)
				new google.maps.Size(32, 37) # scaled size (required for Retina display icon)
			)
	
	###
	Starts watching the user's position (centres the map on the first located position)
	###
	watchPosition: -> 
		
		mapCentred = false
		
		@watchId = navigator.geolocation.watchPosition((position) =>
			
			latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
			
			if(!mapCentred)
				@map.setCenter(latlng)
				mapCentred = true
			
			@userLocationMarker.setPosition(latlng)
		)
	
	onPageHide: ->
		
		navigator.geolocation.clearWatch(@watchId)
		
		# If the page is not being cached in the DOM then clean up
		if(!@$el.is('[data-dom-cache="true"]'))
			
			console?.log('Cleaning up Google map')
			
			@tentLocationMarker?.setMap(null)
			@tentLocationMarker = null
			
			@userLocationMarker?.setMap(null)
			@userLocationMarker = null
			
			@map = null


Location = Backbone.Model.extend
	
	store: new Festival.Store('location')
	
	defaults:
		name: ''
		latitude: 0
		longitude: 0
	
	validate: (attributes) -> return FestivalLang.Location.validate.id if not attributes.id? or attributes.id == ''


$(document).bind('pageload', (event, data) -> new TentView(el: $('#tent-page')) if /mod\/tent\/tent.html$/.test(data.url))