# animated battle animation to be used for skills and ailments
# for now, uses animated sprites like RPG maker, but may extend into particle effects
extends Node2D
class_name BattleAnimation

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal finished

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_player_finished)
	animation_player.play()

func on_animation_player_finished(_anim_name):
	finished.emit()
