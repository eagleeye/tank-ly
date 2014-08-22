fs = require("fs")
express = require('express')
_ = require("lodash")
favicon = require('serve-favicon')
app = express()
app.use(favicon('./client/img/favicon.png'))
app.set('views', './views')
app.set('view engine', 'jade')
app.use(express.static('./client'))
http = require 'http'
server = http.createServer(app)
io = require('socket.io').listen(server)
port = process.env.PORT || 5000
server.listen(port)
console.log('server started')
rooms = {}

app.get '/', (req, res) ->
	res.render 'home'

io.sockets.on 'connection', (socket) ->
	console.log 'new connection'
	socket.on 'master', (data) ->
		console.log 'master connected', data
		getRooom(data.roomId).masterSocket = socket
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

getRoom = (id) ->
	if not rooms[id]
		rooms[id] = master: {}, sockets: {}
	rooms[id]