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
	collision_player();
	
	if (ENTITY.HP) {
		var _should_intance_weapon = !ENTITY.equipment && ENTITY.starting_weapon
	
		if (ENTITY.equipment) { attack(); }
		else {
			if (_should_intance_weapon) { instance_weapon(); }
		}

		jump();
	}
	
	x += ENTITY.movement.horizontal;
	y += ENTITY.movement.vertical;
}

function walking(horizontal_movement) {
	ENTITY.movement.horizontal = (horizontal_movement * ENTITY.speed.walk);
}

function jump() {	
	if (is_stepping_on_the_floor() && ENTITY.key.jump) {
		ENTITY.movement.vertical = -ENTITY.speed.jump;
	} 
}

function take_damage(dir, type) {
	ENTITY.HP--;
	ENTITY.flash = 3;
	ENTITY.hit_direction = dir;
	ENTITY.knockback.speed = 5;
	ENTITY.knockback.type = type;
	
	if (ENTITY.HP > 0) {
		ENTITY.state = ENTITY_STATES.KNOCKBACK;
	}
}
#endregion

#region //BEHAVIORS
function gravity_entity() {
	ENTITY.movement.vertical += gravity(ENTITY.mass);
}

#endregion

#region //COLLISION
function collision_player() {
	ENTITY.movement.horizontal = detect_collide("x", ENTITY.movement.horizontal, 0, obj_block);
	ENTITY.movement.vertical = detect_collide("y", 0, ENTITY.movement.vertical, obj_block);
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
			set_weapon(pickup_list[| 0]);
		}
	}
	
	ds_list_destroy(pickup_list);
}

function instance_weapon() {
	var _weapon = instance_create_layer(x, y, "guns", ENTITY.starting_weapon);
	set_weapon(_weapon);
}

function set_weapon(o_weapon) {
	ENTITY.equipment = o_weapon;
	ENTITY.equipment.WEAPON.target = id;
	ENTITY.equipment.WEAPON.is_being_carried = true;
	var testx = lengthdir_x(x, direction);
	var testy = lengthdir_y(y, direction);
	ENTITY.equipment.image_angle = point_direction(x, y, x + testx, y + testy);	
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
		case ENTITY_STATES.KNOCKBACK:
			state_knockback();
		break;
		default:
			ENTITY.state = ENTITY_STATES.IDLE;
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
		screen_shake(6, 25);
		ENTITY.HP = 0;
		ENTITY.state = ENTITY_STATES.DYING;
	}
}

function state_walking() {
	sprite_index = ENTITY.sprites.walking;
	
	if (!ENTITY.key.left && !ENTITY.key.right) {
		ENTITY.state =  ENTITY_STATES.IDLE;
	} else if (ENTITY.key.jump) {
		ENTITY.state = ENTITY_STATES.JUMPING;
	}
	
	if (ENTITY.HP <= 0) {
		screen_shake(6, 25);
		ENTITY.HP = 0;
		ENTITY.state = ENTITY_STATES.DYING;
	}
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
	
	if (ENTITY.HP <= 0) {
		screen_shake(6, 25);
		ENTITY.HP = 0;
		ENTITY.state = ENTITY_STATES.DYING;
	}
}

function state_dying() {
	sprite_index = ENTITY.sprites.dying;
	
	if (ENTITY.HP == 0) {
		if (ENTITY.knockback.type == KNOCKBACK_TYPE.HIT) {
			direction = ENTITY.hit_direction;
			ENTITY.movement.horizontal = lengthdir_x(3, direction);	
		}
		
		if (ENTITY.knockback.type == KNOCKBACK_TYPE.CONTACT) {
			ENTITY.movement.horizontal = lengthdir_x(3, direction) * -ENTITY.xscale;	
		}

		ENTITY.movement.vertical = lengthdir_y(3, direction) - 4;
		
		if (sign(ENTITY.movement.horizontal) != 0) { image_xscale = sign(ENTITY.movement.horizontal) * (-1); } 
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

function state_knockback() {
	sprite_index = ENTITY.sprites.knockback;
	direction = ENTITY.hit_direction;
	
	if (ENTITY.knockback.type == KNOCKBACK_TYPE.HIT) {
		var _dir = lengthdir_x(ENTITY.knockback.speed, direction)
		image_xscale = -sign(_dir);
		ENTITY.movement.horizontal = _dir;
	}
	
	if (ENTITY.knockback.type == KNOCKBACK_TYPE.CONTACT) {
		ENTITY.movement.horizontal = ENTITY.knockback.speed * -image_xscale;
	}
	
	ENTITY.knockback.speed = approach(ENTITY.knockback.speed, 0, 0.25);
	
	if (ENTITY.knockback.speed == 0) {
		ENTITY.movement.horizontal = 0;
		ENTITY.state = ENTITY_STATES.IDLE;
	}
}

function approach(current, target, amount) {
	if (current < target) {
		current += amount;
		current = min(current, target);
	} else {
		current -= amount;
		current = max(current, target);
	}
	
	return current;
}

#endregion