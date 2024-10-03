extends Battler
class_name CharacterBattler

var character_ui : CharacterUI

func _get_anim_position():
	character_ui.get_screen_position()
	return character_ui.position + Vector2((character_ui.size.x / 2),0)

func _on_actor_took_damage(amount : int):
	var randx = randi_range(-48, 48)
	var offset =  Vector2((character_ui.size.x / 2) + randx, -48)
	BattleHelper.show_floating_text(character_ui, str(amount), Color.WHITE, offset)
	character_ui.hit_animation()

func _on_actor_healed_damage(amount : int):
	var offset =  Vector2((character_ui.size.x / 2), -48)
	BattleHelper.show_floating_text(character_ui, str(amount), Color.LIME, offset)
