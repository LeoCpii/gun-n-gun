draw_self();

draw_set_valign(fa_middle);
draw_set_halign(fa_center);

draw_set_font(fnt_small);
draw_text(x + sprite_width / 2, y - sprite_height * 2, WEAPON.ammo);

draw_set_valign(-1);
draw_set_halign(-1);
