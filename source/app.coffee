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
uuid = require 'node-uuid'
console.log("server started on port #{} http://localhost:#{port}")
rooms = {}
for roomId in [1..10]
	rooms[roomId] = host: {}, tanks: {}
colors = "green aqua blue black red yellow".split(" ")

app.get '/', (req, res) ->
	res.render 'home'

app.get '/m/:roomId', (req, res) ->
	res.render 'controller', {roomId: roomId}

app.get '/joinroom/:roomId', (req, res) ->
	roomId = req.params.roomid
	if not rooms[roomId]
		return res.status(404).send({error: 'Internal server error'})
	tankId = uuid.v4()
	rooms[roomId].tanks[tankId] = color: _.sample(colors), tankId: tankId
	res.json rooms[roomId].tanks[tankId]

app.get '/hostroom/:roomId', (req, res) ->
	roomId = req.params.roomId
	if not rooms[roomId]
		return res.status(404).send({error: "Room #{roomId} not found"})
	res.render 'host', {roomId: roomId}

app.get '/rooms', (req, res) ->
	res.json rooms

app.use (err, req, res, next) ->
	console.error('Uncaught error', err)
	res.status(500).send({error: 'Internal server error'})

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
