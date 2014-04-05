clientId = Math.random().toString().split('.')[1];
touchStartEvent = 'touchstart touchmove'
#touchStartEvent = 'mousedown'
touchStopEvent = 'touchend'
#touchStopEvent = 'mouseup'

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

	$('.right-control').on 'touchstart', (e) ->
		emit e, 'fire'
	$('.left-control').on touchStopEvent, (e) ->
		emit e, 'stop'

	$left = $('.left-control')
	$left.on touchStartEvent, (e) ->
		touch = event.touches?[0]
		y = e.offsetY || touch.pageY
		x = e.offsetX || touch.pageXs
		angle = Math.atan2(0.5 * $left.height() - y, x - 0.5 * $left.width())
		emit e, 'move', direction: angle * 180 / Math.PI