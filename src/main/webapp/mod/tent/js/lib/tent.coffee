TentView = Backbone.View.extend
	
	watchId: null
	
	initialize: ->
		
		console?.log('Initializing TentView')
		
		$(@el)
			.bind('pageshow', => @render())
			.bind('beforepagehide', => navigator.geolocation.clearWatch(@watchId))
	
	render: ->
		
		console?.log('Rendering TentView')
		
		$.mobile.showPageLoadingMsg()
		
		# Hide the back button if there is only 1 module
		if(FestivalConfig.modules.length == 1) then @$('[data-role="header"] a').first().hide()
		
		# Set the title
		@$('h1').text(FestivalLang.TentView.title)
		
		Festival.loadGoogleMapsScript(
			success: => 
				
				# Resize the map to the screen height
				@$("#tent-map").height($(@el).height())
				
				latlng = new google.maps.LatLng(FestivalConfig.position.coords.latitude, FestivalConfig.position.coords.longitude)
				
				map = new google.maps.Map(@$("#tent-map")[0],
					zoom: 16,
					center: latlng,
					mapTypeId: google.maps.MapTypeId.ROADMAP
					navigationControl: false,
					scaleControl: false,
					streetViewControl: false,
					mapTypeControl: true
				)
				
				marker = new google.maps.Marker(
					map: map
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
				
				mapCentred = false
				
				@watchId = navigator.geolocation.watchPosition((position) ->
					
					latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
					
					if(!mapCentred)
						map.setCenter(latlng)
						mapCentred = true
					
					marker.setPosition(latlng)
				)
				
				$.mobile.hidePageLoadingMsg()
				
			error: -> 
				$.mobile.hidePageLoadingMsg()
				alert 'Failed to load Google Map'
		)

Location = Backbone.Model.extend
	
	defaults:
		key: ''
		name: ''
		latitude: 0
		longitude: 0
	
	validate: (attributes) -> return FestivalLang.Location.validate.key if not attributes.key? or attributes.key == ''


$(document).bind('pageload', (event, data) -> new TentView(el: $('#tent-page')) if /mod\/tent\/tent.html$/.test(data.url))