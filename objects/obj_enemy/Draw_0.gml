event_inherited();

function draw_field_of_view() {
	var _angle = { degress: 5, direction: 1	};
	var _dir = ENTITY.equipment.image_angle;

	for (var i = 0; i <= ray_count; i++) {
	    for (var j = 0; j < ray_length; j++) {
		    var _xx = x + lengthdir_x(j, _dir);
		    var _yy = y + lengthdir_y(j, _dir);
		
			if (position_empty(_xx, _yy) == false) {
				if (instance_place(_xx, _yy, obj_block) != noone) {
					draw_set_color(c_red);
					draw_circle(_xx, _yy, 2, false);
					break;
				}

				if (instance_place(_xx, _yy, obj_player) != noone) {
					draw_set_color(c_red);
					draw_circle(_xx, _yy, 2, false);
					break;
				}
			}
			
			draw_set_color(c_lime);
			draw_point(_xx, _yy);
		}
	
		_dir += ((_angle.degress * i) * _angle.direction);
		_angle.direction *= -1;
	}
}

if (ENEMY.see_player) {
	draw_sprite(spr_alert, 0, x, y - 16);
}

if (global.DEBUG) {
	if (ENTITY.HP) {
		draw_field_of_view();
	}
}