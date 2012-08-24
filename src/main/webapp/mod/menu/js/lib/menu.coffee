MenuView = Backbone.View.extend
	
	initialize: ->
		
		# If only 1 module, redirect to that module
		mods = _.without(FestivalConfig.modules, 'menu')
		
		if mods.length == 1 then $.mobile.changePage('../' + mods[0] + '/' + mods[0] + '.html') else @render()
	
	render: ->
		
		# Set the title
		@$('h1').text(FestivalLang.MenuView.title)
		
		# Create the menu
		modules = _.map(_.without(FestivalConfig.modules, 'menu'), (name) -> 
			url: '../' + name + '/' + name + '.html'
			title: FestivalLang.MenuView.module[name].title
			desc: FestivalLang.MenuView.module[name].desc
		)
		
		template = _.template($("#menu-items-template").html(), modules: modules)
		
		@$('[data-role="content"] ul').html(template).listview('refresh')


$(document).bind('pageload', (event, data) -> new MenuView(el: $('#menu-page')) if /mod\/menu\/menu.html$/.test(data.url))