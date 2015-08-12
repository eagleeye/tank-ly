roomId = window.roomId

$ ->
	$.getJSON "/joinroom/#{roomId}", (res) ->
		console.info('Joined room', res);
		startSession(res)

startSession = (gameInfo) ->
	console.log 'session started', gameInfo
	$('.color').css('background-color', gameInfo.color)
	emit = (e, eventName, data = {}) ->
		data.tankId = gameInfo.tankId
		data.roomId = roomId
		socket.emit(eventName, data)
#		console.log "emiting event", eventName, data
	socket = io.connect(window.location.origin);
	socket.on 'connect', ->
		emit null, 'connected'
		console.log 'connected'
		setInterval ->
			emit null, 'fire'
			emit null, 'move', direction: Math.random() * 360
		, 200

	socket.on 'scoreUpdated', (data) ->
		$('.color').html(data.score)
		console.log('scoreUpdated', data)
	window.socket = socket
