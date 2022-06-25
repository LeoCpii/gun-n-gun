var entity_hp = 0;
with (other) {
	entity_hp = ENTITY.HP;
	if (ENTITY.HP) {
		take_damage(other.direction, "hit");
	}
}

if (entity_hp) {
	instance_destroy();
}