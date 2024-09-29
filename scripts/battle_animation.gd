# animated battle animation to be used for skills and ailments
# for now, uses animated sprites like RPG maker, but may extend into particle effects
extends Node2D
class_name BattleAnimation

@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D

signal finished

func _ready() -> void:
	anim_sprite.animation_finished.connect(on_animation_finished, CONNECT_ONE_SHOT)
	anim_sprite.play()

func on_animation_finished():
	finished.emit()
	queue_free()
