io = require 'socket.io-client'
request = require 'request'

describe 'create room', ->
#	socket = null
	roomId = null
	resp = null

	before (done) ->
		request.put 'http://localhost:5000/createroom', json: yes, (err, _resp, body) ->
			roomId = body and body.roomId
			resp = _resp
			done(err)

	it 'should return roomId', ->
		expect(roomId).to.be.ok

	describe 'connect to the room', ->
		playerInfo = null
		before (done) ->
			request.get 'http://localhost:5000/joinRoom/' + roomId, json: yes, (err, _resp, body) ->
				playerInfo = body
				resp = _resp
				done(err)
		it 'should return status 200', ->
			expect(resp.statusCode).to.be.eql(200)
		it 'should have color', ->
			expect(playerInfo).to.have.property('color').to.be.ok
		it 'should have tankId', ->
			expect(playerInfo).to.have.property('tankId').to.be.ok

#		describe 'send '
#		before (done) ->
#			socket = io.connect 'localhost:5000'
#			socket.emit 'fire'
#		it('should')


