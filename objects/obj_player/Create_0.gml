event_inherited();

selected_skin = select_skin(skin);

ENTITY.sprites = {
	idle: selected_skin.idle,
	walking: selected_skin.walking,
	jumping: selected_skin.jumping,
	falling: selected_skin.falling,
	dying: selected_skin.dying,
	dead: selected_skin.dead,
	knockback: selected_skin.knockback
}
