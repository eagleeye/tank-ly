$ ->
	alert 'hi'
	document.body.addEventListener 'touchstart',(e) ->
		e.preventDefault()