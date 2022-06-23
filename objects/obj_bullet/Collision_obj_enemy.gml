with (other) {
	PLAYER.HP--;
	PLAYER.flash = 3;
	PLAYER.hit_direction = other.direction;
}

instance_destroy();