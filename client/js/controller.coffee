clientId = Math.random().toString().split('.')[1];
touchStartEvent = 'touchstart touchmove'
#touchStartEvent = 'mousedown'
touchStopEvent = 'touchend'
#touchStopEvent = 'mouseup'

lastMove = '';

$ ->
	emit = (e, eventName, params = {}) ->
		params.clientId = clientId;
		socket.emit(eventName, params)
		e?.preventDefault?()
	socket = io.connect(window.location.origin);
	socket.on 'connect', ->
		emit null, 'connected'
	socket.on 'connected', (data) ->
		console.log('connected', data)
	socket.on 'move', (data) ->
		console.log('move', data)
	socket.on 'fire', (data) ->
		console.log('fire', data)
	socket.on 'stop', (data) ->
		console.log('stop', data)

	$('.right-control').on touchStartEvent, (e) ->
		emit e, 'fire'
	$('.left-control').on touchStopEvent, (e) ->
		emit e, 'stop'

	$left = $('.left-control')
	$left.on touchStartEvent, (e) ->
		touch = event.touches[0]
		y = e.offsetY || touch.pageY
		x = e.offsetX || touch.pageX
		angle = Math.atan2( 0.5 * $left.height() - y, x - 0.5 * $left.width())
		direction = getDirection(angle)
		if direction isnt lastMove
			emit e, 'move', direction: direction
			lastMove = direction

getDirection = (angle) ->
	pi = Math.PI
	if pi * 0.25 < angle < pi * 0.75
		return 'top'
	if pi * 0.75 < angle or angle < -0.75 * pi
		return 'left'
	if pi * -0.25 > angle > pi * -0.75
		return 'bottom'
	if pi * - 0.75 > angle or angle < pi * 0.25
		return 'right'