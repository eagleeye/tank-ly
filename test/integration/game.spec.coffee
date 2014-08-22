io = require 'socket.io-client'

describe 'create room', ->
	socket = null
	roomId = null

	before (done) ->
		socket = io.connect 'localhost:5000'
		socket.emit 'createRoom'
		socket.on 'roomCreated', (data) ->
			roomId = data.roomId
			done()

		it 'should return roomId', ->
			expect(roomId).to.be.ok

		describe 'connect to the room', ->
			before (done) ->
				socket.emit 'joinRoom'


