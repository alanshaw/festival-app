MenuView = Backbone.View.extend
	initialize: ->
		# If only 1 module, redirect to that module
		mods = FestivalConfig.modules
		if mods.length == 1 then $.mobile.changePage('../' + mods[0] + '/' + mods[0] + '.html')
	render: ->
		
		# Set the title
		@$('h1').text(FestivalLang.menu.title)
		
		# Create the menu
		modules = _.map(FestivalConfig.modules, (name) -> 
			url: '../' + name + '/' + name + '.html'
			title: FestivalLang.menu.module[name].title
			desc: FestivalLang.menu.module[name].desc
		)
		
		template = _.template($("#menu-items-template").html(), modules: modules)
		
		@$('[data-role="content"] ul').html(template).listview('refresh')

# Render view
new MenuView(el: $('#menu-page')).render()