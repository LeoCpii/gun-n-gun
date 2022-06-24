
function screen_shake(magnitude, frames) {
	with (obj_camera) {
		if (magnitude > CAMERA.shake.remain) {
			CAMERA.shake.magnitude = magnitude;
			CAMERA.shake.remain = magnitude;
			CAMERA.shake.length = frames;
		}
	}
}
