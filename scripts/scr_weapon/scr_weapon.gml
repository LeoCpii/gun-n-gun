function weapon() {
	WEAPON.cooldown--;
	if (WEAPON.recoil > 0) { WEAPON.recoil--; }

	slowing_down();
	collision_weapon();

	y += WEAPON.movement.vertical;

	if (WEAPON.is_being_carried) {
		follow_target();
		follow_mouse_direction();
		
		if (WEAPON.is_shooting) {
			weapon_recoil();
			shoot();
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

function shoot() {
	if (WEAPON.cooldown <= 0) {
		WEAPON.recoil = recoil;
		WEAPON.cooldown = firing_cooldown * room_speed;
		
		if (WEAPON.ammo) {			
			var _shot = instance_create_layer(x, y, "entities", bullet);
				
			_shot.speed = firing_speed;
			_shot.direction = image_angle + random_range(-inprecision, inprecision);
			_shot.image_angle = _shot.direction;
			
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
	WEAPON.movement.horizontal = detect_collide("x", WEAPON.movement.horizontal, 0);
	WEAPON.movement.vertical = detect_collide("y", 0, WEAPON.movement.vertical);
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