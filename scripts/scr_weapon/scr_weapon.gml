function weapon() {
	WEAPON.cooldown--;
	if (WEAPON.recoil > 0) { WEAPON.recoil--; }
	if (WEAPON.is_being_carried && WEAPON.is_shooting) {
		shoot();
		weapon_recoil();
	}
	slowing_down();
	
	collision_weapon();
	x += WEAPON.movement.horizontal;
	y += WEAPON.movement.vertical;
}

function shoot() {
	if (WEAPON.cooldown <= 0) {
		WEAPON.recoil = recoil;
		WEAPON.cooldown = firing_cooldown * room_speed;
		
		if (WEAPON.ammo) {
			var _x = lengthdir_x(sprite_height, image_angle);
			var _y = lengthdir_y(sprite_width, image_angle);
			var _shot = instance_create_layer(x + _x, y + _y, layer, bullet);
			
			_shot.speed = firing_speed;
			_shot.direction = image_angle + random_range(-inprecision, inprecision);
			
			WEAPON.ammo--;
		}
	}
}

function weapon_recoil() {
	x -= lengthdir_x(WEAPON.recoil, image_angle);
	y -= lengthdir_y(WEAPON.recoil, image_angle);
}

function slowing_down() {
	if (speed > 0) {
		speed *= 0.98;
		if (speed <= 2 ) { speed = 0; } 
	}
}

function gravity_weapon() {
	if (!WEAPON.is_being_carried) {
		WEAPON.movement.vertical += gravity(WEAPON.mass);
	}
}

function collision_weapon() {
	WEAPON.movement.horizontal = detect_collide("x", WEAPON.movement.horizontal, 0);
	WEAPON.movement.vertical = detect_collide("y", 0, WEAPON.movement.vertical);
}