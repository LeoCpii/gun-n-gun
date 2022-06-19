draw_self();

if (global.DEBUG) {
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_text(x, y - sprite_height * 1.2, PLAYER.state);
	draw_set_valign(-1);
	draw_set_halign(-1);
}