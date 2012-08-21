/** 
 * Main configuration for the festival app
 * 
 * This file is filtered by maven i.e. you can use ${propertyName} to reference properties in the POM.
 */
var Config = {
	id: '${festivalId}',
	modules: '${festivalModules}'.split(',')
};