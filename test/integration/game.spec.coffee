io = require 'socket.io-client'
request = require 'request'

describe 'game tests', ->
#	socket = null
	resp = null
	playerInfo = null

	describe 'get list of available rooms', ->
		before (done) ->
			request.get 'http://localhost:5000/rooms', json: yes, (err, _resp) ->
				resp = _resp
				done(err)
		it 'should status code 200', ->
			expect(resp.statusCode, resp.body).to.eql(200)
		it 'should return object of rooms', ->
			expect(Object.keys(resp.body)).to.be.an('array').of.length(10)

	describe 'connect to the room #1', ->
		playerInfo = null
		before (done) ->
			request.get "http://localhost:5000/joinroom/1", json: yes, (err, _resp, body) ->
				playerInfo = body
				resp = _resp
				done(err)
		it 'should return status 200', ->
			expect(resp.statusCode, playerInfo).to.be.eql(200)
		it 'should have color', ->
			expect(playerInfo).to.have.property('color').to.be.ok
		it 'should have tankId', ->
			expect(playerInfo).to.have.property('tankId').to.be.ok

#		describe 'send '
#		before (done) ->
#			socket = io.connect 'localhost:5000'
#			socket.emit 'fire'
#		it('should')


