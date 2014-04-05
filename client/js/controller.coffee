clientId = Math.random().toString().split('.')[1];
$ ->
	socket = io.connect(window.location.origin);
	socket.on 'connect', ->
		console.log('connected');
	socket.on 'move', (data) ->
		console.log('move', data);
	socket.on 'fire', (data) ->
		console.log('fire', data);

	$('.right-control').on 'touchstart', (e) ->
		socket.emit('fire', clientId: clientId)
		e.preventDefault()

	$('.left-control').on 'touchstart', (e) ->
		socket.emit('move', clientId: clientId)
		e.preventDefault()
