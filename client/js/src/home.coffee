$ ->
	getRooms = ->
		$.getJSON("/rooms").success (rooms) ->
			html = ""
			for room in rooms
				html += """
					<li><a href="/joinroom/#{room}">#{room}</a></li>
				"""
			$("#rooms").html(html)
	setInterval getRooms, 5000
	getRooms()


	$('#create-room').click ->
		$.post("/createroom").success (data) ->
			console.log 'room created', data
		.error (err) ->
			console.error 'OOps', err
		no