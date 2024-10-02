# represents the enemy battler in the battle screen
extends Battler
class_name EnemyBattler

signal disintegrated

var enemy : Enemy:
	get: return actor as Enemy

@onready var sprite : Sprite2D = $Sprite2D

func _initialize():
	super._initialize()
	await ready
	sprite.texture = enemy.texture

func _on_actor_took_damage(damage : int):
	super._on_actor_took_damage(damage)
	
	# TODO - play audio as part of 'battle animations'
	$AudioStreamPlayer2D.play()
	flash()
	print("%s took %s damage" % [name, damage])

func _on_actor_health_depleted():
	print("%s was defeated" % name)
	disintegrate()


# flash the sprite a color to signify a status change
func flash(color : Color = Color.RED, duration : float = 0.5):
	sprite.self_modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, duration)
	tween.play()

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
	disintegrated.emit()
