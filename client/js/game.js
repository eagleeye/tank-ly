var mut = mut || {}; // MUltiplayer Tanks

mut.CreateGame = function(onCreate) {

	var game = new Phaser.Game(800, 600, Phaser.AUTO, '', {
		preload: preload,
		create: create,
		update: update,
		render: render
	});

	var players = {};

	function preload() {
		game.load.image('logo', '../resources/phaser.png');

		game.load.atlas('tank', '../resources/tanks.png', '../resources/tanks.json');
		game.load.atlas('enemy', '../resources/enemy-tanks.png', '../resources/tanks.json');
		game.load.image('logo', '../resources/logo.png');
		game.load.image('bullet', '../resources/bullet.png');
		game.load.image('earth', '../resources/light_grass.png');
		game.load.spritesheet('kaboom', '../resources/explosion.png', 64, 64, 23);
	}

	function create() {

		game.world.setBounds(0, 0, 800, 600);

		var land = game.add.tileSprite(0, 0, 800, 600, 'earth');
		land.fixedToCamera = true;

//		var logo = game.add.sprite(game.world.centerX, game.world.centerY, 'logo');
//		logo.anchor.setTo(0.5, 0.5);

		onCreate && onCreate(game);
	}

	function update() {
		_.each(players, function(player) {
			var tank = player.tank;
			var turret = player.turret;

			if (player.input.forward) {
				player.currentSpeed = 300;
			} else {
				player.currentSpeed = 0;
			}

			game.physics.arcade.velocityFromRotation(tank.rotation, player.currentSpeed, tank.body.velocity);

//			shadow.x = tank.x;
//			shadow.y = tank.y;
//			shadow.rotation = tank.rotation;

			turret.x = tank.x;
			turret.y = tank.y;

//			turret.rotation = game.physics.arcade.angleToPointer(turret);
			turret.rotation = tank.rotation;

		});
	}

	function render() {

	}

	game.AddPlayer = function(playerID, name, color) {

		var x = game.world.randomX;
		var y = game.world.randomY;

		var tank = game.add.sprite(x, y, 'tank', 'tank1');
		tank.anchor.setTo(0.5, 0.5);
		tank.animations.add('move', ['tank1', 'tank2', 'tank3', 'tank4', 'tank5', 'tank6'], 20, true);

		var turret = game.add.sprite(x, y, 'tank', 'turret');
		turret.anchor.setTo(0.3, 0.5);

		game.physics.enable(tank, Phaser.Physics.ARCADE);
		tank.body.drag.set(0.2);
		tank.body.maxVelocity.setTo(400, 400);
		tank.body.collideWorldBounds = true;

		players[playerID] = {
			name: name,
			color: color,
			tank: tank,
			turret: turret,
			currentSpeed: 0,
			input: {}
		};

		return players[playerID];
	};

	game.PlayerCommand = function(playerID, cmd) {
		var player = players[playerID];
		cmd = (cmd && cmd.code || "").split("_");
		switch(cmd[0]) {
			case "press": player.input[cmd[1]] = true; break;
			case "unpress": player.input[cmd[1]] = false; break;
		};
	};

};
