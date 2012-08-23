###
Main configuration for the festival app

This file is filtered by maven i.e. you can use ${propertyName} to reference properties in the POM.
###
class window.FestivalConfig
	@version: '${project.version}'
	@id: '${festivalId}'
	@modules: '${festivalModules}'.split(',')
	@position: 
		coords:
			latitude: parseFloat('${festivalLatitude}')
			longitude: parseFloat('${festivalLongitude}')