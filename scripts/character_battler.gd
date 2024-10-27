extends Battler
class_name CharacterBattler

var character_ui : CharacterUI

func _initialize(_actor : Actor):
	super._initialize(_actor)
	player_controlled = true

func _get_anim_position():
	return character_ui.global_position + Vector2(character_ui.size.x / 2, 0)

func _on_actor_took_damage(damage : Damage):
	var amount = damage.amount
	var randx = randi_range(-48, 48)
	var offset =  Vector2((character_ui.size.x / 2) + randx, -48)
	BattleHelper.show_floating_text(character_ui, str(amount), Color.WHITE, offset, damage.critical)
	character_ui.hit_animation()

func _on_actor_healed_damage(damage : Damage):
	var amount = damage.amount
	var offset =  Vector2((character_ui.size.x / 2), -48)
	BattleHelper.show_floating_text(character_ui, str(amount), Color.LIME, offset)

func flash(color : Color = Color.WHITE, duration : float = 0.2):
	var shader_mat = character_ui.portrait.material as ShaderMaterial
	var transparent = color
	transparent.a = 0
	
	var set_shadermat_color = func(color):
		shader_mat.set_shader_parameter("solid_color", color)
	
	var tween = create_tween()
	tween.tween_method(set_shadermat_color, color, transparent, duration)
	tween.play()
	await tween.finished
