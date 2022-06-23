function is_stepping_on_the_floor() {
	return place_meeting(x, y + 1, obj_block);
}

function gravity(mass) {
	if (!is_stepping_on_the_floor()) {
		return GRAVITY * mass;
	} else {
		return 0;
	}
}

#region //COLLISION
function will_collide(axis, horizontal_speed, vertical_speed) {
	return axis == "x"
		? place_meeting(x + horizontal_speed, y, obj_block)
		: place_meeting(x, y + vertical_speed, obj_block);
}

function is_colliding(axis, horizontal_speed, vertical_speed) {
	return axis == "x"
		? place_meeting(x + sign(horizontal_speed), y, obj_block)
		: place_meeting(x, y + sign(vertical_speed), obj_block);
}

function detect_collide(axis, horizontal_speed, vertical_speed) {
	if (will_collide(axis, horizontal_speed, vertical_speed)) {
		while !is_colliding(axis, horizontal_speed, vertical_speed) {
			if (axis == "x") {
				x += sign(horizontal_speed);
			} else {
				y += sign(vertical_speed);
			}
		}
		
		return 0;
	} else {
		return axis == "x" ? horizontal_speed : vertical_speed;
	}
}

#endregion