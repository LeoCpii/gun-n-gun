var _enemy_has_life = true;

with (other) {
	_enemy_has_life = ENTITY.HP;
}

if (_enemy_has_life) { take_damage(0, KNOCKBACK_TYPE.CONTACT); };
