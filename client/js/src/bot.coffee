roomId = window.roomId
socket = null
gameInfo = {}

$ ->
	$.getJSON "/joinroom/#{roomId}", (res) ->
		console.info('Joined room', res);
		startSession(res)

startSession = (_gameInfo) ->
	gameInfo = _gameInfo
	console.log 'session started', gameInfo
	$('.color').css('background-color', gameInfo.color)

#		console.log "emiting event", eventName, data
	socket = io.connect(window.location.origin);
	socket.on 'connect', ->
		emit null, 'connected'
		console.log 'connected'


	socket.on 'scoreUpdated', (data) ->
		$('.color').html(data.score)
		console.log('scoreUpdated', data)
	socket.on 'died', (data) ->
		navigator.vibrate?("600")
	window.socket = socket

emit = (e, eventName, data = {}) ->
	data.tankId = gameInfo.tankId
	data.roomId = roomId
	socket?.emit(eventName, data)

setInterval ->
	emit null, 'fire'
	emit null, 'move', direction: Math.random() * 360
, 200