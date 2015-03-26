// 1. /index
//    - setup and start game
//    - shows list of active games
// 2. /game/:id
//    - shows battlefied
//    - shows qr code for users to join: /game/:id/join
//    - waits for users to join
//    - can start/pause game
//    - shows scores
// 3. /game/:id/join
//    - shows join screen to select name/color/stats
//    - has "join" button
// resolution: implement later if time permits


// 1. /index
//    - battle - displays current state
// 2. /controller
//    - joins to game at once at random


// battle:
// - connects to server using sockect.io
// - for each connection creates a player
// - listens for events, applies them to player
var socket;
window.onload = function() {

	mut.CreateGame(function(game) {

		socket = io.connect(window.location.origin);
		socket.on('connect', function() {
			socket.emit('host', {roomId: window.roomId});
		});
		socket.on('connected', function(data) {
			game.AddPlayer(data.tankId, null, data.color);
		});
		socket.on('move', function(data) {
			game.EnsurePlayer(data.tankId);
			var cmd = {
				code: "move",
				direction: data.direction
			};
			game.PlayerCommand(data.tankId, cmd);
		});
		socket.on('fire', function(data) {
			game.EnsurePlayer(data.tankId);
			var cmd = {
				code: "press_fire"
			};
			game.PlayerCommand(data.tankId, cmd);
		});
		socket.on('stop', function(data) {
			game.EnsurePlayer(data.tankId);
			var cmd = {
				code: "stop"
			};
			game.PlayerCommand(data.tankId, cmd);
		});

		// Bots
		var cmds = ["press_top", "press_left", "press_fire", "unpress_left", "unpress_top", "press_fire"];
		var cmdInd = 0;
		var pid = 0;
		game.AddPlayer(pid, "Bot " + (pid+1));

		setInterval(function() {
			var cmd = {	code: cmds[cmdInd++] };
			if (cmdInd === cmds.length) {
				cmdInd = 0;
			}
			for (var i = 0; i <= pid; i++) {
				game.PlayerCommand(i, cmd);
			}
		}, 500);

//		setInterval(function() {
//			pid++;
//			game.AddPlayer(pid, "Bot " + (pid+1));
//		}, 1500);

	});
};
