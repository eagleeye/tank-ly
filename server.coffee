fs = require("fs")
express = require('express')
_ = require("lodash")
app = express()
app.use(express.static(__dirname + '/client'))
http = require 'http'
server = http.createServer(app)
io = require('socket.io').listen(server)
server.listen(3000)

io.sockets.on 'connection', (socket) ->
	console.log 'userConnected'
	io.sockets.emit('userConnected')
	socket.on 'move', (data) ->
		console.log 'move event', data
		io.sockets.emit "move", data
	socket.on 'disconnect', ->
		console.log 'userDisconnected'
		io.sockets.emit('userDisconnected')