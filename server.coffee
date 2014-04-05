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
	socket.on 'registerFile', (data) ->
		console.log data
		data.fileUrl = "/files/" + data.fileId
		files[data.fileId] = data
		io.sockets.emit "fileRegistered", data
		fileOwners[data.fileId] = socket
	socket.on 'disconnect', ->
		io.sockets.emit('user disconnected')

app.get /^\/files\/(\d+)$/, (req, res) ->
	fileId = parseInt(req.params[0], 10)
	if not _.has(fileOwners, fileId) or not _.has(files, fileId)
		res.end("File not found")
		return
	file = files[fileId]
	res.setHeader('Content-disposition', "attachment; filename=#{file.name}");
	res.setHeader('Content-type', file.type)
	res.setHeader('Content-Length', file.size)
	senderSocket = fileOwners[fileId]
	senderSocket.emit "startTransmit", fileId: fileId
	senderSocket.on 'fileChunk', (data) ->
		if data.fileId isnt fileId then return
		if data.end
			res.end()
		else
			res.write(new Buffer(data.payload, "binary"))
			senderSocket.emit "startTransmit", fileId: fileId, last: data.last
console.log "Server running at http://localhost:3000"