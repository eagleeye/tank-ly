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
n = 1
#ticker = require("fps")()
#ticker.on 'data', (framerate) => console.log("rate", ticker.rate);
console.log("Server started on port #{port} http://localhost:#{port}")
rooms = {}
for roomId in [1..10]
	rooms[roomId] = host: {}, tanks: {}
colors = "green aqua blue violet red yellow lightgreen brown".split(" ")
nicknames = "Sindy Dora Albert Zak Peter Mike John Alice".split ' '

app.get '/', (req, res) ->
	res.render 'home'

app.get '/m/:roomId', (req, res) ->
	res.render 'player', {roomId: req.params.roomId}
app.get '/bot/:roomId', (req, res) ->
	res.render 'bot', {roomId: req.params.roomId}

app.get '/joinroom/:roomId', (req, res) ->
	roomId = req.params.roomId
	if not rooms[roomId]
		return res.status(404).send({error: "Room #{roomId} not found"})
	tankId = uuid.v4()
	rooms[roomId].tanks[tankId] = color: _.sample(colors), tankId: tankId, nickname: _.sample(nicknames)
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

app.get '/rooms/:roomId', (req, res) ->
	roomId = req.params.roomId
	if not rooms[roomId]
		return res.status(404).send({error: "Room #{roomId} not found"})
	tanks = for tankId, tank of rooms[roomId].tanks
		_.pick(tank, ["tankId", "color", "nickname"])
	res.json tanks

app.use (err, req, res, next) ->
	console.error('Uncaught error', err)
	res.status(500).send({error: 'Internal server error', code: err.name, stack: err?.stack})

validateRoomId = (data, event) ->
	if not data or not data.roomId or not rooms[data.roomId]
		console.error "room with id #{data?.roomid} not found, #{event}"
		no
	else yes

io.sockets.on 'connection', (socket) ->
	console.log "new connection #{socket.id}"
	socket.on 'host', (data) ->
		console.log 'host connected', data
		if not validateRoomId(data) then return
		rooms[data.roomId].host.socket = socket

	controllerEvents = "move stop fire".split ' '
	controllerEvents.forEach (event) ->
		console.log "Setting up events for #{event} #{socket.id}"
		socket.on event, (data) ->
#			ticker.tick()
#			console.log "#{event} event received", ++n
			rooms[data.roomId]?.host?.socket?.emit event, data
			rooms[data.roomId]?.tanks[data.tankId] = {} unless rooms[data.roomId].tanks[data.tankId]
			rooms[data.roomId]?.tanks[data.tankId].socket = socket unless rooms[data.roomId].tanks[data.tankId].socket

	socket.on 'connected', (data) ->
		console.log "connected ", data
		rooms[data.roomId].host?.socket?.emit 'connected', _.pick rooms[data.roomId].tanks[data.tankId], ['tankId', 'color', 'nickname']

	socket.on 'scoreUpdated', (data) ->
#		console.log "event scoreUpdates received", data
		unless validateRoomId(data) then return
		rooms[data.roomId].tanks[data.tankId]?.socket.emit 'scoreUpdated', data
	socket.on 'disconnect', (data) ->
		console.log 'userDisconnected', data
		for roomId, room of rooms
			for tankId, tank of room.tanks
				if tank.socket?.id is socket.id
					console.log "Disconnected tank found #{roomId} #{tankId}"
					room.host.socket?.emit "disconnected", tankId: tankId
	socket.on 'error', (data) ->
		console.log('Error in socket', data, data.stack)
