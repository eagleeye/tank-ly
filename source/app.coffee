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
console.log("Server started on port #{port} http://localhost:#{port}")
rooms = {}
for roomId in [1..10]
	rooms[roomId] = host: {}, tanks: {}
colors = "green aqua blue black red yellow".split(" ")

app.get '/', (req, res) ->
	res.render 'home'

app.get '/m/:roomId', (req, res) ->
	res.render 'controller', {roomId: roomId}

app.get '/joinroom/:roomId', (req, res) ->
	roomId = req.params.roomId
	if not rooms[roomId]
		return res.status(404).send({error: "Room #{roomId} not found"})
	tankId = uuid.v4()
	rooms[roomId].tanks[tankId] = color: _.sample(colors), tankId: tankId
	res.json rooms[roomId].tanks[tankId]

app.get '/hostroom/:roomId', (req, res) ->
	roomId = req.params.roomId
	if not rooms[roomId]
		return res.status(404).send({error: "Room #{roomId} not found"})
	res.render 'host', {roomId: roomId}

app.get '/rooms', (req, res) ->
	roomsJson = {}
	for roomId, room of rooms
		roomsJson[roomId] =
			host: {socket: !!room.host.socket}
			tanks: Object.keys(room.tanks).length
	res.json roomsJson

app.use (err, req, res, next) ->
	console.error('Uncaught error', err)
	res.status(500).send({error: 'Internal server error', code: err.name, stack: err?.stack})

validateRoomId = (data) ->
	if not data or not data.roomId or not rooms[data.roomId]
		console.error "room with id #{data?.roomid} not found"
		no
	else yes

io.sockets.on 'connection', (socket) ->
	console.log 'new connection'
	socket.on 'host', (data) ->
		console.log 'host connected', data
		if not validateRoomId(data) then return
		rooms[data.roomId].host.socket = socket

	controllerEvents = "move stop fire connected".split ' '
	for event in controllerEvents
		socket.on event, (data) ->
			console.log "#{event} event received", data
			if not validateRoomId(data) then return
			rooms[data.roomId].host.socket?.emit "move", data

	hostEvents = "colorAssigned scoreUpdated".split ' '
	for event in hostEvents
		socket.on event, (data) ->
			console.log "event #{event} received", data
			if not validateRoomId(data) then return
			rooms[data.roomId].tanks[data.tankId]?.socket.emit "colorAssigned", data.color
	socket.on 'disconnect', (data) ->
		console.log 'userDisconnected', data
	socket.on 'error', (data) ->
		console.log('Error in socket', data, data.stack)
