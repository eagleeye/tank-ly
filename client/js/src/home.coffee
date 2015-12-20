$ ->
#	$('.navigation').smint();

	timeout = 5000
	getRooms = ->
		$.getJSON("/rooms").success (rooms) ->
			html = ""
			for roomId, room of rooms
				html += """
					<li>
						<span class="room-number"> Room ##{roomId}</span> <span class="join-room">#{if room.host.socket then 'Host exists' else """<a href="/hostroom/#{roomId}">Host this room</a>"""}</span> Tanks: #{room.tanks}
						<a href="/m/#{roomId}" target='_blank'>Join</a>&nbsp;
						<a href="/bot/#{roomId}" target='_blank'>Add bot</a>&nbsp;
						<a href="/qr/#{roomId}" target='_blank'>QR code</a>&nbsp;
					</li>
				"""
			$("#rooms").html(html)
			setTimeout getRooms, timeout
	setTimeout getRooms, timeout
	getRooms()