$ ->
	timeout = 5000
	getRooms = ->
		$.getJSON("/rooms").success (rooms) ->
			html = ""
			for roomId, room of rooms
				html += """
					<li>
						Room ##{roomId} #{if room.host.socket then 'Host exists' else """<a href="/hostroom/#{roomId}">Host this room</a>"""} Tanks: #{Object.keys(room.tanks).length}
						<a href="/m/#{roomId}">Join</a>&nbsp;
					</li>
				"""
			$("#rooms").html(html)
			setTimeout getRooms, timeout
	setTimeout getRooms, timeout
	getRooms()