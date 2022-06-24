function player_actions() {
	var can_discard = can_i_discard_weapon();

	if (ENTITY.key.pickup) {
		pickup_weapon();
	}
	
	if (ENTITY.equipment) {
		with (ENTITY.equipment) {
			follow_mouse_direction();
		}
		
		if (ENTITY.key.discart && can_discard) {
			discard_weapon();
		}
	}
}