if (!instance_exists(obj_player)) { exit; }

x = lerp(x, CAMERA.target.x, 0.1);
y = lerp(y, CAMERA.target.y - (CAMERA.height / 4), 0.1);

camera_set_view_pos(view_camera[0], x - (CAMERA.width / 2), y - (CAMERA.height / 2));