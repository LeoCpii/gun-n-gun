function player_actions() {
	if (ENTITY.HP) {
		direct_player();
		var _can_discard = can_i_discard_weapon();
	
		if (!ENTITY.knockback.speed) {
			var _horizontal_movement = ENTITY.key.right - ENTITY.key.left;
			walking(_horizontal_movement);
		}
		
		if (ENTITY.key.pickup) {
			pickup_weapon();
		}
	
		if (ENTITY.equipment) {
			with (ENTITY.equipment) {
				follow_mouse_direction();
			}
		
			if (ENTITY.key.discart && _can_discard) {
				discard_weapon();
			}
		}
	} else {
		if (ENTITY.equipment) {
			discard_weapon();
		}	
	}
}

function direct_player() {
	var _should_be_reflect = x > mouse_x;
	image_xscale = _should_be_reflect ? -1 : 1;
}