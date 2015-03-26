touchStartEvent = 'touchstart'
touchMoveEvent = 'touchstart touchmove'
touchStopEvent = 'touchend'
touchMoveEvent = 'mousedown'
touchStartEvent = 'mousedown'
touchStopEvent = 'mouseup'

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
		e?.preventDefault?()
		console.log "emiting event", eventName, data
	socket = io.connect(window.location.origin);
	socket.on 'connect', ->
		emit null, 'connected'
		console.log 'connected'
#	socket.on 'connected', (data) ->
#		console.log('connected', data)
#	socket.on 'move', (data) ->
#		console.log('move', data)
#	socket.on 'fire', (data) ->
#		console.log('fire', data)
#	socket.on 'stop', (data) ->
#		console.log('stop', data)
	socket.on 'scoreUpdated', (data) ->
		$('.color').html(data.score)
		console.log('scoreUpdated', data)

	$('.right-control').on touchStartEvent, (e) ->
		emit e, 'fire'
	.on "#{touchMoveEvent} #{touchStopEvent}", (e) ->
		e.preventDefault()

	$left = $('.left-control')

	$left.on touchStopEvent, (e) ->
		emit e, 'stop'

	$left.on touchMoveEvent, (e) ->
		touch = event.touches?[0]
		y = e.offsetY || touch?.pageY
		x = e.offsetX || touch?.pageX
		angle = Math.atan2(0.5 * $left.height() - y, x - 0.5 * $left.width())
		emit e, 'move', direction: angle * 180 / Math.PI
