function weapon() {
	WEAPON.cooldown--;
	if (WEAPON.recoil > 0) { WEAPON.recoil--; }

	slowing_down();
	collision_weapon();

	y += WEAPON.movement.vertical;

	if (WEAPON.is_being_carried) {
		follow_target();
			
		if (WEAPON.is_shooting) {
			shoot();
			weapon_recoil();
		}
	}
}

function follow_target() {
	x = WEAPON.target.x + (x_distance * 5) * image_yscale;
	y = WEAPON.target.y + 10;
}

function follow_mouse_direction() {
	image_angle = point_direction(x, y, mouse_x, mouse_y);
}

function follow_player() {
	var _player = instance_find(obj_player, 0);
	if (instance_exists(_player)) {
		if (_player.x < x) { image_yscale = -image_yscale; }
		if (point_distance(_player.x, _player.y, x, y) < 600) {
			WEAPON.target.ENEMY.countdown--;
			image_angle = point_direction(x, y, _player.x, _player.y);
			
			if (WEAPON.target.ENEMY.countdown <= 0) {
				WEAPON.target.ENEMY.countdown = WEAPON.target.countdown;
				
				// entre a arma do inimigo e o jogar existe uma parede?
				var _has_block_between_weapon_and_player = !collision_line(x, y, _player.x, _player.y, obj_block, false, false);
				
				if (_has_block_between_weapon_and_player && _player.ENTITY.HP) {
					shoot();
				}	
			}
		}
	}
}

function shoot() {
	if (WEAPON.cooldown <= 0) {
		WEAPON.recoil = recoil;
		WEAPON.cooldown = firing_cooldown * room_speed;
		
		screen_shake(2, 10);
		
		show_debug_message(mouse_x);
		
		if (WEAPON.ammo) {
			var _diff = 12;
			var _x_offset = lengthdir_x(_diff, image_angle);
			var _y_offset = lengthdir_y(_diff, image_angle);
			
			var _shot = instance_create_layer(x + _x_offset, y + _y_offset, "bullets", bullet);
				
			_shot.speed = firing_speed;
			_shot.direction = image_angle + random_range(-inprecision, inprecision);
			_shot.image_angle = _shot.direction;
			_shot.BULLET.shooter = WEAPON.target;
			
			//WEAPON.ammo--;
		}
	}
}

function weapon_recoil() {
	x -= lengthdir_x(WEAPON.recoil, image_angle);
	y -= lengthdir_y(WEAPON.recoil, image_angle);
}

function slowing_down() {
	if (speed > 0) {
		if (place_meeting(x + hspeed, y, obj_block)) { hspeed *= -0.1; }
		if (place_meeting(x, y + vspeed, obj_block)) { vspeed *= -0.1; }
		
		speed *= 0.9;
		if (speed <= 0.1 ) { speed = 0; } 
	}
}

function gravity_weapon() {
	if (!WEAPON.is_being_carried) {
		WEAPON.movement.vertical += gravity(WEAPON.mass);
	}
}

function collision_weapon() {
	WEAPON.movement.horizontal = detect_collide("x", WEAPON.movement.horizontal, 0, obj_block);
	WEAPON.movement.vertical = detect_collide("y", 0, WEAPON.movement.vertical, obj_block);
}

function should_be_reflect() {
	return image_angle >= 90 && image_angle <= 270;
}

function reflect() {
	if (should_be_reflect()) {
		image_yscale = -1;
	} else {
		image_yscale = 1;
	}
}