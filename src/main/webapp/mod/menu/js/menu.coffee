MenuView = Backbone.View.extend
	render: ->
		
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


# If only 1 module, redirect to that module
mods = FestivalConfig.modules
if mods.length == 1 then window.location.href = '../' + mods[0] + '/' + mods[0] + '.html'

# Render view
view = new MenuView(el: $('#menu-page'))

view.render()