#region //INPUT
function input_check() {
	PLAYER.key.jump = keyboard_check(PLAYER.key_map.jump);
	PLAYER.key.down = keyboard_check(PLAYER.key_map.down);
	PLAYER.key.left = keyboard_check(PLAYER.key_map.left);
	PLAYER.key.right = keyboard_check(PLAYER.key_map.right);
	PLAYER.key.shot = mouse_check_button(mb_left);
	PLAYER.key.discart = keyboard_check_released(PLAYER.key_map.discart);
	PLAYER.key.pickup = keyboard_check_released(PLAYER.key_map.pickup);
}
#endregion

#region //MOVEMENT
function movements() {
	walking();
	jump();
	
	collision_player();
	
	x += PLAYER.movement.horizontal;
	y += PLAYER.movement.vertical;
}

function walking() {
	var _horizontal_movement = PLAYER.key.right - PLAYER.key.left;
	PLAYER.movement.horizontal = (_horizontal_movement * PLAYER.speed.walk);
}

function jump() {	
	if (is_stepping_on_the_floor()) {
		if (PLAYER.key.jump) {
			PLAYER.movement.vertical = -PLAYER.speed.jump;
		}
	} 
}

function gravity_player() {
	PLAYER.movement.vertical += gravity(PLAYER.mass);
}
#endregion

#region //COLLISION
function collision_player() {
	PLAYER.movement.horizontal = detect_collide("x", PLAYER.movement.horizontal, 0);
	PLAYER.movement.vertical = detect_collide("y", 0, PLAYER.movement.vertical);
}
#endregion

#region //WEAPON

function character_weapon() {
	if (PLAYER.equipment) {
		attack();
		weapon_follow_player();
		discard_weapon();
	}
	pickup_weapon();
}

function attack() {
	PLAYER.equipment.WEAPON.is_shooting = PLAYER.key.shot;
}

function weapon_follow_player() {
	var _direction = point_direction(x, y, mouse_x, mouse_y * 1.1);
	var _x = x + lengthdir_x(sprite_height / 2.5, _direction);
	var _y = y + lengthdir_y(sprite_width / 2.5, _direction);
		
	PLAYER.equipment.x = _x;
	PLAYER.equipment.y = _y - (sprite_height / 3);
	PLAYER.equipment.image_angle = _direction;
}

function can_i_discard_weapon() {
	var has_objects_in_contact = false;
	
	with(PLAYER.equipment) {			
		has_objects_in_contact = place_meeting(x + hspeed, y, obj_block);
	}
		
	return !has_objects_in_contact;
}

function discard_weapon() {
	var can_discard = can_i_discard_weapon();
	if (PLAYER.key.discart && can_discard) {
		var _player_speed = abs(PLAYER.movement.horizontal);
		PLAYER.equipment.speed = _player_speed == 0 ? 5 : 2 * _player_speed;
		PLAYER.equipment.direction = PLAYER.equipment.image_angle;
		PLAYER.equipment.WEAPON.is_being_carried = noone;
		PLAYER.equipment.WEAPON.target = noone;
		PLAYER.equipment = noone;
	}
}

function pickup_weapon() {
	if (PLAYER.key.pickup) {
		var pickup_list = ds_list_create();
		var pickup_count = collision_circle_list(x, y, PLAYER.contact_area, obj_weapon, false, true, pickup_list, true);
		
		if (pickup_count > 0) {
			if (PLAYER.equipment == noone) {
				PLAYER.equipment = pickup_list[| 0];
				PLAYER.equipment.WEAPON.target = id;
				PLAYER.equipment.WEAPON.is_being_carried = true;
			}
		}
		
		ds_list_destroy(pickup_list);
	}
}

#endregion

#region //STATE_MACHINE

function state_machine(spr_idle, spr_walking, spr_jumping) {
	switch(PLAYER.state) {
		case ENTITY_STATES.IDLE:
			state_idle(spr_idle);
		break;
		case ENTITY_STATES.WALKING:
			state_walking(spr_walking);
		break;
		case ENTITY_STATES.JUMPING:
			state_jumping(spr_jumping);
		break;
	}
}

function state_idle(spr_idle) {
	sprite_index = spr_idle;
	
	if (PLAYER.key.left || PLAYER.key.right) {
		PLAYER.state = ENTITY_STATES.WALKING;
	} else if (PLAYER.key.jump) {
		PLAYER.state = ENTITY_STATES.JUMPING;
	}
}

function state_walking(spr_walking) {
	sprite_index = spr_walking;
	
	if (!PLAYER.key.left && !PLAYER.key.right) {
		PLAYER.state =  ENTITY_STATES.IDLE;
	} else if (PLAYER.key.jump) {
		PLAYER.state = ENTITY_STATES.JUMPING;
	}
	
	var has_horizontal_speed = PLAYER.movement.horizontal != 0;

	if (has_horizontal_speed) {
		xscale = sign(PLAYER.movement.horizontal);
	}
	
	//image_xscale = xscale * (-1);
}

function state_jumping(spr_jumping) {
	if (PLAYER.movement.vertical > 0) {
		sprite_index = spr_jumping;
		
		if (image_index >= image_number - 1) {
			image_index = image_number - 1;
		}
	}
	
	if (is_stepping_on_the_floor()) {
		PLAYER.state = ENTITY_STATES.IDLE;
	}
}

#endregion
