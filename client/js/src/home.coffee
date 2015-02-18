$ ->
	timeout = 5000
	getRooms = ->
		$.getJSON("/rooms").success (rooms) ->
			html = ""
			for roomId, room of rooms
				html += """
					<li>
						Room ##{roomId} Host: #{if room.host.socket then '+' else '-'} Tanks: #{Object.keys(room.tanks).length}
						<a href="/m##{roomId}">Join</a>&nbsp;<a href="/hostroom/#{roomId}">Host</a>
					</li>
				"""
			$("#rooms").html(html)
			setTimeout getRooms, timeout
	setTimeout getRooms, timeout
	getRooms()