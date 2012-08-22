# Load theme CSS
# Load module CSS
# Load language
# Render view

MenuView = Backbone.View.extend
	initialize: -> 
		alert 'View initialized'
	render: ->
		template = _.template($("#menu-template").html())
		@el.html(template)


view = new MenuView(el: $('#menu-container'))

