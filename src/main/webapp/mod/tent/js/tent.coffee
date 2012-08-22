TentView = Backbone.View.extend
	render: ->
		
		# Set the title
		$('h1', @el).text(FestivalLang.tent.title)
		
		Festival.loadGoogleMapsScript(
			success: -> 
				
				latlng = new google.maps.LatLng(FestivalConfig.position.coords.latitude, FestivalConfig.position.coords.longitude)
				
				mapOpts =
					zoom: 16,
					center: latlng,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				
				map = new google.maps.Map($("#tent-map")[0], mapOpts)
				
				
				
				navigator.geolocation.getCurrentPosition((position) ->
					
					latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
					
					map.setCenter(latlng)
				)
				
			error: ->
				alert 'Failed to load Google Map'
		)

$('#tent-page').bind('pageshow', -> 
	$('#tent-page').css('height', '100%')
)

view = new TentView(el: $('#tent-page'))

view.render()