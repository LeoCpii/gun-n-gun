function enemy_actions() {	
	if (ENTITY.HP < 0) {
		if (ENTITY.equipment) {
			discard_weapon();
		}
	} else {
		pickup_weapon();
	}
}