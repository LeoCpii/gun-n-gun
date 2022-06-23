draw_self();

if (global.DEBUG) {
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_text(x, y - sprite_height * 1.2, PLAYER.flash);
	draw_set_valign(-1);
	draw_set_halign(-1);
}

if (PLAYER.flash > 0) {
	PLAYER.flash--;
	shader_set(sh_white); 
	draw_self();
	shader_reset();
}


