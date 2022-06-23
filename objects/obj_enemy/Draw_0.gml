event_inherited();

function draw_life() {
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);

	draw_set_font(fnt_small);
	draw_text(x, y - (sprite_height / 2), PLAYER.HP);

	draw_set_valign(-1);
	draw_set_halign(-1);
}

draw_life();