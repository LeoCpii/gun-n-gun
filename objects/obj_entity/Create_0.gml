enum ENTITY_STATES {
	IDLE,
	WALKING,
	JUMPING,
	DYING,
	DEAD
}

ENTITY = {
	is_this_the_player: is_this_the_player,
	HP: HP,
	flash: 0,
	hit_direction: 0,
	state: ENTITY_STATES.IDLE,
	key_map: {
		jump: ord("W"),
		down: ord("S"), 
		left: ord("A"),
		right: ord("D"),
		shot: ord("J"),
		discart: ord("F"),
		pickup: ord("E")
	},
	key: {
		jump: -1,
		down: -1, 
		left: -1,
		right: -1,
		shot: -1,
		discart: -1,
		pickup: -1
	},
	skin: {
		glasses: 0,
		face: 0,
		hat: 0
	},
	movement: {
		horizontal: 0,
		vertical: 0
	},
	speed: {
		walk: 4,
		run: 6,
		jump: 7
	},
	mass: 1,
	equipment: noone,
	contact_area: 50,
	xscale: 1,
	sprites: {
		idle: noone,
		walking: noone,
		jumping: noone,
		falling: noone,
		dying: noone,
		dead: noone
	}
}