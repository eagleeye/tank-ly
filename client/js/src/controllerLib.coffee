fullScreenById = (id) ->
	elem = document.getElementById(id);
	if elem.requestFullscreen
		elem.requestFullscreen()
	else if elem.msRequestFullscreen
		elem.msRequestFullscreen()
	else if elem.mozRequestFullScreen
		elem.mozRequestFullScreen()
	else if elem.webkitRequestFullscreen
		elem.webkitRequestFullscreen()

canFullScreen = (id) ->
	elem = document.getElementById(id);
	elem.requestFullscreen || elem.msRequestFullscreen || elem.mozRequestFullScreen || elem.webkitRequestFullscreen

$ ->
	if canFullScreen('container')
		$('.enter-fullscreen').show().click ->
			fullScreenById('container')