extends Sprite2D
class_name EnemyBattler

@export var enemy : Enemy:
	set(value):
		enemy = value
		enemy.took_damage.connect(on_took_damage)
		enemy.hp_depleted.connect(on_hp_depleted)
	get:
		return enemy 

func on_took_damage(dmg):
	flash()

func on_hp_depleted():
	disintergrate()

# flash the sprite a color to signify a status change
func flash(color : Color = Color.RED, duration : float = 0.5):
	self_modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.WHITE, duration)
	tween.play()

func disintergrate():
	self_modulate = Color(0.460, 0, 0)
	# lambda func
	var rot = func(t):
		rotation = sin(4*t)/8
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 1.0)
	tween.tween_method(rot, 0.0, 10.0, 1.0)
	tween.tween_property(self, "scale:y", 0.01, 1.0)
	tween.play()
