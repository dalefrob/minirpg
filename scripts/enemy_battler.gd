# represents the enemy battler in the battle screen
extends Battler
class_name EnemyBattler

@export var took_damage_sound : AudioStream
@export var attack_notify_sound : AudioStream
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal disintegrated

var enemy : Enemy:
	get: return actor as Enemy

@onready var sprite : Sprite2D = $Sprite2D

func _initialize(_actor : Actor):
	super._initialize(_actor)
	actor.full_heal()
	await ready
	sprite.texture = enemy.texture


func attack_cue_visual():
	flash(Color.TRANSPARENT, 0.8)
	if attack_notify_sound:
		audio.stream = attack_notify_sound
		audio.play()
		await audio.finished


func _get_anim_position():
	return global_position


func _on_actor_took_damage(damage : Damage):
	# TODO - play audio as part of 'battle animations'
	audio.stream = took_damage_sound
	audio.play()
	await flash()
	var amount = damage.amount
	BattleHelper.show_floating_text(self, str(amount), Color.WHITE, Vector2.ZERO, damage.critical)
	queue_redraw()


func _on_actor_healed_damage(damage : Damage):
	var amount = damage.amount
	BattleHelper.show_floating_text(self, str(amount), Color.LIME)
	queue_redraw()


func _on_actor_health_depleted():
	print("%s was defeated" % name)
	disintegrate()


# flash the sprite a color to signify a status change
func flash(color : Color = Color.WHITE, duration : float = 0.2):
	var shader_mat = sprite.material as ShaderMaterial
	var transparent = color
	transparent.a = 0
	
	var set_shadermat_color = func(color):
		shader_mat.set_shader_parameter("solid_color", color)
	
	var tween = create_tween()
	tween.tween_method(set_shadermat_color, color, transparent, duration)
	tween.play()
	await tween.finished


func disintegrate():
	sprite.self_modulate = Color(0.460, 0, 0)
	# lambda func
	var rot = func(t):
		sprite.rotation = sin(4*t)/8
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 1.0)
	tween.tween_method(rot, 0.0, 10.0, 1.0)
	tween.tween_property(sprite, "scale:y", 0.01, 1.0)
	tween.play()
	await tween.finished
	hide()
	disintegrated.emit()


func _draw() -> void:
	draw_string(ThemeDB.fallback_font, Vector2.ZERO, str(enemy.hp), HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.RED)
