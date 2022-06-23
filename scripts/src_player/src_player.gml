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

#region //ACTIONS
function actions() {
	if (PLAYER.HP > 0) {
		walking();
		jump();
	}
	
	collision_player();
	
	x += PLAYER.movement.horizontal;
	y += PLAYER.movement.vertical;
}

function walking() {
	var _horizontal_movement = PLAYER.key.right - PLAYER.key.left;
	PLAYER.movement.horizontal = (_horizontal_movement * PLAYER.speed.walk);
}

function jump() {	
	if (is_stepping_on_the_floor() && PLAYER.key.jump) {
		PLAYER.movement.vertical = -PLAYER.speed.jump;
	} 
}

#endregion

#region //BEHAVIORS
function gravity_player() {
	PLAYER.movement.vertical += gravity(PLAYER.mass);
}

function direct_player() {
	var has_horizontal_speed = PLAYER.movement.horizontal != 0;

	if (has_horizontal_speed) {
		PLAYER.xscale = sign(PLAYER.movement.horizontal);
		image_xscale = PLAYER.xscale;
	}
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
	//	weapon_follow_player();
		discard_weapon();
	}
	pickup_weapon();
}

function attack() {
	PLAYER.equipment.WEAPON.is_shooting = PLAYER.key.shot;
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
		var _speed = _player_speed == 0 ? 7 : 5 * _player_speed;
		PLAYER.equipment.speed = _speed;
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

function state_machine() {
	switch(PLAYER.state) {
		case ENTITY_STATES.IDLE:
			state_idle();
		break;
		case ENTITY_STATES.WALKING:
			state_walking();
		break;
		case ENTITY_STATES.JUMPING:
			state_jumping();
		break
		case ENTITY_STATES.DYING:
			state_dying();
		break;
		case ENTITY_STATES.DEAD:
			state_dead();
		break;
	}
}

function state_idle() {
	sprite_index = PLAYER.sprites.idle;
	
	if (PLAYER.key.left || PLAYER.key.right) {
		PLAYER.state = ENTITY_STATES.WALKING;
	} else if (PLAYER.key.jump) {
		PLAYER.state = ENTITY_STATES.JUMPING;
	}
	
	if (PLAYER.HP <= 0) {
		PLAYER.HP = 0;
		PLAYER.state = ENTITY_STATES.DYING;
	}
}

function state_walking() {
	sprite_index = PLAYER.sprites.walking;
	
	if (!PLAYER.key.left && !PLAYER.key.right) {
		PLAYER.state =  ENTITY_STATES.IDLE;
	} else if (PLAYER.key.jump) {
		PLAYER.state = ENTITY_STATES.JUMPING;
	}
	
	direct_player();
}

function state_jumping() {
	if (PLAYER.movement.vertical > 0) {
		// caindo
		sprite_index = PLAYER.sprites.falling;
	} else {
		// subindo
		sprite_index = PLAYER.sprites.jumping;
	}
	
	if (is_stepping_on_the_floor()) {
		PLAYER.state = ENTITY_STATES.IDLE;
	}
}

function state_dying() {
	sprite_index = PLAYER.sprites.dying;
	
	if (PLAYER.HP == 0) {
		direction = PLAYER.hit_direction;
		PLAYER.movement.horizontal = lengthdir_x(3, direction);	
		PLAYER.movement.vertical = lengthdir_y(3, direction) - 4;
		
		show_debug_message(PLAYER.movement.horizontal);
		
		if (sign(PLAYER.movement.horizontal) != 0) { image_xscale = sign(PLAYER.movement.horizontal) *(-1); } 
	}

	if (is_stepping_on_the_floor() && PLAYER.movement.vertical >= 0) {
		PLAYER.state = ENTITY_STATES.DEAD;
	}
	
	PLAYER.HP = noone;
}

function state_dead() {
	sprite_index = PLAYER.sprites.dead;
	PLAYER.movement.horizontal = 0;
}

#endregion
