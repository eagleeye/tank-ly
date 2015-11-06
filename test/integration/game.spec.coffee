hostIo = require 'socket.io-client'
clientIo = require 'socket.io-client'
request = require 'request'

describe 'game tests', ->
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

	describe 'get info of the room #1', ->
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

	describe 'connect server and client to the websocket server', ->
		hostSocket = null
		clientSocket = null

		before (done) ->
			hostSocket = hostIo.connect('http://localhost:5000', forceNew: yes)
			hostSocket.on 'connect', ->
				done()
			hostSocket.on 'connect_error', done
		before (done) ->
			clientSocket = clientIo.connect('http://localhost:5000', forceNew: yes)
			clientSocket.on 'connect', ->
				done()
			clientSocket.on 'connect_error', done
		it 'client socket should connect', ->
			expect(clientSocket.connected).to.be.eql true
		it 'host socket should connect', ->
			expect(hostSocket.connected).to.be.eql true


		describe 'send event from client to host', ->
			lastClientData = null

			before ->
				hostSocket.emit 'host', roomId: 1
			before ->
				clientSocket.emit 'connected', roomId: 1, tankId: 100500

			before (done) ->
				hostSocket.on 'fire', (data) ->
					lastClientData = data
					done()
				clientSocket.emit 'fire',
					roomId: 1
					tankId: 100500

			it 'should get event from client', ->
				expect(lastClientData).to.eql
					roomId: 1
					tankId: 100500

