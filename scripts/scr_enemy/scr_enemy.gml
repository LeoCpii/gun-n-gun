function enemy_actions() {
	if (ENTITY.HP) {
		if (ENTITY.equipment) {
			if (ENEMY.see_player) {
				with (ENTITY.equipment) { aim_the_player(); }
				
				if (ENEMY.target.ENTITY.HP) {
					//follow_player();
					attack_player();
				}
			}
			field_of_view();
		}
	} else {
		if (ENTITY.equipment) { discard_weapon(); }
	}
}

function field_of_view() {
	var _angle = { degress: 5, direction: 1	};
	var _dir = ENTITY.equipment.image_angle;
	ENEMY.see_player = false;

	for (var i = 0; i <= ray_count; i++) {
	    for (var j = 0; j < ray_length; j++) {
		    var _xx = x + lengthdir_x(j, _dir);
		    var _yy = y + lengthdir_y(j, _dir);
		
			if (position_empty(_xx, _yy) == false) {
				if (instance_place(_xx, _yy, obj_block) != noone) {
					break;
				}
				
				if (instance_place(_xx, _yy, obj_player) != noone) {
					ENEMY.see_player = true;
					ENEMY.target = instance_place(_xx, _yy, obj_player);
					break;
				}
			}
		}
	
		_dir += ((_angle.degress * i) * _angle.direction);
		_angle.direction *= -1;
	}
}

function attack_player() {
	ENEMY.countdown--;
	
	if (ENEMY.countdown <= 0) {
		ENEMY.countdown = countdown;
		
		if (ENEMY.target.ENTITY.HP) {
			ENTITY.equipment.WEAPON.is_shooting = true;
		}	
	}
}

function follow_player() {
	ENTITY.state = ENTITY_STATES.WALKING;
	point_direction(x, y, ENEMY.target.x, ENEMY.target.y);
	move_towards_point(ENEMY.target.x, ENEMY.target.y, ENTITY.speed.walk);
}