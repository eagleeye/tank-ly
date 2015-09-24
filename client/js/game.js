var mut = mut || {}; // MUltiplayer Tanks
var width = window.innerWidth;
var height = window.innerHeight;
var scale = 0.5;
var colors = ['green', 'lightgreen', 'aqua', 'blue', 'darkviolet', 'red', 'yellow'];

var game, last;

mut.CreateGame = function(onCreate) {

	game = new Phaser.Game(width, height, Phaser.AUTO, '', {
		preload: preload,
		create: create,
		update: update,
		render: render
	});

	var players = {};

	var maxColorId = 7;
	var maxHp = 3;

	var explosions;

	function preload() {
		game.stage.disableVisibilityChange = true;

		game.load.image('logo', '../resources/phaser.png');

		for (var i = 1; i <= maxColorId; i++) {
			game.load.atlas('tank_' + i, '../resources/tanks_' + i + '.png', '../resources/tanks.json');
		}
		game.load.atlas('enemy', '../resources/enemy-tanks.png', '../resources/tanks.json');
		game.load.image('logo', '../resources/logo.png');
		game.load.image('bullet', '../resources/bullet.png');
		game.load.image('earth', '../resources/light_grass.png');
		game.load.spritesheet('kaboom', '../resources/explosion.png', 64, 64, 23);
	}

	function create() {
		game.world.setBounds(0, 0, width, height);
		game.world.scale = new Phaser.Point(scale, scale);

		var land = game.add.tileSprite(0, 0, width / scale, height / scale , 'earth');
		land.fixedToCamera = true;

		explosions = game.add.group();
		for (var i = 0; i < 20; i++)
		{
			var explosionAnimation = explosions.create(0, 0, 'kaboom', [0], false);
			explosionAnimation.anchor.setTo(0.5, 0.5);
			explosionAnimation.animations.add('kaboom');
		}

		onCreate && onCreate(game);
	}

	function update() {

		newTime = new Date();
		//console.log(1000 / (newTime - last));
		last = newTime;

		var livePlayers = _.filter(players, function(p) {
			return p.alive;
		});

		_.each(livePlayers, function(player) {
			var tank = player.tank;
			//var turret = player.turret;
			//var shadow = player.shadow;
			var input = player.input;
			var currentSpeed = player.currentSpeed;

			input.left && (tank.angle -= 4);
			input.right && (tank.angle += 4);
			input.top && (currentSpeed += 40);
			input.bottom && (currentSpeed -= 40);

			if (input.moveDir) {
				currentSpeed += 40;
				var targetAngle = -input.moveDir.angle;
				tank.angle = targetAngle;
			}

			currentSpeed = Math.min(currentSpeed, 400);
			currentSpeed = Math.max(currentSpeed, -200);

			if (!input.top && !input.moveDir && currentSpeed > 0) {
				currentSpeed -= 7;
				currentSpeed = Math.max(currentSpeed, 0);
			}
			if (!input.bottom && currentSpeed < 0) {
				currentSpeed += 7;
				currentSpeed = Math.min(currentSpeed, 0);
			}

			player.currentSpeed = currentSpeed;

			game.physics.arcade.velocityFromRotation(tank.rotation, currentSpeed, tank.body.velocity);

			if (input.fire) {
				fireBullet(player);
				delete input.fire;
			}
		});

		// Collisions
		var arr = _.toArray(livePlayers);
		for (var i = 0; i < arr.length - 1; i++) {
			for (var j = i + 1; j < arr.length; j++) {
				var player1 = arr[i];
				var player2 = arr[j];
				game.physics.arcade.collide(player1.tank, player2.tank);
			}
		}

		// Bullet hits
		_.each(livePlayers, function(player) {
			_.each(livePlayers, function(enemy) {
				if (player === enemy) {
					return;
				}

				game.physics.arcade.overlap(player.bullets, enemy.tank, bulletHitEnemy);

				function bulletHitEnemy(tank, bullet) {
					bullet.kill();
					enemy.hp -= 1;
					if (enemy.hp === 0) {

						player.score++;
						player.scoreText.text = player.name + " - " + player.score + " ";
						socket.emit('scoreUpdated', {tankId: player.id, score: player.score, roomId: roomId});
						sortScores();

						enemy.alive = false;

						enemy.tank.exists = false;
						enemy.turret.exists = false;
						enemy.shadow.exists = false;
						enemy.respawn = game.time.now + 2000;

						var explosionAnimation = explosions.getFirstExists(false);
						explosionAnimation.reset(tank.x, tank.y);
						explosionAnimation.play('kaboom', 30, false, true);
					}
				}
			});
		});

		// Respawns
		_.each(players, function(player) {
			if (!player.alive && game.time.now > player.respawn && !_.isEmpty(player.input)) {
				player.alive = true;
				player.hp = maxHp;
				delete player.respawn;
				var x = game.world.randomX / scale;
				var y = game.world.randomY / scale;
				_.each(['tank', 'turret', 'shadow'], function(prop) {
					player[prop].exists = true;
					player[prop].reset(x, y);
				});
			}
		});

		// updates of parts
		_.each(livePlayers, function(player) {
			_.each(['turret', 'shadow'], function(prop) {
				player[prop].x = player.tank.x;
				player[prop].y = player.tank.y;
				player[prop].rotation = player.tank.rotation;
			});
		});
	}

	function sortScores() {
		var sorted = _.sortBy(players, function(p) { return -p.score;} );
		_.each(sorted, function(p, index) {
			p.scoreText.y = index * 40;
		});
	}

	function render() {
	}

	game.EnsurePlayer = function(playerID, nickname, color) {
		if (!players[playerID]) {
			game.AddPlayer(playerID, nickname, color);
		}
	};

	var playersNumber = 1;

	game.AddPlayer = function(playerID, name, color) {

		name = name || "Player " + playersNumber++;

		var x = game.world.randomX / scale;
		var y = game.world.randomY / scale;

		var colorId = (colors.indexOf(color) + 1) || 1; //in case if get 0 somehow
		var spriteName = 'tank_' + colorId;

		var shadow = game.add.sprite(x, y, spriteName, 'shadow');
		shadow.anchor.setTo(0.5);

		var tank = game.add.sprite(x, y, spriteName, 'tank1');
		tank.anchor.setTo(0.5, 0.5);
		tank.animations.add('move', ['tank1', 'tank2', 'tank3', 'tank4', 'tank5', 'tank6'], 20, true);

		var turret = game.add.sprite(x, y, spriteName, 'turret');
		turret.anchor.setTo(0.3, 0.5);

		game.physics.enable(tank, Phaser.Physics.ARCADE);
		tank.body.drag.set(0.2);
		tank.body.maxVelocity.setTo(400, 400);
		tank.body.collideWorldBounds = true;

		var style = { font: "bold 40px Arial", fill: colors[colorId-1], align: "left"};
		var t = game.add.text(game.world.bounds.width / scale - 300, _.size(players) * 40, name + " ", style);
		t.setShadow(3, 3, "black", 2);

		players[playerID] = {
			id: playerID,
			name: name,
			color: colorId,
			tank: tank,
			turret: turret,
			shadow: shadow,
			currentSpeed: 0,
			fireRate: 300,
			nextFire: 0,
			alive: true,
			score: 0,
			scoreText: t,
			hp: maxHp,
			input: {},
			bullets: createBullets()
		};

		return players[playerID];
	};

	game.removePlayer = function(tankId) {
		players[tankId].scoreText.destroy();
		players[tankId].tank.destroy();
		players[tankId].shadow.destroy();
		players[tankId].turret.destroy();
		delete players[tankId];
		sortScores();
		return players;
	};

	game.PlayerCommand = function(playerID, cmd) {
		var player = players[playerID];
		var code = (cmd && cmd.code || "").split("_");
		switch(code[0]) {
			case "press": player.input[code[1]] = true; break;
			case "unpress": player.input[code[1]] = false; break;
			case "stop": player.input = {}; break;
			case "move": player.input.moveDir = { angle: cmd.direction }; break;
		};
	};

	function createBullets() {
		var bullets = game.add.group();
		bullets.enableBody = true;
		bullets.physicsBodyType = Phaser.Physics.ARCADE;
		bullets.createMultiple(5, 'bullet', 0, false);
		bullets.setAll('anchor.x', 0.5);
		bullets.setAll('anchor.y', 0.5);
		bullets.setAll('outOfBoundsKill', true);
		bullets.setAll('checkWorldBounds', true);
		return bullets;
	}

	function fireBullet(player) {
		if (game.time.now > player.nextFire && player.bullets.countDead() > 0) {
			player.nextFire = game.time.now + player.fireRate;
			var bullet = player.bullets.getFirstExists(false);
			bullet.reset(player.turret.x, player.turret.y);
			bullet.rotation = player.tank.rotation;
			game.physics.arcade.velocityFromRotation(bullet.rotation, 1000, bullet.body.velocity);
		}
	}

};
