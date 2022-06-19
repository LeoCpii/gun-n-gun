#region //INPUT
function input_check() {
	PLAYER.key.jump = keyboard_check(PLAYER.key_map.jump);
	PLAYER.key.down = keyboard_check(PLAYER.key_map.down);
	PLAYER.key.left = keyboard_check(PLAYER.key_map.left);
	PLAYER.key.right = keyboard_check(PLAYER.key_map.right);
	PLAYER.key.shot = keyboard_check(PLAYER.key_map.shot);
	PLAYER.key.discart = keyboard_check(PLAYER.key_map.discart);
	PLAYER.key.pickup = keyboard_check(PLAYER.key_map.pickup);
}
#endregion

#region //MOVEMENT
function movements() {
	walking();
	jump();
	
	collision();
	
	x += PLAYER.movement.horizontal;
	y += PLAYER.movement.vertical;
}

function walking() {
	var _horizontal_movement = PLAYER.key.right - PLAYER.key.left;
	PLAYER.movement.horizontal = (_horizontal_movement * PLAYER.speed.walk);
}

function is_stepping_on_the_floor() {
	return place_meeting(x, y + 1, obj_block);
}

function jump() {	
	if (is_stepping_on_the_floor()) {
		if (PLAYER.key.jump) {
			PLAYER.movement.vertical = -PLAYER.speed.jump;
		}
	} 
}

function gravity() {
	if (!is_stepping_on_the_floor()) {
		PLAYER.movement.vertical += GRAVITY * PLAYER.mass;
	} 
}
#endregion

#region //COLLISION
function will_collide(axis) {
	return axis == "x"
		? place_meeting(x + PLAYER.movement.horizontal, y, obj_block)
		: place_meeting(x, y + PLAYER.movement.vertical, obj_block);
}

function is_colliding(axis) {
	return axis == "x"
		? place_meeting(x + sign(PLAYER.movement.horizontal), y, obj_block)
		: place_meeting(x, y + sign(PLAYER.movement.vertical), obj_block);
}

function detect_collide(axis) {
	if (will_collide(axis)) {
		while !is_colliding(axis) {
			if axis == "x" {
				x += sign(PLAYER.movement.horizontal);
			} else {
				y += sign(PLAYER.movement.vertical);
			}
		}
		
		if axis == "x" {
			PLAYER.movement.horizontal = 0;
		} else {
			PLAYER.movement.vertical = 0;
		}
	}
}

function collision() {
	detect_collide("x");
	detect_collide("y");
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
	
	image_xscale = xscale * (-1);
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