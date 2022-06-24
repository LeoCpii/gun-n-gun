if (!instance_exists(obj_player)) { exit; }

x = lerp(x, CAMERA.target.x, 0.1);
y = lerp(y, CAMERA.target.y - (CAMERA.height / 4), 0.1);

// Screen shake
x += random_range(-CAMERA.shake.remain, CAMERA.shake.remain);
y += random_range(-CAMERA.shake.remain, CAMERA.shake.remain);
CAMERA.shake.remain = max(0, CAMERA.shake.remain - ((1 / CAMERA.shake.length) * CAMERA.shake.magnitude));

_x = x - (CAMERA.width / 2) + CAMERA.buff;
_y = y - (CAMERA.height / 2) + CAMERA.buff;

camera_set_view_pos(view_camera[0], _x, _y);