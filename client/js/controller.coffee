clientId = Math.random().toString().split('.')[1];
touchMoveEvent = 'touchstart touchmove'
touchStopEvent = 'touchend'
#touchMoveEvent = 'mousedown'
#touchStopEvent = 'mouseup'

$ ->
	emit = (e, eventName, params = {}) ->
		params.clientId = clientId;
		socket.emit(eventName, params)
		e?.preventDefault?()
	socket = io.connect(window.location.origin);
	socket.on 'connect', ->
		emit null, 'connected'
#	socket.on 'connected', (data) ->
#		console.log('connected', data)
#	socket.on 'move', (data) ->
#		console.log('move', data)
#	socket.on 'fire', (data) ->
#		console.log('fire', data)
#	socket.on 'stop', (data) ->
#		console.log('stop', data)
	socket.on 'colorAssigned', (data) ->
		if data.clientId is clientId
			$('.color').css('background-color', data.color)
#		console.log('colorAssigned', data)

	socket.on 'scoreUpdated', (data) ->
		if data.clientId is clientId
			$('.color').html(data.score.toString())

	$('.right-control').on 'touchstart', (e) ->
		emit e, 'fire'

	$left = $('.left-control')

	$left.on touchStopEvent, (e) ->
		emit e, 'stop'

	$left.on touchMoveEvent, (e) ->
		touch = event.touches?[0]
		y = e.offsetY || touch.pageY
		x = e.offsetX || touch.pageX
		angle = Math.atan2(0.5 * $left.height() - y, x - 0.5 * $left.width())
		emit e, 'move', direction: angle * 180 / Math.PI
