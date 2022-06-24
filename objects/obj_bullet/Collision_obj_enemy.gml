with (other) {
	ENTITY.HP--;
	ENTITY.flash = 3;
	ENTITY.hit_direction = other.direction;
}

instance_destroy();