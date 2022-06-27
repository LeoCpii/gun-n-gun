enum PLAYER_SKIN {
	BASE,
	DOG
}

function select_skin(selected) {
	var _base = {
		idle: spr_player_base_idle,
		walking: spr_player_base_walking,
		jumping: spr_player_base_jumping,
		falling: spr_player_base_falling,
		dying: spr_character_dying,
		dead: spr_character_dead,
		knockback: spr_player_base_knockback
	}
	
	var _dog = {
		idle: spr_player_dog_idle,
		walking: spr_player_dog_walking,
		jumping: spr_player_dog_jumping,
		falling: spr_player_dog_falling,
		dying: spr_character_dying,
		dead: spr_character_dead,
		knockback: spr_player_base_knockback
	}
	
	var _skin = [_base, _dog];
	
	return _skin[selected];
}