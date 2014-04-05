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

window.onload = function() {

	mut.CreateGame(function(game) {

//		var socket = io.connect(window.location.origin);
//		socket.on('move', function(data) {
//			return console.log('move', data);
//		});

		//	socket.on('news', function (data) {
		//		console.log(data);
		//		socket.emit('my other event', { my: 'data' });
		//	});

		// will listen to game events later, for now just improvise

		game.AddPlayer(0, "Player 1", "red");
		game.AddPlayer(1, "Player 2", "green");
		game.AddPlayer(2, "Player 3", "blue");

		var cmds = ["press_forward", "press_left", "press_fire", "unpress_left", "unpress_forward", "unpress_fire"];
		var cmdInd = 0;

		setInterval(function() {
			var pid = 0;

			var cmd = {
				code: cmds[cmdInd++]
			}
			if (cmdInd === cmds.length) {
				cmdInd = 0;
			}

			game.PlayerCommand(pid, cmd);

		}, 500);

	});



}
