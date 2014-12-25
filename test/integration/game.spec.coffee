io = require 'socket.io-client'
request = require 'request'

describe 'create room', ->
#	socket = null
	roomId = null
	resp = null
	playerInfo = null

	before (done) ->
		request.put 'http://localhost:5000/createroom', json: yes, (err, _resp, body) ->
			roomId = body and body.roomId
			resp = _resp
			done(err)

	it 'should return roomId', ->
		expect(roomId).to.be.ok

	it 'should status code 200', ->
		expect(resp.statusCode).to.eql(200)

	describe 'get list of available rooms', ->
		before (done) ->
			request.get 'http://localhost:5000/rooms', json: yes, (err, _resp) ->
				resp = _resp
				done(err)
		it 'should status code 200', ->
			expect(resp.statusCode).to.eql(200)
		it 'should return list of rooms', ->
			expect(resp.body).to.be.an('array').to.have.length(1)

	describe 'connect to the room', ->
		playerInfo = null
		before (done) ->
			request.get "http://localhost:5000/joinroom/#{roomId}", json: yes, (err, _resp, body) ->
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


