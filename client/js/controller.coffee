$ ->
	socket = io.connect(window.location.origin);
	socket.on 'move', (data) ->
		console.log('move', data);

	$('body').click ->
		socket.emit('move', { my: 'data' })

	document.body.addEventListener 'touchstart',(e) ->
		socket.emit('move', { my: 'data' })
		e.preventDefault()