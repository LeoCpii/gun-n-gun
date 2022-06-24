#region //INPUT
function input_check() {
	ENTITY.key.jump = keyboard_check(ENTITY.key_map.jump);
	ENTITY.key.down = keyboard_check(ENTITY.key_map.down);
	ENTITY.key.left = keyboard_check(ENTITY.key_map.left);
	ENTITY.key.right = keyboard_check(ENTITY.key_map.right);
	ENTITY.key.shot = mouse_check_button(mb_left);
	ENTITY.key.discart = keyboard_check_released(ENTITY.key_map.discart);
	ENTITY.key.pickup = keyboard_check_released(ENTITY.key_map.pickup);
}
#endregion

#region //ACTIONS
function actions() {
	if (ENTITY.HP > 0) {
		walking();
		jump();
	}
	
	if (ENTITY.equipment) {
		attack();
	}
	
	collision_player();
	
	x += ENTITY.movement.horizontal;
	y += ENTITY.movement.vertical;
}

function walking() {
	var _horizontal_movement = ENTITY.key.right - ENTITY.key.left;
	ENTITY.movement.horizontal = (_horizontal_movement * ENTITY.speed.walk);
}

function jump() {	
	if (is_stepping_on_the_floor() && ENTITY.key.jump) {
		ENTITY.movement.vertical = -ENTITY.speed.jump;
	} 
}

#endregion

#region //BEHAVIORS
function gravity_player() {
	ENTITY.movement.vertical += gravity(ENTITY.mass);
}

function direct_player() {
	var has_horizontal_speed = ENTITY.movement.horizontal != 0;

	if (has_horizontal_speed) {
		ENTITY.xscale = sign(ENTITY.movement.horizontal);
		image_xscale = ENTITY.xscale;
	}
}
#endregion

#region //COLLISION
function collision_player() {
	ENTITY.movement.horizontal = detect_collide("x", ENTITY.movement.horizontal, 0);
	ENTITY.movement.vertical = detect_collide("y", 0, ENTITY.movement.vertical);
}
#endregion

#region //WEAPON

function attack() {
	ENTITY.equipment.WEAPON.is_shooting = ENTITY.key.shot;
}

function can_i_discard_weapon() {
	var has_objects_in_contact = false;

	with(ENTITY.equipment) {
		has_objects_in_contact = place_meeting(x + hspeed, y, obj_block);
	}
		
	return !has_objects_in_contact;
}

function discard_weapon() {
	var _player_speed = abs(ENTITY.movement.horizontal);
	var _speed = _player_speed == 0 ? 7 : 5 * _player_speed;
	ENTITY.equipment.speed = _speed;
	ENTITY.equipment.direction = ENTITY.equipment.image_angle;
	ENTITY.equipment.WEAPON.is_being_carried = noone;
	ENTITY.equipment.WEAPON.target = noone;
	ENTITY.equipment = noone;
}

function pickup_weapon() {
	var pickup_list = ds_list_create();
	var pickup_count = collision_circle_list(x, y, ENTITY.contact_area, obj_weapon, false, true, pickup_list, true);
	
	if (pickup_count > 0) {
			if (ENTITY.equipment == noone && !pickup_list[| 0].WEAPON.target) {
				ENTITY.equipment = pickup_list[| 0];
				ENTITY.equipment.WEAPON.target = id;
				ENTITY.equipment.WEAPON.is_being_carried = true;
			}
		}
	
	ds_list_destroy(pickup_list);
}

#endregion

#region //STATE_MACHINE

function state_machine() {
	switch(ENTITY.state) {
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
	sprite_index = ENTITY.sprites.idle;
	
	if (ENTITY.key.left || ENTITY.key.right) {
		ENTITY.state = ENTITY_STATES.WALKING;
	} else if (ENTITY.key.jump) {
		ENTITY.state = ENTITY_STATES.JUMPING;
	}
	
	if (ENTITY.HP <= 0) {
		ENTITY.HP = 0;
		ENTITY.state = ENTITY_STATES.DYING;
		screen_shake(6, 25);
	}
}

function state_walking() {
	sprite_index = ENTITY.sprites.walking;
	
	if (!ENTITY.key.left && !ENTITY.key.right) {
		ENTITY.state =  ENTITY_STATES.IDLE;
	} else if (ENTITY.key.jump) {
		ENTITY.state = ENTITY_STATES.JUMPING;
	}
	
	direct_player();
}

function state_jumping() {
	if (ENTITY.movement.vertical > 0) {
		// caindo
		sprite_index = ENTITY.sprites.falling;
	} else {
		// subindo
		sprite_index = ENTITY.sprites.jumping;
	}
	
	if (is_stepping_on_the_floor()) {
		ENTITY.state = ENTITY_STATES.IDLE;
	}
}

function state_dying() {
	sprite_index = ENTITY.sprites.dying;
	
	if (ENTITY.HP == 0) {
		direction = ENTITY.hit_direction;
		ENTITY.movement.horizontal = lengthdir_x(3, direction);	
		ENTITY.movement.vertical = lengthdir_y(3, direction) - 4;
		
		show_debug_message(ENTITY.movement.horizontal);
		
		if (sign(ENTITY.movement.horizontal) != 0) { image_xscale = sign(ENTITY.movement.horizontal) *(-1); } 
	}

	if (is_stepping_on_the_floor() && ENTITY.movement.vertical >= 0) {
		ENTITY.state = ENTITY_STATES.DEAD;
	}
	
	ENTITY.HP = noone;
}

function state_dead() {
	sprite_index = ENTITY.sprites.dead;
	ENTITY.movement.horizontal = 0;
}

#endregion
