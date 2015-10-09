$ ->
#	$('.navigation').smint();

	timeout = 5000
	getRooms = ->
		$.getJSON("/rooms").success (rooms) ->
			html = ""
			for roomId, room of rooms
				html += """
					<li>
						Room ##{roomId} #{if room.host.socket then 'Host exists' else """<a href="/hostroom/#{roomId}">Host this room</a>"""} Tanks: #{room.tanks}
						<a href="/m/#{roomId}">Join</a>&nbsp;
						<a href="/bot/#{roomId}" target='_blank'>Bot</a>&nbsp;
					</li>
				"""
			$("#rooms").html(html)
			setTimeout getRooms, timeout
	setTimeout getRooms, timeout
	getRooms()