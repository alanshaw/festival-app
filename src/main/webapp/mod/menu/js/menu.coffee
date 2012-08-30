MenuView = Backbone.View.extend
	
	initialize: ->
		
		# If only 1 module, redirect to that module
		mods = _.without(FestivalConfig.modules, 'menu')
		
		if mods.length == 1 then Festival.changePage(mods[0]) else @render()
	
	render: ->
		
		$.mobile.showPageLoadingMsg()
		
		# Set the title
		@$('h1').text(FestivalLang.MenuView.title)
		
		moduleNames = _.without(FestivalConfig.modules, 'menu')
		
		# Create the menu
		templateData = _.map(moduleNames, (name) -> 
			title: FestivalLang.MenuView.module[name].title
			desc: FestivalLang.MenuView.module[name].desc
		)
		
		template = _.template($("#menu-items-template").html(), modules: templateData)
		
		list = @$('[data-role="content"] ul')
		
		list.html(template).listview('refresh')
		
		# Set page URL for each of the modules
		$('a', list).each((i) -> Festival.pageUrl(moduleNames[i], null, (url) => $(@).attr('href', url)))
		
		$.mobile.hidePageLoadingMsg()


$(document).bind('pageload', (event, data) -> new MenuView(el: $('#menu-page')) if /mod\/menu\/menu.html$/.test(data.url))