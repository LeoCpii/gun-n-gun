draw_self();

function draw_life() {
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);

	draw_set_font(fnt_small);
	draw_set_color(c_white);
	draw_text(x, y - (sprite_height / 2), ENTITY.HP);

	draw_set_valign(-1);
	draw_set_halign(-1);
}

if (ENTITY.flash > 0) {
	ENTITY.flash--;
	shader_set(sh_white); 
	draw_self();
	shader_reset();
}

draw_life();