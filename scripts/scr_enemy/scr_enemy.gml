function enemy_actions() {
	if (ENTITY.HP) {
		if (ENTITY.equipment) {
			with (ENTITY.equipment) {
				//follow_player();
			}
		}
	} else {
		if (ENTITY.equipment) {
			discard_weapon();
		}
	}
}