# represents the enemy battler in the battle screen
extends Sprite2D
class_name EnemyBattler

signal disintegrated

@export var enemy : Enemy:
	set(value):
		enemy = value
		initialize()
	get:
		return enemy 

@export var hp : int
@export var mp : int

var is_dead : bool

func initialize():
	texture = enemy.texture
	hp = enemy.get_max_hp()
	mp = enemy.get_max_mp()

func take_hit(damage : int):
	hp -= damage
	if hp <= 0:
		hp = 0
		print("%s was defeated" % name)
		is_dead = true
		disintegrate()
	else:
		flash()
		print("%s took %s damage" % [name, damage])


# flash the sprite a color to signify a status change
func flash(color : Color = Color.RED, duration : float = 0.5):
	self_modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.WHITE, duration)
	tween.play()

func disintegrate():
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
	await tween.finished
	disintegrated.emit()
