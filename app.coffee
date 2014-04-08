fs = require("fs")
express = require('express')
_ = require("lodash")
app = express()
app.use(express.static(__dirname + '/client'))
http = require 'http'
server = http.createServer(app)
io = require('socket.io').listen(server)
server.listen(3000)
masterSocket = null

io.sockets.on 'connection', (socket) ->
	socket.on 'master', ->
		console.log 'master connected'
		masterSocket = socket
	socket.on 'move', (data) ->
		console.log 'move event', data
		masterSocket?.emit "move", data
	socket.on 'stop', (data) ->
		console.log 'stop event', data
		masterSocket?.emit "stop", data
	socket.on 'fire', (data) ->
		console.log 'fire event', data
		masterSocket?.emit "fire", data
	socket.on 'colorAssigned', (data) ->
		console.log 'colorAssigned', data
		io.sockets.emit "colorAssigned", data
	socket.on 'scoreUpdated', (data) ->
		console.log 'scoreUpdated', data
		io.sockets.emit "scoreUpdated", data
	socket.on 'connected', (data) ->
		console.log 'new user connected', data
		masterSocket?.emit "connected", data
	socket.on 'disconnect', ->
		console.log 'userDisconnected'
		masterSocket?.emit('userDisconnected')