MenuView = Backbone.View.extend
	initialize: -> 
		@render()
	render: ->
		
		# Load theme and module CSS
		Festival.loadCss()
		
		# Set the title
		$('h1', @el).text(FestivalLang.menu.title)
		
		# Create the menu
		modules = _.map(FestivalConfig.modules, (name) -> 
			url: '../' + name + '/' + name + '.html'
			title: FestivalLang.menu.module[name].title
			desc: FestivalLang.menu.module[name].desc
		)
		
		template = _.template($("#menu-items-template").html(), modules: modules)
		
		$('[data-role="content"] ul', @el).html(template).listview('refresh')

$(document).bind("deviceready", -> 
	
	# If only 1 module, redirect to that module
	mods = FestivalConfig.modules
	if mods.length == 1 then window.location.href = '../' + mods[0] + '/' + mods[0] + '.html'
	
	# Load language
	Festival.loadLang( ->
		# Render view
		view = new MenuView(el: $('[data-role="page"]'))
	)
);