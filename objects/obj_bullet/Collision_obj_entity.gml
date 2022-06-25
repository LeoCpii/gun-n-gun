var _entity_hp = 0;
var _shooter = BULLET.shooter;
var _should_destroy = false;

with (other) {
	_entity_hp = ENTITY.HP;
	if (id != _shooter && ENTITY.HP) {
		take_damage(other.direction, KNOCKBACK_TYPE.HIT);
		_should_destroy = true;
	}
}

if (_entity_hp && _should_destroy) {
	instance_destroy();
}